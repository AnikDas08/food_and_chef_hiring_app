import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../../component/other_widgets/common_loader.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/notifications_controller.dart';
import '../../data/model/notification_model.dart';
import '../widgets/no_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: Colors.white, // Figma অনুযায়ী মেইন ব্যাকগ্রাউন্ড সাদা
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff272727), size: 18),
          onPressed: () => Get.back(),
        ),
        title: const CommonText(
          text: "Notifications",
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<NotificationsController>(
        builder: (ctrl) {
          if (ctrl.isLoading) {
            return const Center(child: CommonLoader());
          }

          if (ctrl.notifications.isEmpty) {
            return const NoNotification();
          }

          return RefreshIndicator(
            color: const Color(0xff5B5FEF),
            onRefresh: () => ctrl.getNotificationsRepo(),
            child: ListView.builder(
              controller: ctrl.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: ctrl.notifications.length + (ctrl.isLoadingMore ? 1 : 0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == ctrl.notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CommonLoader(size: 28)),
                  );
                }

                final item = ctrl.notifications[index];

                // ─── Header Logic ───────────────────────────────────────────
                bool showHeader = false;
                String headerTitle = "";

                DateTime itemDate = DateTime.tryParse(item.createdAt ?? "") ?? DateTime.now();
                DateTime now = DateTime.now();
                DateTime today = DateTime(now.year, now.month, now.day);
                DateTime yesterday = today.subtract(const Duration(days: 1));
                DateTime itemDay = DateTime(itemDate.year, itemDate.month, itemDate.day);

                if (index == 0) {
                  showHeader = true;
                  headerTitle = (itemDay == today) ? "Recent" : (itemDay == yesterday ? "Yesterday" : "Earlier");
                } else {
                  final prevItem = ctrl.notifications[index - 1];
                  DateTime prevDate = DateTime.tryParse(prevItem.createdAt ?? "") ?? DateTime.now();
                  DateTime prevDay = DateTime(prevDate.year, prevDate.month, prevDate.day);

                  if (itemDay != prevDay) {
                    showHeader = true;
                    headerTitle = (itemDay == yesterday) ? "Yesterday" : "Earlier";
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h, top: index == 0 ? 10.h : 20.h),
                        child: Text(
                          headerTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff272727),
                          ),
                        ),
                      ),
                    _NotificationCard(
                      item: item,
                      onTap: () => ctrl.markAsRead(item.id ?? ''),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 1),
    );
  }
}

// ─── Clean Card with #F2F2F2 Background ─────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2), // আপনার দেওয়া স্পেসিফিক কালার
          borderRadius: BorderRadius.circular(20.r), // Figma Radius: 20px
          // No Border, No Shadow as per clean design request
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title ?? 'Notification',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatTime(item.createdAt),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff272727).withOpacity(0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              item.message ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xff6B7280),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '';

    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? "PM" : "AM";
    final minute = date.minute.toString().padLeft(2, '0');

    return "$hour:$minute $period";
  }
}