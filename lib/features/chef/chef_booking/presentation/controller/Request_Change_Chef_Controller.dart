import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
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
      Utils.errorSnackBar("Error", "Order ID not found");
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

        Navigator.pop(Get.context!);
        Utils.successSnackBar("Success", "Change request submitted successfully");
      } else {
        Utils.errorSnackBar(
          "Error",
          response.data['message']?.toString() ?? "Something went wrong",
        );
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
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