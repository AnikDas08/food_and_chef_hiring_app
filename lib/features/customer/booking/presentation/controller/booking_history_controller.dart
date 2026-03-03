// lib/features/booking_history/controller/booking_history_controller.dart

import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../data/booking_model.dart';
import '../data.dart';

class BookingHistoryController extends GetxController {
  bool isOrderDetailsPopup = false;
  bool isLoading = false;

  List<String> bookingHistoryList = [
    "All",
    "Awaiting Confirmation",
    "Confirmed",
  ];


  var bookingDetail = Rxn<BookingDetailData>();
  var detailLoading = false.obs;

  Future<void> fetchBookingDetail(String orderId) async {
    try {
      detailLoading(true);
      final response = await ApiService.get('${ApiEndPoint.singleOrder}$orderId');
      if (response.isSuccess) {
        final model = BookingDetailModel.fromJson(response.data as Map<String, dynamic>);
        if (model.success) {
          bookingDetail.value = model.data;
        }
      }
    } catch (e) {
      print('ERROR: $e');
    } finally {
      detailLoading(false);
    }
  }

  String selectedBookingHistory = "All";

  List<BookingHistoryModel> orders = [];
  String errorMessage = '';

  int currentPage = 1;
  bool hasMore = true;
  bool isPaginationLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Maps tab label to API status param
  String? get _statusParam {
    switch (selectedBookingHistory) {
      case "Awaiting Confirmation":
        return "Awaiting Confirmation";
      case "Confirmed":
        return "Confirm";
      default:
        return null; // "All" — no status filter
    }
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      orders.clear();
    }

    isLoading = orders.isEmpty;
    errorMessage = '';
    update();

    try {
      String url = ApiEndPoint.baseUrl + "order?page=$currentPage&limit=10";
      if (_statusParam != null) {
        url += "&status=${Uri.encodeComponent(_statusParam!)}";
      }

      final response = await ApiService.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final result = BookingHistoryResponse.fromJson(response.data);
        orders.addAll(result.data);
        hasMore = currentPage < result.pagination.totalPage;
        currentPage++;
      } else {
        errorMessage =
            response.data?['message'] ?? 'Something went wrong. Try again.';
      }
    } catch (e) {
      errorMessage = 'Failed to load bookings.';
    } finally {
      isLoading = false;
      isPaginationLoading = false;
      update();
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isPaginationLoading) return;
    isPaginationLoading = true;
    update();
    await fetchOrders();
  }

  Future<void> onChangeBookingHistory(String value) async {
    if (selectedBookingHistory == value) return;
    selectedBookingHistory = value;
    await fetchOrders(isRefresh: true);
  }

  onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }
}