// lib/features/orders/widgets/past_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../cart/presentation/controller/cart_controller.dart';
import '../controller/past_order_controller.dart';
import '../data/past_order_model.dart';

Widget pastItem(BuildContext context, PastOrderModel order) {
  // ── Status color helper ───────────────────────────────────
  Color statusBg;
  Color statusText;
  switch (order.status.toLowerCase()) {
    case 'completed':
      statusBg = const Color(0xffDBEBD9);
      statusText = const Color(0xff2F8328);
      break;
    case 'cancelled':
      statusBg = const Color(0xffFFE5E5);
      statusText = const Color(0xffFF3C3C);
      break;
    default:
      statusBg = const Color(0xffFFF3E0);
      statusText = const Color(0xffF57C00);
  }

  return InkWell(
    onTap: () {
      final controller = Get.find<PastOrderController>();
      controller.fetchAndShowDetail(context, order.id);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ──────────────────────────────────────
          Row(
            children: [
              // Chef image
              CommonImage(
                imageSrc: '${ApiEndPoint.imageUrl}${order.chef.image}',
                size: 40,
                borderRadius: 50,
                fill: BoxFit.cover,
              ),

              12.width,

              /// Chef name + order ID
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

              // Status badge
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CommonText(
                  text: order.status,
                  fontSize: 10,
                  color: statusText,
                ),
              ),

              // More options menu
              /*PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    // Request a Change
                  } else if (value == 2) {
                    // Cancel Booking
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 20, color: Colors.black),
                        SizedBox(width: 10),
                        CommonText(text: "Request a Change", fontSize: 14),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(Icons.close, size: 20, color: Colors.red),
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
              ),*/
            ],
          ),

          16.height,

          // ── Order Info Box ──────────────────────────────────
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              border: Border.all(color: const Color(0xffF1F1F1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Date & time
                Row(
                  children: [
                    const CommonImage(
                      imageSrc: AppIcons.date,
                      size: 16,
                      imageColor: Color(0xffA7A7A7),
                    ),
                    SizedBox(width: 20.h,),
                    Flexible(
                      child: CommonText(
                        text: _formatDate(order.formattedDate),
                        fontSize: 12,
                        left: 4,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                8.height,

                // Items
                Row(
                  children: [
                    const CommonImage(
                      imageSrc: AppIcons.ingredients,
                      size: 16,
                      imageColor: Color(0xffA7A7A7),
                    ),
                    SizedBox(width: 20.h,),
                    Flexible(
                      child: CommonText(
                        text:
                        '${order.itemCountLabel} (${order.itemNames})',
                        fontSize: 12,
                        left: 4,
                        fontWeight: FontWeight.w400,
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
                      size: 16,
                      imageColor: Color(0xffA7A7A7),
                    ),
                    SizedBox(width: 20.h,),
                    Flexible(
                      child: CommonText(
                        text: order.formattedAddress,
                        fontSize: 12,
                        left: 4,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xffF9F9F9)),
          8.height,

          // ── Footer Row ──────────────────────────────────────
          Row(
            children: [
              // Total price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.total,
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

              const Spacer(),

              // Rating (show 0 as "Rate" if not yet rated)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(color: const Color(0xffF1F1F1)),
                ),
                child: Row(
                  children: [
                    CommonText(
                      text: order.rating > 0
                          ? 'You rated ${order.rating}'
                          : 'Rate',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                      right: 4,
                    ),
                    Icon(
                      Icons.star,
                      color: order.rating > 0
                          ? const Color(0xffFD713F)
                          : const Color(0xffCCCCCC),
                      size: 16,
                    ),
                  ],
                ),
              ),

              // Reorder button
              InkWell(
                onTap: () {
                  final cartController = Get.find<CartController>();
                  cartController.processReorder(order);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff272727),
                    borderRadius: BorderRadius.circular(12.sp),
                    border: Border.all(color: const Color(0xffF1F1F1)),
                  ),
                  child: const CommonText(
                    text: AppString.reorder,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Formats ISO date string → "27 Feb, 2026 at 08:30 PM"
String _formatDate(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate).toLocal();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]}, ${dt.year} at $hour:$minute $period';
  } catch (_) {
    return isoDate;
  }
}