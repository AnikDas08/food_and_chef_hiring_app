import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RangeValues values = const RangeValues(20, 100);

  List<String> timeOption = ["Today", "Tomorrow", "This week", "Next week"];
  List<String> levelOption = [
    "No restaurant experience",
    "Restaurant experience",
    "Fine dining experience",
  ];

  List<String> selectTime = [];
  List<String> selectLevel = [];

  onChangeTime(String value) {
    if (selectTime.contains(value)) {
      selectTime.remove(value);
      update();
      return;
    }
    selectTime.add(value);
    update();
  }

  onChangeLevel(String value) {
    if (selectLevel.contains(value)) {
      selectLevel.remove(value);
      update();
      return;
    }
    selectLevel.add(value);
    update();
  }

  onChangeValue(newValue) {
    values = newValue;
    update();
  }
}
