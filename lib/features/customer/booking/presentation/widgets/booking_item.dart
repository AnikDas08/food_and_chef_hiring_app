import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../data/booking_model.dart';
import '../controller/booking_history_controller.dart';
import 'details_popup.dart';

Widget bookingItem(BookingHistoryModel order) {
  return InkWell(
    onTap: () {
      // Pass both context and the unique ID from the order model
      bookingDetails(Get.context!, order.id);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp).copyWith(right: 0),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Chef avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  order.chef.image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xffE0E0E0),
                        child: CommonText(
                          text:
                              order.chef.name.isNotEmpty
                                  ? order.chef.name[0].toUpperCase()
                                  : '?',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff272727),
                        ),
                      ),
                ),
              ),

              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: order.chef.name,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                    ),
                    CommonText(
                      text: order.orderId,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff777777),
                    ),
                  ],
                ),
              ),

              _StatusBadge(status: order.status),

              PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                elevation: 0,
                icon: const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(CupertinoIcons.ellipsis),
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    Get.toNamed(AppRoutes.requestChange, arguments: order.id);
                  }
                  // Inside onSelected in bookingItem
                  else if (value == 2) {
                    final TextEditingController reasonController =
                        TextEditingController();

                    Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        title: const CommonText(
                          text: 'Cancel Booking',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff272727),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CommonText(
                              text:
                                  'Please provide a reason for cancelling this booking:',
                              maxLines: 4,
                              fontSize: 14,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w400,
                              bottom: 12,
                            ),
                            TextField(
                              controller: reasonController,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff272727),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter reason here...',
                                hintStyle: const TextStyle(
                                    fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff777777)
                                ),
                                fillColor: const Color(0xffF5F5F5),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(Get.context!),
                                  child: const CommonText(
                                    text: "Cancel",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff777777),
                                  )),
                              8.width,
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 8.w),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (reasonController.text.trim().isEmpty) {
                                      Get.snackbar(
                                        'Reason Required',
                                        'Please enter a reason before cancelling.',
                                      );
                                    } else {
                                      Navigator.pop(Get.context!); // Close dialog
                                      Get.find<BookingHistoryController>()
                                          .cancelBooking(
                                        order.id,
                                        reasonController.text.trim(),
                                      );
                                    }
                                  },
                                  child: const CommonText(
                                    text: "Confirm Cancellation",
                                    fontSize: 12,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  // Add logic for value == 2 (Cancel) if needed
                },
                itemBuilder: (context) {
                  final String status = order.status.toLowerCase();

                  // 1. If status is Cancelled, Completed, or Declined, show nothing
                  if (status == 'canceled' ||
                      status == 'completed' ||
                      status == 'decline' ||
                      status == 'declined') {
                    return [];
                  }

                  // 2. Define the Cancel Item (Shared by Awaiting and Confirm)
                  final cancelItem = const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.clear, size: 20, color: Colors.red),
                        SizedBox(width: 10),
                        CommonText(text: 'Cancel Booking', color: Colors.red),
                      ],
                    ),
                  );

                  // 3. Define the Request Change Item
                  final requestChangeItem = const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.pencil,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        CommonText(text: 'Request a Change'),
                      ],
                    ),
                  );

                  // 4. Return items based on status
                  if (status == 'confirm' || status == 'confirmed') {
                    return [requestChangeItem, cancelItem];
                  }

                  if (status == 'awaiting confirmation') {
                    return [cancelItem];
                  }

                  // Default fallback (usually for unknown statuses)
                  return [cancelItem];
                },
              ),
            ],
          ),

          24.height,

          // Date & time
          Row(
            children: [
              const CommonImage(
                imageSrc: AppIcons.date,
                width: 16,
                height: 16,
                imageColor: AppColors.secondaryTextColor,
              ),
              Flexible(
                child: CommonText(
                  text: _formatDate(order.formattedDate),
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff272727),
                ),
              ),
            ],
          ),

          8.height,

          // Menu items
          Row(
            children: [
              const CommonImage(
                imageSrc: AppIcons.ingredients,
                width: 16,
                height: 16,
                imageColor: AppColors.secondaryTextColor,
              ),
              Flexible(
                child: CommonText(
                  text: _buildMenuText(order.staticItems),
                  fontSize: 12,
                  left: 4,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff272727),
                ),
              ),
            ],
          ),

          8.height,

          // Address
          Row(
            children: [
              const CommonImage(
                imageSrc: AppIcons.location,
                width: 16,
                height: 16,
              ),
              Flexible(
                child: CommonText(
                  text: order.formattedAddress,
                  fontSize: 12,
                  left: 4,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff272727),
                ),
              ),
            ],
          ),

          // Rescheduled notice
          if (order.changeSchedule != null) ...[
            20.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.info,
                    color: Color(0xffFD713F),
                    size: 16,
                  ),
                  Flexible(
                    child: CommonText(
                      text:
                          'Rescheduled to ${_formatDate(order.changeSchedule!)}',
                      fontSize: 12,
                      left: 4,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFD713F),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Cancel reason
          if (order.cancelReason != null && order.cancelReason!.isNotEmpty) ...[
            12.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xffFFEDED),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.xmark_circle,
                    color: Colors.red,
                    size: 16,
                  ),
                  Flexible(
                    child: CommonText(
                      text: 'Cancelled: ${order.cancelReason}',
                      fontSize: 12,
                      left: 4,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.left,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],

          20.height,

          const CommonText(
            text: 'Total',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff777777),
          ),
          CommonText(
            text: '\$${order.userPaid.toStringAsFixed(2)}',
            fontWeight: FontWeight.w600,
            color: const Color(0xff272727),
            top: 2,
          ),
        ],
      ),
    ),
  );
}

// ─── Helpers ────────────────────────────────────────────────────────────────

String _formatDate(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate).toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]}, ${dt.year} at $hour:$min $period';
  } catch (_) {
    return isoDate;
  }
}

String _buildMenuText(List<StaticItem> items) {
  if (items.isEmpty) return 'No items';
  final names = items.map((e) => e.menu.name).toList();
  final totalQty = items.fold<int>(0, (sum, e) => sum + e.quantity);
  if (names.length == 1) return '$totalQty item (${names.first})';
  return '$totalQty items (${names.join(' & ')})';
}

// ─── Status Badge ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: CommonText(
        text: config['label'] as String,
        fontSize: 10,
        color: config['text'] as Color,
      ),
    );
  }

  Map<String, dynamic> _statusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'confirm':
        return {
          'label': 'Confirmed',
          'bg': const Color(0xffDFF0D8),
          'text': const Color(0xff3C763D),
        };
      case 'completed':
        return {
          'label': 'Completed',
          'bg': const Color(0xffD9EDF7),
          'text': const Color(0xff31708F),
        };
      case 'canceled':
        return {
          'label': 'Cancelled',
          'bg': const Color(0xffF2DEDE),
          'text': const Color(0xffA94442),
        };
      default: // Awaiting Confirmation
        return {
          'label': status,
          'bg': const Color(0xffF2E3C7),
          'text': const Color(0xffE39400),
        };
    }
  }
}
