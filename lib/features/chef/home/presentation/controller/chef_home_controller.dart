import 'dart:async';
import 'package:get/get.dart';
import '../../../../../utils/log/app_log.dart';

import '../../../../../config/api/api_end_point.dart';
import 'package:flutter/material.dart';

import '../../../../../services/api/api_response_model.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../common/notifications/presentation/controller/notifications_controller.dart';
import '../Model/Chef_Profile_Model.dart';
import '../Model/Request_0edBooking_Model.dart';

class ChefHomeController extends GetxController {

  final Rx<ChefProfileModel?> chefProfile = Rx<ChefProfileModel?>(null);
  final RxList<RequestedBookingModel> requestedBookings = <RequestedBookingModel>[].obs;
  final RxList<RequestedBookingModel> upcomingBookings = <RequestedBookingModel>[].obs;


  final RxBool isLoadingUpcoming = false.obs;
  final RxBool isLoadingBookings = false.obs;
  final RxBool isLoadingProfile = false.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxDouble lastMonthPercentage = 0.0.obs;
  final RxBool isUp = true.obs;
  final selectedBookingTab = 0.obs;
  final RxInt unreadCount = 0.obs;


  @override
  void onInit() {
    super.onInit();
    fetchChefProfile();
    fetchWalletBalance();
    fetchRequestedBookings();
    fetchUpcomingBookings();
    isRead();
    if (!Get.isRegistered<NotificationsController>()) {
      Get.put(NotificationsController());
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void isRead() async {
    appLog('Fetching Chef unread count...');
    try {
      final response = await ApiService.get("chat/unread-counts");
      appLog('Chef unread count response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        final newCount = response.data['data'] ?? 0;
        unreadCount.value = newCount;
        update(); // Force update just in case
        appLog('Chef unreadCount updated to: $newCount');
      }
    } catch (e) {
      appLog('Chef Unread error: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchSingleOrder(String orderId) async {
    try {
      final response = await ApiService.get(
        '${ApiEndPoint.UpcomingBookingsOrder}/$orderId',
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Single order fetch error: $e');
    }
    return null;
  }


  Future<ApiResponseModel> confirmBooking(String orderId) async {
    final url = '${ApiEndPoint.changeOrderStatus}$orderId';

    return await ApiService.patch(
      url,
      body: {
        'status': 'Confirm',
      },
    );
  }


  Future<ApiResponseModel> declineBooking(String orderId, String reason) async {
    final url = '${ApiEndPoint.changeOrderStatus}$orderId';

    return await ApiService.patch(
      url,
      body: {
        'status': 'Decline',
        'decline_reason': reason,
      },
    );
  }


  Future<ApiResponseModel> cancelBooking(String orderMongoId, String reason) async {

    final url = '${ApiEndPoint.changeOrderStatus}$orderMongoId';

    return await ApiService.patch(
      url,
      body: {
        'status': 'Canceled',
        'cancel_reason': reason,
      },
    );
  }


  Future<void> fetchWalletBalance() async {
    try {
      final response = await ApiService.get(ApiEndPoint.wallet);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        walletBalance.value = (data['balance'] ?? 0).toDouble();
        lastMonthPercentage.value = (data['last_month_percentage'] ?? 0).toDouble();
        isUp.value = data['isUp'] ?? true;
      }
    } catch (e) {
      debugPrint('Wallet fetch error: $e');
    }
  }

  Future<void> fetchChefProfile() async {
    isLoadingProfile.value = true;
    try {
      final response = await ApiService.get(ApiEndPoint.chefProfile);
      if (response.statusCode == 200 && response.data['success'] == true) {
        chefProfile.value = ChefProfileModel.fromJson(response.data['data']);
      }
    } catch (e) {
      debugPrint('Profile fetch error: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchRequestedBookings() async {
    isLoadingBookings.value = true;

    try {
      final status = Uri.encodeQueryComponent('Awaiting Confirmation');

      final response = await ApiService.get(
        '${ApiEndPoint.order}?status=$status&limit=5',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = (response.data['data'] as List?) ?? [];
        requestedBookings.value =
            list.map((e) => RequestedBookingModel.fromJson(e)).toList();
      } else {
        requestedBookings.clear();
      }
    } catch (e) {
      debugPrint('Bookings fetch error: $e');
    } finally {
      isLoadingBookings.value = false;
    }
  }


  Future<void> fetchUpcomingBookings() async {

    isLoadingUpcoming.value = true;

    try {

      final response = await ApiService.get(
        '${ApiEndPoint.order}?status=Confirm&limit=5',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        upcomingBookings.value =
            list.map((e) => RequestedBookingModel.fromJson(e)).toList();
      } else {
        upcomingBookings.clear();
      }
    } catch (e) {
      debugPrint('Upcoming fetch error: $e');
    } finally {
      isLoadingUpcoming.value = false;
    }
  }


}
