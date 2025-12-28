import 'package:get/get.dart';

class CartController extends GetxController {
  bool isDefaultAddress = false;
  bool isExpanded = false;

  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
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
    selectedTime = time;
    update();
  }

  onChangeDefaultAddress(value) {
    isDefaultAddress = value ?? false;
    update();
  }

  void onChangeExpanded() {
    isExpanded = !isExpanded;
    update();
  }
}
