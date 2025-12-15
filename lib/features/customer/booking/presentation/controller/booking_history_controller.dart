import 'package:get/get.dart';

class BookingHistoryController extends GetxController {
  bool isOrderDetailsPopup = false;
  List<String> bookingHistoryList = [
    "All",
    "Awaiting Confirmation",
    "Confirmed",
  ];

  String selectedBookingHistory = "All";

  onChangeBookingHistory(String value) {
    selectedBookingHistory = value;
    update();
  }

  onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }
}
