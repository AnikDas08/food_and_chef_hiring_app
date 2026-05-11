import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../../../services/api/api_service.dart';
import '../../../../../../../config/api/api_end_point.dart';
import '../../../../../utils/log/app_log.dart';

class ChefBookingController extends GetxController {

  List<String> bookingHistoryList = ['Unconfirmed', 'Upcoming', 'Completed'];
  String selectedBookingHistory = 'Unconfirmed';

  List orders = [];
  bool isLoading = true;

  List<String> dietaryOption = [
    'Too Far Away',
    'Earnings Too Low',
    'Schedule Conflict',
    'Not Available',
    'Other',
  ];

  List<String> selectDietary = [];


  DateTime selectedDate = DateTime.now();

  List<String> timeSlots = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM',
    '08:00 PM', '09:00 PM',
  ];

  String selectedTime = '';

  bool isRequestingChange = false;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments as Map?;
    final tab = args?['tab']?.toString();
    if (tab != null && bookingHistoryList.contains(tab)) {
      onChangeBookingHistory(tab);
    }
  }

  void onChangeBookingHistory(String value) {
    if (selectedBookingHistory == value) return;
    selectedBookingHistory = value;
    fetchOrders();
  }

  // ✅ Decline reason single select
  void onChangeDietary(String value) {
    selectDietary.clear();
    selectDietary.add(value);
    update();
  }

  Future<Map<String, dynamic>?> fetchSingleOrder(String id) async {
    try {
      final response = await ApiService.get(
        '${ApiEndPoint.order}/$id',
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (e) {
      debugPrint('Single order error: $e');
    }
    return null;
  }



  // ✅ TableCalendar onDaySelected এ call হয়
  void selectDate(DateTime date) {
    selectedDate = date;
    update();
  }

  // ✅ Time chip select
  void selectTime(String time) {
    selectedTime = time;
    update();
  }

  // ✅ Popup close হলে reset
  void resetChangeRequest() {
    selectedDate = DateTime.now();
    selectedTime = '';
    update();
  }

  // ✅ Tab → API status
  String get _apiStatus {
    switch (selectedBookingHistory) {
      case 'Unconfirmed':
        return 'Awaiting Confirmation';
      case 'Upcoming':
        return 'Confirm';
      case 'Completed':
        return 'Completed';
      default:
        return 'Awaiting Confirmation';
    }
  }

  Future<void> fetchOrders() async {
    isLoading = true;
    selectDietary.clear();
    update();

    try {
      final response = await ApiService.get(
        '${ApiEndPoint.order}?status=${Uri.encodeComponent(_apiStatus)}',
      );

      if (response.statusCode == 200) {
        orders = response.data['data'] ?? [];
      } else {
        orders = [];
      }
    } catch (e) {
      appLog('ChefBookingController Error: $e');
      orders = [];
    }

    isLoading = false;
    update();
  }
}