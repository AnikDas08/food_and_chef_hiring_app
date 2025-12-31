import 'package:get/get.dart';
import 'package:new_untitled/utils/log/app_log.dart';

class ChefDetailsController extends GetxController {
  static ChefDetailsController get instance =>
      Get.find<ChefDetailsController>();

  @override
  void onInit() {
    super.onInit();
    ever(innerBoxIsScrolled, (bool value) {
      appLog(value, source: "ChefDetailsController");
    });
  }

  DateTime selectedDate = DateTime.now();
  List<String> selectedTime = [];
  final List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "02:00 PM",
    "04:00 PM",
    "06:00 PM",
  ];

  void selectDate(DateTime date) {
    selectedDate = date;
    update();
  }

  void selectTime(String time) {
    if (selectedTime.contains(time)) {
      selectedTime.remove(time);
    } else {
      selectedTime.add(time);
    }
    update();
  }

  bool isFavorite = false;
  bool isExpanded = false;

  List cartItems = [];
  RxBool innerBoxIsScrolled = false.obs;

  List dish = [
    {"name": "Without onions", "isSelected": false},
    {"name": "Without iceberg lettuce", "isSelected": false},
    {"name": "Without cheese", "isSelected": false},
    {"name": "Without cucumber slices", "isSelected": false},
    {"name": "Without Tomato", "isSelected": false},
    {"name": "Without Bacon", "isSelected": false},
  ];

  onChangeInnerBoxIsScrolled(bool value) {
    appLog(value, source: "ChefDetailsController onChangeInnerBoxIsScrolled");
    if (innerBoxIsScrolled.value == value) return;
    innerBoxIsScrolled(value);
  }

  onChange() {
    isFavorite = !isFavorite;
    update();
  }

  onChangeExpand() {
    isExpanded = !isExpanded;
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
