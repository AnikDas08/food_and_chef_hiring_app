import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RangeValues values = const RangeValues(20, 100);

  bool saved = false;

  List<String> cuisineOption = [
    "Health food",
    "Vegan",
    "Chinese",
    "American",
    "Italian",
    "Mexican",
    "Japanese",
    "Indian",
  ];
  List<String> timeOption = ["Today", "Tomorrow", "This week", "Next week"];
  List<String> levelOption = [
    "No restaurant experience",
    "Restaurant experience",
    "Fine dining experience",
  ];

  List<String> dietaryOption = [
    "Vegan",
    "Vegetarian",
    "Pescetarian",
    "Halal",
    "Kosher",
  ];

  List<String> selectTime = [];
  List<String> selectLevel = [];
  List<String> selectCuisine = [];
  List<String> selectDietary = [];

  onChangeTime(String value) {
    if (selectTime.contains(value)) {
      selectTime.remove(value);
      update();
      return;
    }
    selectTime.add(value);
    update();
  }

  onChangeCuisine(String value) {
    if (selectCuisine.contains(value)) {
      selectCuisine.remove(value);
      update();
      return;
    }

    selectCuisine.add(value);
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

  onChangeDietary(String value) {
    if (selectDietary.contains(value)) {
      selectDietary.remove(value);
      update();
      return;
    }

    selectDietary.add(value);
    update();
  }

  onChangeSaved() {
    saved = !saved;
    update();
  }

  onChangeValue(newValue) {
    values = newValue;
    update();
  }
}
