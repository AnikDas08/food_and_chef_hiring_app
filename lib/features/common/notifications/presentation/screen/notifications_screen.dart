import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../../component/other_widgets/common_loader.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/notifications_controller.dart';
import '../../data/model/notification_model.dart';
import '../widgets/no_notification.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final controller = Get.put(NotificationsController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: "Notifications",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CommonLoader());
          }

          if (controller.notifications.isEmpty) {
            return const NoNotification();
          }

          return RefreshIndicator(
            onRefresh: () => controller.getNotificationsRepo(),
            child: ListView.builder(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              // Add 1 to count if loading more to show the bottom loader
              itemCount: controller.notifications.length + (controller.isLoadingMore ? 1 : 0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // Show loader at the very bottom
                if (index == controller.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CommonLoader(size: 30),
                  );
                }

                NotificationModel item = controller.notifications[index];
                return NotificationItem(item: item);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 1),
    );
  }
}