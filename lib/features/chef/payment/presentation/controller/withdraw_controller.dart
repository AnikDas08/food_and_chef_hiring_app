import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';

class WithdrawController extends GetxController {
  final amountController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxInt balance = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallet();
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  Future<void> fetchWallet() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(ApiEndPoint.wallet);

      if (response.statusCode == 200 && response.data['success'] == true) {
        balance.value = (response.data['data']?['balance'] ?? 0) as int;
      } else {
        Utils.errorSnackBar("Error", response.data['message'] ?? "Failed to load wallet");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> withdrawAmount() async {
    final text = amountController.text.trim();

    if (text.isEmpty) {
      Utils.errorSnackBar("Warning", "Please enter withdraw amount");
      return;
    }

    final amount = int.tryParse(text);
    if (amount == null || amount <= 0) {
      Utils.errorSnackBar("Warning", "Please enter a valid amount");
      return;
    }

    if (amount > balance.value) {
      Utils.errorSnackBar("Warning", "Insufficient balance");
      return;
    }

    try {
      isLoading.value = true;

      final response = await ApiService.post(
        ApiEndPoint.withdrawWallet,
        body: {"amount": amount},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // postman response: data.balance
        balance.value = (response.data['data']?['balance'] ?? balance.value) as int;
        amountController.clear();
        Utils.successSnackBar("Success", response.data['message'] ?? "Withdraw successful");
      } else {
        Utils.errorSnackBar("Error", response.data['message'] ?? "Withdraw failed");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}