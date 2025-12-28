import 'package:get/get.dart';

class ChefBookingController extends GetxController {
  bool isOrderDetailsPopup = false;
  List<String> bookingHistoryList = ["Unconfirmed", "Upcoming", "Completed"];

  List dietaryOption = ["Too Far Away", "Earnings Too Low", "Double Booking"];

  String selectedBookingHistory = "Unconfirmed";

  onChangeBookingHistory(String value) {
    selectedBookingHistory = value;
    update();
  }

  onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }

  List selectDietary = [];

  onChangeDietary(value) {
    if (selectDietary.contains(value)) {
      selectDietary.remove(value);
      update();
      return;
    }

    selectDietary.add(value);
    update();
  }
}
