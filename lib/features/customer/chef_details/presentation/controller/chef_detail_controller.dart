import 'package:get/get.dart';

class ChefDetailsController extends GetxController {
  bool isFavorite = false;

  onChange() {
    isFavorite = !isFavorite;
    update();
  }
}
