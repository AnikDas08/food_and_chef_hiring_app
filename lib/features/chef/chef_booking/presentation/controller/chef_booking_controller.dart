import 'package:get/get.dart';

class ChefBookingController extends GetxController {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  String selectedTime = "";
  final List<String> timeSlots = [
    "12:30 PM",
    "13:15 PM",
    "14:00 PM",
    "14:45 PM",
    "15:30 PM",
    "16:15 PM",
    "07:00 PM",
    "17:45 PM",
  ];

  void selectDate(DateTime date) {
    selectedDate = date;
    update();
  }

  void selectTime(String time) {
    selectedTime = time;
    update();
  }

  final RxBool isRequestingChange = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    final filter = Get.arguments?["filter"];
    if (filter != null) {
      onChangeBookingHistory(filter);
    }
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
