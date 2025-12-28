import 'package:get/get.dart';

class ChefPaymentController extends GetxController {
  bool isMainAccount = false;
  bool isAutoPayment = false;

  onChangeMainAccount(value) {
    isMainAccount = value;
    update();
  }

  onChangeAutoPayment() {
    isAutoPayment = !isAutoPayment;
    update();
  }
}
