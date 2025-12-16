import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  bool isBilling = false;

  void changeBilling(v) {
    isBilling = !isBilling;
    update();
  }
}
