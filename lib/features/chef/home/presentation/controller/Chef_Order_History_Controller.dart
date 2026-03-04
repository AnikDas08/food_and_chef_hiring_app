import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';

class ChefOrderHistoryController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var orders = <Map<String, dynamic>>[].obs;
  var selectedOrder = Rxn<Map<String, dynamic>>();
  var isOrderDetailsPopup = false;

  var selectedStatus = 'Awaiting Confirmation'.obs;

  final List<String> statusTabs = [
    'Awaiting Confirmation',
    'Confirm',
    'Canceled',
    'Decline',
  ];

  int page = 1;
  int totalPage = 1;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }

  void selectOrder(Map<String, dynamic> order) {
    selectedOrder.value = order;
    isOrderDetailsPopup = false;
    update();
  }

  void changeTab(String status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    fetchOrders();
  }
  Future<void> fetchOrders({bool loadMore = false}) async {
    try {
      if (loadMore && (isLoadingMore.value || page >= totalPage)) return;

      if (loadMore) {
        isLoadingMore.value = true;
        page++;
      } else {
        isLoading.value = true;
        page = 1;
        totalPage = 1;
        orders.clear();
      }


      final encodedStatus = Uri.encodeComponent(selectedStatus.value);
      final url = '${ApiEndPoint.baseUrl}/order?status=$encodedStatus&page=$page&limit=$limit';

      final response = await ApiService.get(url);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(response.data['data'] ?? []);
        final pagination = response.data['pagination'];
        totalPage = pagination?['totalPage'] ?? 1;

        if (loadMore) {
          orders.addAll(data);
        } else {
          orders.assignAll(data);
        }
      }
    } catch (e) {
      debugPrint("❌ fetchOrders error: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Future<void> acceptOrder(String orderId) async {
  //   try {
  //     final url = '${ApiEndPoint.baseUrl}/order/$orderId/confirm';
  //     final response = await ApiService.put(url, {});
  //     if (response.statusCode == 200) {
  //       fetchOrders(); // list refresh
  //       Get.snackbar('Success', 'Order accepted!');
  //     }
  //   } catch (e) {
  //     debugPrint("❌ acceptOrder error: $e");
  //   }
  // }
  //
  // Future<void> declineOrder(String orderId) async {
  //   try {
  //     final url = '${ApiEndPoint.baseUrl}/order/$orderId/decline';
  //     final response = await ApiService.put(url, {"decline_reason": "Not Available"});
  //     if (response.statusCode == 200) {
  //       fetchOrders();
  //       Get.snackbar('Info', 'Order declined.');
  //     }
  //   } catch (e) {
  //     debugPrint("❌ declineOrder error: $e");
  //   }
  // }

  // ✅ Status badge color & bg
  Map<String, dynamic> getStatusStyle(String status) {
    switch (status) {
      case 'Awaiting Confirmation':
        return {'color': const Color(0xffE39400), 'bg': const Color(0xffF2E3C7)};
      case 'Confirm':
        return {'color': const Color(0xff4CAF50), 'bg': const Color(0xffE8F5E9)};
      case 'Canceled':
        return {'color': const Color(0xffF44336), 'bg': const Color(0xffFFEBEE)};
      case 'Decline':
        return {'color': const Color(0xff9E9E9E), 'bg': const Color(0xffF5F5F5)};
      default:
        return {'color': const Color(0xff777777), 'bg': const Color(0xffF2F2F2)};
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateStr).toLocal());
    } catch (_) {
      return '';
    }
  }

  String formatPrice(dynamic value) {
    if (value == null) return '\$0.00';
    return '\$${(value as num).toStringAsFixed(2)}';
  }

  int getStepIndex(String status) {
    switch (status) {
      case 'Awaiting Confirmation': return 1;
      case 'Confirm': return 2;
      default: return 0;
    }
  }
}