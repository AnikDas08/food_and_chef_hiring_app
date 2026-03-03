import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../../data/model/notification_model.dart';
import '../../repository/notification_repository.dart';

class NotificationsController extends GetxController {
  static NotificationsController get instance => Get.find();

  List<NotificationModel> notifications = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasNoData = false;
  int page = 1;
  int unreadCount = 0;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getNotificationsRepo(); // Initial load
    _setupScrollListener();
  }

  /// Initial Fetch (Page 1)
  Future<void> getNotificationsRepo() async {
    if (isLoading) return;

    isLoading = true;
    hasNoData = false; // Reset on refresh
    page = 1;
    update();

    try {
      // Fetching from page 1
      final response = await ApiService.get("notification?page=$page&limit=10");

      if (response.statusCode == 200) {
        var responseData = response.data['data'];
        unreadCount = responseData['unreadCount'] ?? 0;

        List rawList = responseData['data'];
        notifications = rawList.map((e) => NotificationModel.fromJson(e)).toList();

        if (notifications.isEmpty) {
          hasNoData = true;
        }
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    }

    isLoading = false;
    update();
  }

  /// Load More Fetch (Pagination)
  Future<void> loadMoreNotifications() async {
    if (isLoadingMore || hasNoData) return;

    isLoadingMore = true;
    update();

    try {
      page++;
      // Call repository or API directly
      final response = await ApiService.get("notification?page=$page&limit=10");

      if (response.statusCode == 200) {
        var responseData = response.data['data'];
        List rawList = responseData['data'];

        List<NotificationModel> newItems = rawList.map((e) => NotificationModel.fromJson(e)).toList();

        if (newItems.isEmpty) {
          hasNoData = true;
        } else {
          notifications.addAll(newItems);
        }
      }
    } catch (e) {
      page--; // Rollback page on error
      debugPrint("Error loading more: $e");
    }

    isLoadingMore = false;
    update();
  }

  /// Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    int index = notifications.indexWhere((element) => element.id == notificationId);

    if (index != -1 && notifications[index].isRead == false) {
      // Optimistic Update
      notifications[index].isRead = true;

      // Sync unreadCount for the AppBar Badge
      if (unreadCount > 0) unreadCount--;
      update();

      try {
        final response = await ApiService.patch("notification/$notificationId");
        if (response.statusCode != 200) {
          // Rollback on failure
          notifications[index].isRead = false;
          unreadCount++;
          update();
        }
      } catch (e) {
        notifications[index].isRead = false;
        unreadCount++;
        update();
      }
    }
  }

  /// Scroll Listener Logic
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
        loadMoreNotifications();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}