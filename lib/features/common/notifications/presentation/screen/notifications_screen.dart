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

    return Scaffold(
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

          final grouped = ctrl.groupedNotifications;

          return RefreshIndicator(
            color: const Color(0xff5B5FEF),
            onRefresh: () => ctrl.getNotificationsRepo(),
            child: ListView.builder(
              controller: ctrl.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _totalItemCount(grouped, ctrl.isLoadingMore),
              itemBuilder: (context, index) {
                final resolved = _resolveIndex(grouped, index);

                if (resolved == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CommonLoader(size: 28)),
                  );
                }

                if (resolved is String) {
                  return _SectionLabel(label: resolved);
                }

                final item = resolved as NotificationModel;
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

  int _totalItemCount(
      Map<String, List<NotificationModel>> grouped, bool isLoadingMore) {
    int count = 0;
    for (final entry in grouped.entries) {
      count += 1 + entry.value.length; // 1 for label
    }
    if (isLoadingMore) count++;
    return count;
  }

  /// Returns String (section label), NotificationModel, or null (loader).
  dynamic _resolveIndex(
      Map<String, List<NotificationModel>> grouped, int index) {
    int cursor = 0;
    for (final entry in grouped.entries) {
      if (index == cursor) return entry.key; // section label
      cursor++;
      final items = entry.value;
      if (index < cursor + items.length) return items[index - cursor];
      cursor += items.length;
    }
    return null; // loading indicator
  }
}


class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff272727),
        ),
      ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2), // ← Figma color, no border
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? 'Notification',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.message ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff6B7280),
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Time
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
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) {
      final h = date.hour;
      final m = date.minute.toString().padLeft(2, '0');
      final period = h >= 12 ? 'PM' : 'AM';
      final hour = h % 12 == 0 ? 12 : h % 12;
      return '$hour:$m $period';
    }
    return '${diff.inDays} days ago';
  }
}