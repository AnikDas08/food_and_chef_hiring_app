import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../data/Booking_Time_Model.dart';
import '../../data/Earning_Model.dart';
import '../../data/Top_Menu_Model.dart';

class AnalyticsController extends GetxController {
  var isLoading = false.obs;
  var totalEarning = 0.0.obs;
  var formatArray = <MonthEarning>[].obs;
  var selectedFilter = 'Weekly'.obs;
  var errorMessage = ''.obs;

  var bookingLoading = false.obs;
  var mappedData = <MappedTime>[].obs;
  var avgDuration = 0.0.obs;
  var avgPrice = 0.0.obs;
  var avgMenus = 0.obs;
  var totalBooking = 0.obs;
  var selectedDay = 'Sunday'.obs;

  var topMenuLoading = false.obs;
  var topMenuList = <TopMenuItem>[].obs;

  final List<String> filters = ['Weekly', 'Monthly'];


  @override
  void onInit() {
    super.onInit();
    fetchTotalEarning();
    fetchBookingTime();
    fetchTopMenus();
  }

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> fetchBookingTime() async {
    try {
      bookingLoading(true);
      final response = await ApiService.get(
        '${ApiEndPoint.mostBookingTime}${selectedDay.value.toLowerCase()}',
      );
      if (response.isSuccess) {
        final model = BookingTimeModel.fromJson(response.data as Map<String, dynamic>);
        if (model.success) {
          mappedData.value = model.data.mappedData;
          avgDuration.value = model.data.avgCountOrder.avgDuration;
          avgPrice.value = model.data.avgCountOrder.avgPrice;
          avgMenus.value = model.data.avgCountOrder.avgMenus;
          totalBooking.value = model.data.avgCountOrder.totalBooking;
        }
      }
    } catch (e) {
    } finally {
      bookingLoading(false);
    }
  }

  void changeDay(String day) {
    selectedDay.value = day;
    fetchBookingTime();
  }

  Future<void> fetchTotalEarning() async {
    try {
      isLoading(true);
      errorMessage('');

      final String range = selectedFilter.value == 'Weekly' ? 'week' : 'month';
      final response = await ApiService.get('${ApiEndPoint.totalEarning}$range');

      if (response.isSuccess) {
        final model = EarningModel.fromJson(response.data as Map<String, dynamic>);
        if (model.success) {
          totalEarning.value = model.data.totalEarning;
          formatArray.value = model.data.formatArray;
        }
      } else {
        errorMessage(response.message);
      }
    } catch (e) {
      errorMessage('Failed to load data');
    } finally {
      isLoading(false);
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchTotalEarning();
  }

  Future<void> fetchTopMenus() async {
    try {
      topMenuLoading(true);
      final response = await ApiService.get(ApiEndPoint.topMenus);
      if (response.isSuccess) {
        final model = TopMenuModel.fromJson(response.data as Map<String, dynamic>);
        if (model.success) {
          topMenuList.value = model.data;
        }
      }
    } catch (e) {
    } finally {
      topMenuLoading(false);
    }
  }
  
}