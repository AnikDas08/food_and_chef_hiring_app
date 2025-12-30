import 'package:get/get.dart';

class BookingHistoryController extends GetxController {
  bool isOrderDetailsPopup = false;
  bool isLoading = false;
  List<String> bookingHistoryList = [
    "All",
    "Awaiting Confirmation",
    "Confirmed",
  ];

  String selectedBookingHistory = "All";

  onChangeBookingHistory(String value) {
    selectedBookingHistory = value;
    isLoading = true;
    update();

    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading = false;
      update();
    });
  }

  onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }
}
