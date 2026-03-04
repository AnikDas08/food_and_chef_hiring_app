import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/Chef_Order_History_Controller.dart';

void chefBookingDetailsSheet(
    BuildContext context,
    Map<String, dynamic> order,
    ChefOrderHistoryController controller,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    constraints: BoxConstraints(maxHeight: Get.height - 100),
    builder: (context) {
      final user = order['user'] as Map<String, dynamic>? ?? {};
      final status = order['status'] ?? '';
      final statusStyle = controller.getStatusStyle(status);
      final items = order['static_items'] as List? ?? [];
      final priceBreakdown = order['price_breakdown'] as Map<String, dynamic>? ?? {};
      final strTime = order['strTime'] ?? '';
      final formattedDate = controller.formatDate(order['formatted_date']);
      final formattedAddress = order['formatted_address'] ?? '';
      final orderId = order['order_id'] ?? '';
      final cancelReason = order['cancel_reason'];
      final declineReason = order['decline_reason'];

      return GetBuilder<ChefOrderHistoryController>(
        builder: (_) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===== Drag Handle =====
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  16.height,

                  // ===== Header =====
                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            user['image'] ?? '',
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40.w,
                              height: 40.w,
                              color: Colors.grey[200],
                              child: Icon(Icons.person, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: user['name'] ?? '',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff272727),
                              ),
                              CommonText(
                                text: orderId,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                            vertical: 5.sp,
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle['bg'],
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: CommonText(
                            text: status,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: statusStyle['color'],
                          ),
                        ),
                      ],
                    ),
                  ),

                  34.height,

                  // ===== Location =====
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.location,
                          color: Color(0xffFD713F),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: user['name'] ?? '',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            CommonText(
                              text: formattedAddress,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  16.height,

                  // ===== Date & Time =====
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.calendar,
                          color: Color(0xffFD713F),
                          size: 20,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: formattedDate,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            CommonText(
                              text: 'at $strTime',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ===== Cancel / Decline Reason =====
                  if (status == 'Canceled' && cancelReason != null) ...[
                    16.height,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFEBEE),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cancel_outlined,
                              color: Color(0xffF44336), size: 16),
                          8.width,
                          Expanded(
                            child: CommonText(
                              text: 'Cancel Reason: $cancelReason',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffF44336),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (status == 'Decline' && declineReason != null) ...[
                    16.height,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Color(0xff9E9E9E), size: 16),
                          8.width,
                          Expanded(
                            child: CommonText(
                              text: 'Decline Reason: $declineReason',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff9E9E9E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ===== Order Status Timeline =====
                  CommonText(
                    text: AppString.orderStatus,
                    fontSize: 14,
                    top: 32,
                    bottom: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),

                  _buildTimeline(status),

                  if (status == 'Awaiting Confirmation') ...[
                    CommonText(
                      text: "The customer is waiting for your confirmation.",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFD713F),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      top: 16,
                    ),
                  ],

                  33.height,

                  // ===== Order Details Toggle =====
                  InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: controller.onChangeOrderDetailsPopup,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: AppString.orderDetails,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff272727),
                        ),
                        Icon(
                          controller.isOrderDetailsPopup
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          size: 20,
                          color: const Color(0xff777777),
                        ),
                      ],
                    ),
                  ),

                  if (controller.isOrderDetailsPopup) ...[
                    16.height,
                    ...items.map((item) {
                      final menu = item['menu'] as Map<String, dynamic>? ?? {};
                      final customizations = item['customizations'] as List? ?? [];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: menu['name'] ?? '',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff272727),
                                  ),
                                  CommonText(
                                    text:
                                    '${item['quantity']} x  •  ${customizations.join(', ')}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                            CommonText(
                              text: controller.formatPrice(item['total_price']),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff272727),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    // ===== Price Summary =====
                    const Divider(),
                    _priceRow('Subtotal', controller.formatPrice(priceBreakdown['subtotal'])),
                    _priceRow('Tax', controller.formatPrice(priceBreakdown['taxs'])),
                    _priceRow('Service Fee', controller.formatPrice(priceBreakdown['service_fee'])),
                    const Divider(),
                    _priceRow(
                      'Total',
                      controller.formatPrice(priceBreakdown['total']),
                      isBold: true,
                    ),
                  ],

                  16.height,
                  const Divider(),
                  16.height,

                  // ===== Bottom Button — Message only =====
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.message,
                          parameters: {
                            "chatId": order['_id'] ?? '',
                            "name": user['name'] ?? '',
                            "image": user['image'] ?? '',
                          },
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline,
                          color: Color(0xffFD713F)),
                      label: const Text(
                        'Message Customer',
                        style: TextStyle(color: Color(0xffFD713F)),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(color: Color(0xffFD713F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// ===== Timeline =====
Widget _buildTimeline(String status) {
  final steps = [
    {'title': 'Booking\nOrdered', 'icon': 'assets/icons/booking_order.svg'},
    {'title': 'Chef\nConfirmed', 'icon': 'assets/icons/chef_confirmed.svg'},
    {'title': 'Groceries\nOrdered', 'icon': 'assets/icons/groceries_ordered.svg'},
    {'title': 'Booking\nComplete', 'icon': 'assets/icons/booking_complete.svg'},
  ];

  int currentStep = 1;
  if (status == 'Awaiting Confirmation') currentStep = 1;
  else if (status == 'Confirm') currentStep = 2;
  else if (status == 'Canceled' || status == 'Decline') currentStep = 0;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(steps.length, (index) {
      final isCompleted = index < currentStep;
      final isActive = index == currentStep;

      final Color mainColor = isCompleted
          ? const Color(0xff4CAF50)
          : isActive
          ? const Color(0xffFD713F)
          : const Color(0xffA7A7A7);

      final Color bgColor = isCompleted
          ? const Color(0xffE8F5E9)
          : isActive
          ? const Color(0xffFFF2EE)
          : const Color(0xffF5F5F5);

      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: index == 0
                      ? const SizedBox()
                      : Container(
                    height: 2.h,
                    color: isCompleted
                        ? const Color(0xff4CAF50)
                        : const Color(0xffD9D9D9),
                  ),
                ),
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    steps[index]['icon']!,
                    height: 20.sp,
                    width: 20.sp,
                    colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                  ),
                ),
                Expanded(
                  child: index == steps.length - 1
                      ? const SizedBox()
                      : Container(
                    height: 2.h,
                    color: index < currentStep
                        ? const Color(0xff4CAF50)
                        : const Color(0xffD9D9D9),
                  ),
                ),
              ],
            ),
            8.height,
            Text(
              steps[index]['title']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.w400,
                color: mainColor,
              ),
            ),
          ],
        ),
      );
    }),
  );
}

Widget _priceRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? const Color(0xff272727) : const Color(0xff777777),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? const Color(0xffFD713F) : const Color(0xff272727),
          ),
        ),
      ],
    ),
  );
}