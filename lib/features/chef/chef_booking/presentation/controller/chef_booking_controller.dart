

import 'package:get/get.dart';

class ChefBookingController extends GetxController {

  bool isOrderDetailsPopup = false;
  List<String> bookingHistoryList = [
    "Unconfirmed",
    "Upcoming",
    "Completed",
  ];

  String selectedBookingHistory = "Unconfirmed";

  onChangeBookingHistory(String value) {
    selectedBookingHistory = value;
    update();
  }

  onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }

}