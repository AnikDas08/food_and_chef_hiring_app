import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChefPublicProfileController extends GetxController {
  bool isFavorite = false;

  List cartItems = [];

  List dish = [
    {'name': 'Without onions', 'isSelected': false},
    {'name': 'Without iceberg lettuce', 'isSelected': false},
    {'name': 'Without cheese', 'isSelected': false},
    {'name': 'Without cucumber slices', 'isSelected': false},
    {'name': 'Without Tomato', 'isSelected': false},
    {'name': 'Without Bacon', 'isSelected': false},
  ];

  void onChange() {
    isFavorite = !isFavorite;
    update();
  }

  void addToCart(value) {
    cartItems.add(value);
    update();
    Navigator.pop(Get.context!);
  }

  void onChangeDish(int index) {
    dish[index]['isSelected'] = !dish[index]['isSelected'];
    update();
  }
}
