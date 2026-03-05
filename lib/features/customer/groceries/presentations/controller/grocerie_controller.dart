import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../services/api/api_service.dart';

class GroceryController extends GetxController {
  final String? initialOrderId = Get.arguments?.toString();

  var isLoading = false.obs;
  var isIngredientsLoading = false.obs;
  var isInstacartLoading = false.obs;

  var availableOrders = <Map<String, dynamic>>[].obs;
  var basketItems = <Map<String, dynamic>>[].obs;
  var selectedOrderIds = <String>[].obs;
  var selectedPartner = "".obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    isLoading.value = true;
    await fetchAllOrders();
    if (initialOrderId != null && initialOrderId!.isNotEmpty) {
      selectedOrderIds.assign(initialOrderId!);
      await fetchIngredients();
    }
    isLoading.value = false;
  }

  Future<void> fetchAllOrders() async {
    try {
      final response = await ApiService.get("order?limit=50");
      if (response.statusCode == 200) {
        List allData = response.data['data'] ?? [];
        availableOrders.value = allData.where((order) {
          final status = order['status']?.toString();
          return status == "Confirm" || status == "Completed";
        }).toList().cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint("Orders Fetch Error: $e");
    }
  }

  Future<void> fetchIngredients() async {
    if (selectedOrderIds.isEmpty) {
      basketItems.clear();
      return;
    }
    isIngredientsLoading.value = true;
    try {
      String queryString = selectedOrderIds.map((id) => "orderId[]=$id").join("&");
      final response = await ApiService.get("cart/ingradients?$queryString");
      if (response.statusCode == 200) {
        List rawIngs = response.data['data'] ?? [];
        basketItems.value = rawIngs.map((e) => {
          'id': e['_id'],
          'name': e['name'],
          'items': e['quantity'],
          'unit': e['unit'],
          'isSelected': true,
        }).toList();
      }
    } catch (e) {
      debugPrint("Ingredients API Error: $e");
    } finally {
      isIngredientsLoading.value = false;
    }
  }

  void toggleOrderSelection(String id) {
    if (selectedOrderIds.contains(id)) {
      selectedOrderIds.remove(id);
    } else {
      selectedOrderIds.add(id);
    }
    fetchIngredients();
  }

  void toggleBasketItem(int index) {
    basketItems[index]['isSelected'] = !basketItems[index]['isSelected'];
    basketItems.refresh();
  }

  // YOUR ORIGINAL LOGIC: Triggered when icon is clicked
  Future<void> createInstacartLink() async {
    List selectedPayload = basketItems
        .where((item) => item['isSelected'] == true)
        .map((item) => {
      "name": item['name'],
      "quantity": item['items'].toString(),
      "unit": item['unit'],
      "_id": item['id'],
    }).toList();

    if (selectedPayload.isEmpty) {
      Get.snackbar("Basket Empty", "Please select ingredients first.");
      return;
    }

    isInstacartLoading.value = true;
    try {
      final response = await ApiService.post("cart/instacart-link",
          body: {"items": selectedPayload});

      if (response.statusCode == 200 && response.data['success']) {
        String url = response.data['data']['products_link_url'];
        await _launchBrowser(url);
      }
    } catch (e) {
      debugPrint("Instacart Link Error: $e");
    } finally {
      isInstacartLoading.value = false;
    }
  }

  Future<void> _launchBrowser(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Browser Error", "Could not open the link.");
    }
  }
}