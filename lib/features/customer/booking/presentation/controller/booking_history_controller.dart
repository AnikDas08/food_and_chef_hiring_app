// lib/features/booking_history/controller/booking_history_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/app_utils.dart';
import '../../../../../services/api/api_service.dart';
import '../../data/booking_model.dart'; // For the list items
import '../../data/data.dart';

class BookingHistoryController extends GetxController {
  static BookingHistoryController get instance => Get.find();

  // --- UI & Loading States ---
  bool isLoading = false;
  bool isDetailLoading = false;
  bool isPaginationLoading = false;
  bool isOrderDetailsPopup = false;
  String errorMessage = '';

  // --- Filter / Tab States ---
  List<String> bookingHistoryList = ["All", "Awaiting Confirmation", "Confirmed"];
  String selectedBookingHistory = "All";

  // --- Data Storage ---
  List<BookingHistoryModel> orders = [];
  OrderData? selectedOrderDetail;

  // --- Pagination ---
  int currentPage = 1;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Maps tab selection to API status string
  String? get _statusParam {
    switch (selectedBookingHistory) {
      case "Awaiting Confirmation":
        return "Awaiting Confirmation";
      case "Confirmed":
        return "Confirm";
      default:
        return null;
    }
  }

  /// 1. Fetch Main List (Booking History)
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
      String url = "order?page=$currentPage&limit=10";
      if (_statusParam != null) {
        url += "&status=${Uri.encodeComponent(_statusParam!)}";
      }

      final response = await ApiService.get(url);

      if (response.statusCode == 200 && response.data != null) {
        // Assuming BookingHistoryResponse is your list wrapper model
        final result = BookingHistoryResponse.fromJson(response.data);
        orders.addAll(result.data);
        hasMore = currentPage < result.pagination.totalPage;
        if (hasMore) currentPage++;
      } else {
        errorMessage = response.data?['message'] ?? 'Failed to load data';
      }
    } catch (e) {
      errorMessage = 'Connection error. Please try again.';
      debugPrint("List Fetch Error: $e");
    } finally {
      isLoading = false;
      isPaginationLoading = false;
      update();
    }
  }

  /// 2. Fetch Specific Order Details (For the Popup)
  Future<void> fetchOrderDetails(String id) async {
    isDetailLoading = true;
    isOrderDetailsPopup = false; // Reset the "Order Details" expansion toggle
    update();

    try {
      final response = await ApiService.get("order/$id");
      if (response.statusCode == 200 && response.data != null) {
        // Map using the detailed OrderResponse model
        final result = OrderResponse.fromJson(response.data);
        selectedOrderDetail = result.data;
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Could not fetch details.");
      debugPrint("Detail Fetch Error: $e");
    } finally {
      isDetailLoading = false;
      update();
    }
  }

  /// 3. Helper for History Timeline logic
  /// This scans the 'history' array to find the current progress index.
  int getStatusIndex(List<OrderHistory> history) {
    if (history.isEmpty) return -1;

    // We find the highest index that exists in the history array
    int maxIndex = 0;
    if (history.any((e) => e.type == "Booking Ordered")) maxIndex = 0;
    if (history.any((e) => e.type == "Chef Confirmed")) maxIndex = 1;
    if (history.any((e) => e.type == "Groceries Ordered")) maxIndex = 2;
    if (history.any((e) => e.type == "Booking Completed")) maxIndex = 3;

    return maxIndex;
  }

  /// 4. Action Handlers
  Future<void> loadMore() async {
    if (!hasMore || isPaginationLoading || isLoading) return;
    isPaginationLoading = true;
    update();
    await fetchOrders();
  }

  Future<void> onChangeBookingHistory(String value) async {
    if (selectedBookingHistory == value) return;
    selectedBookingHistory = value;
    await fetchOrders(isRefresh: true);
  }

  void onChangeOrderDetailsPopup() {
    isOrderDetailsPopup = !isOrderDetailsPopup;
    update();
  }
}