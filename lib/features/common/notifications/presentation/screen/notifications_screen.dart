import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
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
    return Scaffold(
      /// App Bar Section starts here
      appBar: AppBar(
        centerTitle: true,
        title: CommonText(
          text: AppString.notifications,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xff272727),
        ),
      ),

      /// Body Section starts here
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          return controller.isLoading
              /// Loading bar here
              ? const CommonLoader()
              : controller.notifications.isEmpty
              ///  data is Empty then show default Data
              ? const NoNotification()
              /// show all Notifications here
              : ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.sp,
                  vertical: 10.sp,
                ),
                itemCount:
                    controller.isLoadingMore
                        ? controller.notifications.length + 1
                        : controller.notifications.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  ///  Notification More Data Loading Bar
                  if (index > controller.notifications.length) {
                    return CommonLoader(size: 40, strokeWidth: 2);
                  }
                  NotificationModel item = controller.notifications[index];

                  ///  Notification card item
                  return NotificationItem(item: item);
                },
              );
        },
      ),

      /// Bottom Navigation Bar Section starts here
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 1),
    );
  }
}
