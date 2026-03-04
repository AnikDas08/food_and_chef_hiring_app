import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../data/booking_model.dart';
import 'details_popup.dart';

Widget bookingItem(BookingHistoryModel order) {
  return InkWell(
    onTap: () {
      bookingDetails(Get.context!);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp).copyWith(right: 0),
      margin: EdgeInsets.only(top: 16),
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
                  ApiEndPoint.imageUrl + order.chef.image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xffE0E0E0),
                    child: CommonText(
                      text: order.chef.name.isNotEmpty
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                icon: RotatedBox(
                  quarterTurns: 1,
                  child: const Icon(CupertinoIcons.ellipsis),
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    Get.toNamed(AppRoutes.requestChange, arguments: order);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.pencil, size: 20, color: Colors.black),
                        SizedBox(width: 10),
                        CommonText(text: "Request a Change", fontSize: 14),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.clear, size: 20, color: Colors.red),
                        SizedBox(width: 10),
                        CommonText(
                          text: "Cancel Booking",
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          24.height,

          // Date & time
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonImage(imageSrc: AppIcons.date, width: 16, height: 16),
              Flexible(
                child: CommonText(
                  text: _formatDate(order.formattedDate),
                  fontSize: 12,
                  left: 8,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff272727),
                ),
              ),
            ],
          ),

          8.height,

          // Menu items
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonImage(imageSrc: AppIcons.ingredients, width: 16, height: 16),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonImage(imageSrc: AppIcons.location, width: 16, height: 16),
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
                  const Icon(CupertinoIcons.info, color: Color(0xffFD713F), size: 16),
                  Flexible(
                    child: CommonText(
                      text: "Rescheduled to ${_formatDate(order.changeSchedule!)}",
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
                  const Icon(CupertinoIcons.xmark_circle, color: Colors.red, size: 16),
                  Flexible(
                    child: CommonText(
                      text: "Cancelled: ${order.cancelReason}",
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

          CommonText(
            text: "Total",
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff777777),
          ),
          CommonText(
            text: "\$${order.userPaid.toStringAsFixed(2)}",
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
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return "${dt.day} ${months[dt.month - 1]}, ${dt.year} at $hour:$min $period";
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
        fontWeight: FontWeight.w500,
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