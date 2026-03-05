import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';

class ChefBookingDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<Map<String, dynamic>?> order = Rx(null);

  // Status steps — order matters!
  static const List<String> statusSteps = [
    "Booking Ordered",
    "Chef Confirmed",
    "Groceries Ordered",
    "Booking Complete",
  ];

  // Map history type → step index
  static const Map<String, int> _typeToStep = {
    "Booking Ordered": 0,
    "Chef Confirmed": 1,
    "Groceries Ordered": 2,
    "Booking Completed": 3,
    "Booking Complete": 3,
  };

  // Returns 0-based current step index derived from history
  int get currentStep {
    final data = order.value;
    if (data == null) return 0;
    final history = data['history'] as List? ?? [];
    int maxStep = 0;
    for (final h in history) {
      final type = h['type'] as String? ?? "";
      final step = _typeToStep[type];
      if (step != null && step > maxStep) maxStep = step;
    }
    return maxStep;
  }

  Future<void> fetchOrder(String orderId) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(
        "${ApiEndPoint.singleOrder}/$orderId",
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        order.value = Map<String, dynamic>.from(response.data['data']);
      } else {
        Get.snackbar("Error",
            response.data?['message']?.toString() ?? "Something went wrong",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
