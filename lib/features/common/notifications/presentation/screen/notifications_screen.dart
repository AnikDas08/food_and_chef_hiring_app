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
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const CommonText(
          text: "Notifications",
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xff272727),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xffEEEFF2)),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                return _NotificationCard(
                  item: item,
                  onTap: () => ctrl.markAsRead(item.id ?? ''),
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

// ─── Notification Card ────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = item.isRead == false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xffECEBFF) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUnread ? const Color(0xffC5C3FF) : const Color(0xffEEEFF2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bell icon with red dot for unread
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: isUnread
                    ? const Color(0xffDDDBFF)
                    : const Color(0xffF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 22.sp,
                      color: isUnread
                          ? const Color(0xff5B5FEF)
                          : const Color(0xff9CA3AF),
                    ),
                  ),
                  if (isUnread)
                    Positioned(
                      top: 9.h,
                      right: 9.w,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFF3B30),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffECEBFF),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Time row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? 'Notification',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight:
                            isUnread ? FontWeight.w700 : FontWeight.w500,
                            color: const Color(0xff1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _formatTime(item.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xffA0A0A0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),


                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          item.message ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff6B7280),
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // "NEW" badge — unread only
                      if (isUnread) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffFF3B30),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            "NEW",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
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
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}