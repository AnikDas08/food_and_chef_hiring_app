import 'package:get/get.dart';
import '../../../../../../../services/api/api_service.dart';
import '../../../../../../../config/api/api_end_point.dart';

class ChefBookingController extends GetxController {
  // ✅ Tab list
  List<String> bookingHistoryList = ["Unconfirmed", "Upcoming", "Completed"];
  String selectedBookingHistory = "Unconfirmed";

  List orders = [];
  bool isLoading = true;

  // ✅ Decline reason options (declineBookingPopUp এ use হয়)
  List<String> dietaryOption = [
    "Too Far Away",
    "Earnings Too Low",
    "Schedule Conflict",
    "Not Available",
    "Other",
  ];
  List<String> selectDietary = [];

  // ✅ DateTime? না — DateTime দিতে হবে (TableCalendar focusedDay null হয় না)
  DateTime selectedDate = DateTime.now();

  // ✅ Time slots (requestChangePopUp এ use হয়)
  List<String> timeSlots = [
    "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM",
    "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM",
    "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM",
    "08:00 PM", "09:00 PM",
  ];

  // ✅ Selected time (requestChangePopUp এ use হয়)
  String selectedTime = "";

  // ✅ Obx() এর জন্য RxBool — Send Request button loading
  bool isRequestingChange = false;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  onChangeBookingHistory(String value) {
    if (selectedBookingHistory == value) return;
    selectedBookingHistory = value;
    fetchOrders();
  }

  // ✅ Decline reason single select
  onChangeDietary(String value) {
    selectDietary.clear();
    selectDietary.add(value);
    update();
  }

  // ✅ TableCalendar onDaySelected এ call হয়
  selectDate(DateTime date) {
    selectedDate = date;
    update();
  }

  // ✅ Time chip select
  selectTime(String time) {
    selectedTime = time;
    update();
  }

  // ✅ Popup close হলে reset
  resetChangeRequest() {
    selectedDate = DateTime.now();
    selectedTime = "";
    update();
  }

  // ✅ Tab → API status
  String get _apiStatus {
    switch (selectedBookingHistory) {
      case "Unconfirmed":
        return "Awaiting Confirmation";
      case "Upcoming":
        return "Confirm";
      case "Completed":
        return "Completed";
      default:
        return "Awaiting Confirmation";
    }
  }

  fetchOrders() async {
    isLoading = true;
    selectDietary.clear();
    update();

    try {
      final response = await ApiService.get(
        "${ApiEndPoint.order}?status=${Uri.encodeComponent(_apiStatus)}",
      );

      if (response.statusCode == 200) {
        orders = response.data['data'] ?? [];
      } else {
        orders = [];
      }
    } catch (e) {
      print("ChefBookingController Error: $e");
      orders = [];
    }

    isLoading = false;
    update();
  }
}