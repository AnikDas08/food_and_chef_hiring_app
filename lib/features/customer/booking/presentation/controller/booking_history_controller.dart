// lib/features/booking_history/controller/booking_history_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/app_utils.dart';
import '../../../../../config/route/app_routes.dart';
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

      if (response.statusCode == 200) {
        // Assuming BookingHistoryResponse is your list wrapper model
        final result = BookingHistoryResponse.fromJson(response.data);
        orders.addAll(result.data);
        hasMore = currentPage < result.pagination.totalPage;
        if (hasMore) currentPage++;
      } else {
        errorMessage = response.data['message'] ?? 'Failed to load data';
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

  Future<void> createChat(String id,String name, String image) async {
    try {
      final response = await ApiService.post("chat/$id");
      if (response.statusCode == 200) {
        final data=response.data;
        String chatId=data["data"]["_id"];
        Get.toNamed(AppRoutes.message,parameters: {
          "chatId":chatId,
          "name": name,
          "image": image,
        },);

      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Could not fetch details.");
      debugPrint("Detail Fetch Error: $e");
    } finally {
      isDetailLoading = false;
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
      if (response.statusCode == 200) {
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

  Future<void> fetchChefDetails(String id) async {
    isDetailLoading = true;
    isOrderDetailsPopup = false; // Reset the "Order Details" expansion toggle
    update();

    try {
      final response = await ApiService.get("order/$id");
      if (response.statusCode == 200) {
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
  // lib/features/booking_history/controller/booking_history_controller.dart

  int getStatusIndex(List<dynamic> history) {
    if (history.isEmpty) return -1;

    int maxIndex = 0;

    for (var entry in history) {
      // If entry is a model (OrderHistory), use entry.type
      // If it's a map (for some reason), use entry['type']
      String? type;
      if (entry is OrderHistory) {
        type = entry.type;
      } else if (entry is Map) {
        type = entry['type'];
      }

      if (type == "Booking Ordered") maxIndex = maxIndex < 0 ? 0 : maxIndex;
      if (type == "Chef Confirmed") maxIndex = 1;
      if (type == "Groceries Ordered") maxIndex = 2;
      if (type == "Booking Completed") maxIndex = 3;
    }

    return maxIndex;
  }

  // lib/features/booking_history/controller/booking_history_controller.dart

  Future<void> cancelBooking(String id, String reason) async {
    if (reason.isEmpty) {
      Utils.errorSnackBar("Required", "Please provide a reason for cancellation");
      return;
    }

    try {
      // Show a simple loading overlay
      Get.dialog(const Center(child: CircularProgressIndicator(color: Color(0xffFD713F))), barrierDismissible: false);

      final response = await ApiService.patch(
        "order/change-status/$id",
        body: {
          "status": "Canceled",
          "cancel_reason": reason // Sending the reason here
        },
      );

      Navigator.pop(Get.context!); // Close loading indicator

      if (response.statusCode == 200) {
        Utils.successSnackBar("Success", "Booking cancelled");
        await fetchOrders(isRefresh: true);
      } else {
        Utils.errorSnackBar("Error", response.data['message'] ?? "Failed to cancel");
      }
    } catch (e) {
      Navigator.pop(Get.context!); // Close loading
      debugPrint("Cancel Error: $e");
    }
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

  // lib/features/booking_history/controller/booking_history_controller.dart

  Future<void> submitChangeRequest({
    required String orderId,
    required String date,       // e.g., "2026-01-22"
    required String time,       // e.g., "05:00 PM"
    required String addressId,
    required String note,
  }) async {
    if (date.isEmpty || time.isEmpty || addressId.isEmpty) {
      Utils.errorSnackBar("Error", "Please select both date/time and address");
      return;
    }

    try {
      // Show loading overlay
      //Get.dialog(const Center(child: CircularProgressIndicator(color: Color(0xffFD713F))), barrierDismissible: false);

      final Map<String, dynamic> body = {
        "requested_date": date,
        "requested_time": time,
        "address_id": addressId,
        "note": note,
      };

      // End URL: order/change-status/{id}
      final response = await ApiService.post("order/change-schedule/$orderId", body: body);

      //Navigator.pop(Get.context!); // Close loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.successSnackBar("Success", "Request change sent successfully");

        // Navigate back to Booking History or Home
        //Get.offAllNamed(AppRoutes.customerHomeScreen);
      } else {
        Utils.errorSnackBar("Error", response.data['message'] ?? "Failed to send request");
      }
    } catch (e) {
      Navigator.pop(Get.context!);
      debugPrint("Request Change Error: $e");
      Utils.errorSnackBar("Error", "Somthing error");
    }
  }
}