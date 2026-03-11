import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';

class RequestChangeChefController extends GetxController {
  final RxBool isLoading = false.obs;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> submitRequest({
    required String orderId,
    required String addressId,
  }) async {
    if (dateController.text.trim().isEmpty || timeController.text.trim().isEmpty) {
      Get.snackbar("Warning", "Please select date and time",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (orderId.isEmpty) {
      Get.snackbar("Error", "Order ID not found",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await ApiService.post(
        '${ApiEndPoint.requestChangeSchedule}$orderId',
        body: {
          "requested_date": _formatToISO(dateController.text.trim()),
          "requested_time": timeController.text.trim(),
          "address_id": addressId,
          "note": noteController.text.trim(),
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final home = Get.isRegistered<ChefHomeController>()
            ? Get.find<ChefHomeController>()
            : null;
        await home?.fetchUpcomingBookings();

        Get.back();
        Get.snackbar("Success", "Change request submitted successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar(
          "Error",
          response.data['message']?.toString() ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // "5 March 2027," → "2027-03-05"
  String _formatToISO(String displayDate) {
    try {
      displayDate = displayDate.replaceAll(',', '').trim();
      final parts = displayDate.split(' ');
      if (parts.length < 3) return displayDate;
      const months = [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final day = int.parse(parts[0]).toString().padLeft(2, '0');
      final monthIndex = months.indexOf(parts[1]);
      if (monthIndex == -1) return displayDate;
      final month = monthIndex.toString().padLeft(2, '0');
      final year = parts[2];
      return "$year-$month-$day";
    } catch (_) {
      return displayDate;
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    noteController.dispose();
    super.onClose();
  }
}