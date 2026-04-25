import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/services/api/api_service.dart';
import '../../../../../../utils/app_utils.dart';
import '../widgets/popup_here_data.dart';

class ConfirmedGroceryController extends GetxController {
  // Capture the list of Order IDs from the previous screen
  // This will handle both: a single ID in a list or multiple IDs
  final List<String> receivedOrderIds = Get.arguments is List
      ? List<String>.from(Get.arguments)
      : [];

  var isBookingConfirmed = true.obs;
  var selectedPartner = 'Instacart'.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Debug to verify you received the IDs
    debugPrint('Received Order IDs on Confirmation Screen: $receivedOrderIds');
  }

  Future<void> confirmGroceries() async {
    if (receivedOrderIds.isEmpty) return;

    try {
      isLoading.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xffFD713F))),
        barrierDismissible: false,
      );

      int successCount = 0;

      for (String id in receivedOrderIds) {
        try {
          final response = await ApiService.patch(
            // Ensure the path matches your API requirements
            'order/change-status/$id',
            body: {'status': 'Groceries Ordered'},
          );

          // Check if response was actually successful based on your API's structure
          if (response.statusCode == 200 || response.data['success'] == true) {
            successCount++;
          }
        } catch (e) {
          debugPrint('Failed to update Order ID $id: $e');
          // We don't 'throw' here so the loop continues to the next ID
        }
      }

      Navigator.pop(Get.context!); // Close loading indicator

      if (successCount == receivedOrderIds.length) {
        Utils.successSnackBar('Success', 'All groceries confirmed!');
        Get.offAllNamed(AppRoutes.customerHomeScreen);
      } else if (successCount > 0) {
        Utils.successSnackBar('Partial Success', '$successCount orders updated, some failed.');
      } else {
        Utils.errorSnackBar('Error', 'Could not update orders. Please try again.');
      }

    } finally {
      isLoading.value = false;
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const GroceryConfirmationPopup(),
    );
  }

  final List<Map<String, String>> partners = [
    {'name': 'Instacart', 'image': 'assets/images/instacart_logo.png'},
  ];
}