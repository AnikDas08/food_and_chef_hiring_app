import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  List<String> addressTypeList = ["Office", "Home", "Work", "Other"];

  bool isDefault = false;

  onChangeDefaultAddress(v) {
    isDefault = !isDefault;
    update();
  }

  TextEditingController addressLabelController = TextEditingController(
    text: "Office",
  );

  onChangeAddressType(int value) {
    addressLabelController.text = addressTypeList[value];
    update();
    Get.back();
  }
}
