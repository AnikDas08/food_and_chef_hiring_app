import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import 'package:flutter/material.dart';
import '../../data/wallet_model.dart';

class ChefPaymentController extends GetxController {
  bool isMainAccount = false;

  void onChangeMainAccount(value) {
    isMainAccount = value;
    update();
  }

  RxBool isAutoPayment = false.obs;
  RxBool isLoading = false.obs;
  RxDouble balance = 0.0.obs;
  RxDouble lastMonthPercentage = 0.0.obs;
  RxBool isUp = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallet();
  }

  void loadProfile(data) {
    isAutoPayment.value = data['auto_payment_enabled'] ?? false;
  }

  Future<void> fetchWallet() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(ApiEndPoint.wallet);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final walletModel = WalletModel.fromJson(response.data as Map<String, dynamic>);
        balance.value = walletModel.data.balance;
        lastMonthPercentage.value = walletModel.data.lastMonthPercentage;
        isUp.value = walletModel.data.isUp;
      } else {
        // Utils.errorSnackBar('Error', response.data['message'] ?? 'Failed to load wallet');
      }
    } catch (e) {
      // Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> autoPaymentToggle() async {
    final bool newValue = !isAutoPayment.value;
    isAutoPayment.value = newValue;

    final response = await ApiService.patch(
      ApiEndPoint.chefProfile,
      body: {
        'auto_payment_enabled': newValue.toString(),
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      Get.snackbar('Message', ' Automatic Payment Setting updated',
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      isAutoPayment.value = !newValue; // Revert
      Utils.errorSnackBar('Error', 'Failed to update auto payment setting');
    }
  }
}
