import 'package:get/get.dart';

class BookingHistoryController extends GetxController {
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
}
