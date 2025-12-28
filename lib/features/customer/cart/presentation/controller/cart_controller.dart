import 'package:get/get.dart';

class CartController extends GetxController {
  bool isDefaultAddress = false;
  bool isExpanded = false;

  onChangeDefaultAddress(value) {
    isDefaultAddress = value ?? false;
    update();
  }

  void onChangeExpanded() {
    isExpanded = !isExpanded;
    update();
  }
}
