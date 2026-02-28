import 'package:get/get.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import 'package:flutter/material.dart';

class ChefPaymentController extends GetxController {

  bool isMainAccount = false;

  onChangeMainAccount(value) {
    isMainAccount = value;
    update();
  }

  RxBool isAutoPayment = false.obs;

  void loadProfile(data) {
    isAutoPayment.value = data['auto_payment_enabled'] ?? false;
  }


  Future<void> autoPaymentToggle() async {
    bool newValue = !isAutoPayment.value;
    isAutoPayment.value = newValue;

    var response = await ApiService.patch(
      ApiEndPoint.chefProfile,
      body: {
        "auto_payment_enabled": newValue.toString(),
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {

      Get.snackbar("Message", " Automatic Payment Setting updated",backgroundColor: Colors.green,colorText: Colors.white);
      // Success
    } else {
      isAutoPayment.value = !newValue; // Revert
      Utils.errorSnackBar("Error", "Failed to update auto payment setting");
    }
  }


}
