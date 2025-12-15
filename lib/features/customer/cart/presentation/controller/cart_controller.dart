import 'package:get/get.dart';

class CartController extends GetxController {
  bool isDefaultAddress = false;

  onChangeDefaultAddress(value) {
    isDefaultAddress = value ?? false;
    update();
  }
}
