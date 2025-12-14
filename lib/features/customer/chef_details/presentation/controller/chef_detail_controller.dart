import 'package:get/get.dart';

class ChefDetailsController extends GetxController {
  bool isFavorite = false;

  List cartItems = [];

  List dish = [
    {"name": "Without onions", "isSelected": false},
    {"name": "Without iceberg lettuce", "isSelected": false},
    {"name": "Without cheese", "isSelected": false},
    {"name": "Without cucumber slices", "isSelected": false},
    {"name": "Without Tomato", "isSelected": false},
    {"name": "Without Bacon", "isSelected": false},
  ];

  onChange() {
    isFavorite = !isFavorite;
    update();
  }

  addToCart(value) {
    cartItems.add(value);
    update();
    Get.back();
  }

  onChangeDish(int index) {
    dish[index]["isSelected"] = !dish[index]["isSelected"];
    update();
  }
}
