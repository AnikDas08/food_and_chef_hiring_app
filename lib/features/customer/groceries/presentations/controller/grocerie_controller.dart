import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../services/api/api_service.dart';

class GroceryController extends GetxController {
  // Capture initial ID if coming from the Booking Details popup
  final String? initialOrderId = Get.arguments?.toString();

  // Loading States
  var isLoading = false.obs;             // For the initial order list
  var isIngredientsLoading = false.obs;  // For the basket section
  var isInstacartLoading = false.obs;    // For the API post call

  // Data Observables
  var availableOrders = <Map<String, dynamic>>[].obs;
  var basketItems = <Map<String, dynamic>>[].obs;
  var selectedOrderIds = <String>[].obs;
  var selectedPartner = "".obs; // "Instacart" or "Self"

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  /// Initial setup logic
  Future<void> initializeData() async {
    isLoading.value = true;

    // 1. Always fetch all orders to populate the selection list
    await fetchAllOrders();

    // 2. If we arrived with a specific ID, select it and fetch ingredients immediately
    if (initialOrderId != null && initialOrderId!.isNotEmpty) {
      selectedOrderIds.add(initialOrderId!);
      await fetchIngredients();
    }

    isLoading.value = false;
  }

  /// Scenario: Fetch all orders and filter for "Confirm" or "Completed"
  Future<void> fetchAllOrders() async {
    try {
      final response = await ApiService.get("order?limit=50");
      if (response.statusCode == 200) {
        List allData = response.data['data'] ?? [];

        // Filter: Match statuses that allow grocery ordering
        availableOrders.value = allData.where((order) {
          final status = order['status']?.toString();
          return status == "Confirm" || status == "Completed";
        }).toList().cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint("Orders Fetch Error: $e");
    }
  }

  /// Scenario: Fetch ingredients based on one or multiple selected Order IDs
  Future<void> fetchIngredients() async {
    if (selectedOrderIds.isEmpty) {
      basketItems.clear();
      return;
    }

    isIngredientsLoading.value = true;
    try {
      // Constructs query: cart/ingradients?orderId[]=ID1&orderId[]=ID2
      String queryString = selectedOrderIds.map((id) => "orderId[]=$id").join("&");

      final response = await ApiService.get("cart/ingradients?$queryString");

      if (response.statusCode == 200) {
        List rawIngs = response.data['data'] ?? [];
        basketItems.value = rawIngs.map((e) => {
          'id': e['_id'],
          'name': e['name'],
          'items': e['quantity'],
          'unit': e['unit'],
          'isSelected': true, // Default to selected for the basket
        }).toList();
      }
    } catch (e) {
      debugPrint("Ingredients API Error: $e");
    } finally {
      isIngredientsLoading.value = false;
    }
  }

  /// Toggles the selection of a Booking card
  void toggleOrderSelection(String id) {
    if (selectedOrderIds.contains(id)) {
      selectedOrderIds.remove(id);
    } else {
      selectedOrderIds.add(id);
    }

    // Every time selection changes, refresh the ingredients list
    fetchIngredients();
  }

  /// Toggles individual items inside the grocery basket
  void toggleBasketItem(int index) {
    basketItems[index]['isSelected'] = !basketItems[index]['isSelected'];
    basketItems.refresh();
  }

  /// Scenario: Hit the Instacart Link generation API
  Future<void> createInstacartLink() async {
    // 1. Filter only items currently "checked" in the UI list
    List selectedPayload = basketItems
        .where((item) => item['isSelected'] == true)
        .map((item) => {
      "name": item['name'],
      "quantity": item['items'].toString(),
      "unit": item['unit'],
      "_id": item['id'],
    })
        .toList();

    if (selectedPayload.isEmpty) {
      Get.snackbar("Basket Empty", "Please select at least one ingredient.");
      selectedPartner.value = "";
      return;
    }

    isInstacartLoading.value = true;
    try {
      final response = await ApiService.post("cart/instacart-link",
          body: {
        "items": selectedPayload,
      });

      if (response.statusCode == 200 && response.data['success']) {
        String url = response.data['data']['products_link_url'];
        await _launchBrowser(url);
      }
    } catch (e) {
      debugPrint("Instacart Link Error: $e");
      Get.snackbar("Error", "Failed to generate link. Try again.");
    } finally {
      isInstacartLoading.value = false;
    }
  }

  /// Helper: Opens the URL in the phone's external browser
  Future<void> _launchBrowser(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Browser Error", "Could not open the link.");
    }
  }
}