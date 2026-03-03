// lib/features/booking_history/controller/booking_history_controller.dart

import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../data/booking_model.dart';

class BookingHistoryController extends GetxController {
  bool isOrderDetailsPopup = false;
  bool isLoading = false;

  List<String> bookingHistoryList = [
    "All",
    "Awaiting Confirmation",
    "Confirmed",
  ];

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

  int getStatusIndex(String status) {
    if (status == "Pending") return 0;
    if (status == "Awaiting Confirmation") return 1;
    if (status == "Groceries") return 2;
    if (status == "Complete") return 3;
    return 0;
  }
}