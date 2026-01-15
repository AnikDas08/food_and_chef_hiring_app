import 'package:get/get.dart';

class ChefBookingController extends GetxController {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

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

  bool isOrderDetailsPopup = false;
  List<String> bookingHistoryList = ["Unconfirmed", "Upcoming", "Completed"];

  List dietaryOption = ["Too Far Away", "Earnings Too Low", "Double Booking"];

  String selectedBookingHistory = "Unconfirmed";

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
