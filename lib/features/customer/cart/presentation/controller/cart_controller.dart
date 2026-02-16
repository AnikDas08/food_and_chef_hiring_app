import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

class CartController extends GetxController {
  bool isDefaultAddress = false;
  bool isExpanded = false;

  final TextEditingController dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  final List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "02:00 PM",
    "04:00 PM",
    "06:00 PM",
  ];

  void selectDate(DateTime date) {
    selectedDate = date;
    update();
  }

  void selectTime(String time) {
    selectedTime = time;
    String formattedDate = selectedDate.dateMonthYear;
    dateController.text = "$formattedDate, $time";

    Get.back();
    update();
  }

  onChangeDefaultAddress(value) {
    isDefaultAddress = value ?? false;
    update();
  }

  void onChangeExpanded() {
    isExpanded = !isExpanded;
    update();
  }
}
