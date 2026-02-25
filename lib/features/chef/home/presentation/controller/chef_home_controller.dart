import 'package:get/get.dart';

import '../../../../../config/api/api_end_point.dart';
import 'package:flutter/material.dart';

import '../../../../../services/api/api_response_model.dart';
import '../../../../../services/api/api_service.dart';
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


  @override
  void onInit() {
    super.onInit();
    fetchChefProfile();
    fetchWalletBalance();
    fetchRequestedBookings();
    fetchUpcomingBookings();
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
      debugPrint("❌ Single order fetch error: $e");
    }
    return null;
  }


  Future<ApiResponseModel> confirmBooking(String orderId) async {
    final url = '${ApiEndPoint.changeOrderStatus}$orderId';

    return await ApiService.patch(
      url,
      body: {
        "status": "Confirm",
      },
    );
  }


  Future<ApiResponseModel> declineBooking(String orderId, String reason) async {
    final url = '${ApiEndPoint.changeOrderStatus}$orderId';

    return await ApiService.patch(
      url,
      body: {
        "status": "Decline",
        "decline_reason": reason,
      },
    );
  }

  Future<ApiResponseModel> cancelBooking(String orderId, String reason) async {
    final url = '${ApiEndPoint.changeOrderStatus}$orderId';

    return await ApiService.patch(
      url,
      body: {
        "status": "Canceled",
        "cancel_reason": reason,
      },
    );
  }



  Future<void> fetchWalletBalance() async {
    try {
      final response = await ApiService.get(ApiEndPoint.wallet);
      if (response.statusCode == 200 && response.data['success'] == true) {
        walletBalance.value = (response.data['data']['balance'] ?? 0).toDouble();
      }
    } catch (e) {
      debugPrint("Wallet fetch error: $e");
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
      debugPrint("Profile fetch error: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchRequestedBookings() async {
    isLoadingBookings.value = true;

    try {
      final status = Uri.encodeQueryComponent("Awaiting Confirmation");

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
      debugPrint("❌ Bookings fetch error: $e");
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
      debugPrint("❌ Upcoming fetch error: $e");
    } finally {
      isLoadingUpcoming.value = false;
    }
  }


}