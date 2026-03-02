import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/popup_here_data.dart'; // Ensure this path is correct

class ConfirmedGroceryController extends GetxController {
  // Reactive state for UI toggle
  var isBookingConfirmed = true.obs;

  // Selected partner state
  var selectedPartner = "Instacart".obs;

  // Function to trigger the popup
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const GroceryConfirmationPopup(),
    );
  }

  // Partner data list
  final List<Map<String, String>> partners = [
    {"name": "Instacart", "image": "assets/images/instacart_logo.png"},
  ];
}