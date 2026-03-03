import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/extensions/time_extension.dart';
import '../../data/model/notification_model.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../controller/notifications_controller.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.item});
  final NotificationModel item;

  @override
  Widget build(BuildContext context) {
    // Access the controller
    final controller = Get.find<NotificationsController>();

    return InkWell(
      onTap: () => controller.markAsRead(item.id ?? ""),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          // Logic: If isRead is false, show a light primary background, else white/transparent
          color: item.isRead == false
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: item.isRead == false
                ? AppColors.primaryColor
                : Colors.grey.shade300,
          ),
          boxShadow: [
            if (item.isRead == false)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: item.isRead == false
                  ? AppColors.primaryColor
                  : AppColors.background,
              radius: 25.r,
              child: Icon(
                _getIconData(item.filePath),
                color: item.isRead == false ? Colors.white : AppColors.primaryColor,
                size: 22.sp,
              ),
            ),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CommonText(
                          text: item.title ?? "",
                          fontSize: 14.sp,
                          // Make text bolder if unread
                          fontWeight: item.isRead == false ? FontWeight.bold : FontWeight.w600,
                          maxLines: 1,
                        ),
                      ),
                      CommonText(
                        text: item.createdAt.checkTime,
                        fontSize: 11.sp,
                        color: Colors.grey,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  CommonText(
                    text: item.message ?? "",
                    fontSize: 13.sp,
                    color: item.isRead == false ? Colors.black87 : Colors.black54,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    top: 4,
                  ),
                ],
              ),
            ),
            // Unread dot indicator
            if (item.isRead == false)
              Container(
                margin: EdgeInsets.only(left: 8.w, top: 4.h),
                height: 8.r,
                width: 8.r,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String? path) {
    if (path == 'booking') return Icons.receipt_long;
    return Icons.notifications;
  }
}