import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddMenuController extends GetxController {
  List<String> menuOption = ["Starter", "Main Courses", "Desserts"];
  List<String> allergensOption = ["Peanuts", "Coffee", "Mushrooms"];
  List<String> dietOption = ["Vegetarian"];

  TextEditingController menuController = TextEditingController();
  TextEditingController dietTypeController = TextEditingController();
  TextEditingController allergensController = TextEditingController();

  onChangeMenu(int index) {
    menuController.text = menuOption[index];
    update();
    Navigator.pop(Get.context!);
  }

  onChangeDiet(int index) {
    dietTypeController.text = dietOption[index];
    update();
    Navigator.pop(Get.context!);
  }

  onChangeAllergens(int index) {
    allergensController.text = allergensOption[index];
    update();
    Navigator.pop(Get.context!);
  }
}
