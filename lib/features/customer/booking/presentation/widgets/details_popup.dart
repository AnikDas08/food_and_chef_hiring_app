// lib/features/booking_history/widgets/details_popup.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/customer/booking/presentation/widgets/request_change_popup.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../groceries/presentations/screens/groceries_screen.dart';
import '../controller/booking_history_controller.dart';

void bookingDetails(BuildContext context, String orderId) {
  // Trigger the specific API call for this order ID
  Get.find<BookingHistoryController>().fetchOrderDetails(orderId);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<BookingHistoryController>(
        builder: (controller) {
          // 1. LOADING STATE
          if (controller.isDetailLoading) {
            return SizedBox(
              height: 350.h,
              child: const Center(child: CircularProgressIndicator(color: Color(0xffFD713F))),
            );
          }

          // 2. ERROR/NULL STATE
          final order = controller.selectedOrderDetail;
          if (order == null) {
            return SizedBox(
              height: 200.h,
              child: const Center(child: CommonText(text: "Order details not found")),
            );
          }

          // 3. DATA STATE
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Chef & Order ID Header ---
                  _buildHeader(order),
                  34.height,

                  // --- Location ---
                  _buildIconRow(
                    iconData: CupertinoIcons.location,
                    title: "Location",
                    subTitle: order.formattedAddress,
                  ),
                  16.height,

                  // --- Date & Time ---
                  _buildIconRow(
                    iconPath: AppIcons.calendar,
                    title: _formatSimpleDate(order.formattedDate),
                    subTitle: "at ${order.strTime}",
                  ),

                  // --- Status Timeline ---
                  CommonText(
                    text: AppString.orderStatus,
                    fontSize: 14,
                    top: 32,
                    bottom: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  _buildOrderStatusTimeline(order.history),

                  // Status helper message
                  if (order.status == "Awaiting Confirmation")
                    CommonText(
                      text: "The chef is reviewing your order and should confirm soon.",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFD713F),
                      top: 16,
                    ),

                  33.height,

                  // --- Order Details Accordion ---
                  _buildOrderDetailsAccordion(controller, order),

                  16.height,
                  const Divider(),
                  20.height,


                  _buildBottomActions(context, order),
                ],
              ),
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}

// ─── Timeline Logic ─────────────────────────────────────────────────────────

Widget _buildOrderStatusTimeline(List<dynamic> history) {
  // Define unique colors for each stage
  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Booking\nOrdered',
      'icon': "assets/icons/booking_order.svg",
      'type': 'Booking Ordered',
      'color': const Color(0xff4CAF50), // Green
    },
    {
      'title': 'Chef\nConfirmed',
      'icon': "assets/icons/chef_confirmed.svg",
      'type': 'Chef Confirmed',
      'color': const Color(0xff2196F3), // Blue
    },
    {
      'title': 'Groceries\nOrdered',
      'icon': "assets/icons/groceries_ordered.svg",
      'type': 'Groceries Ordered',
      'color': const Color(0xffFF9800), // Orange
    },
    {
      'title': 'Booking\nComplete',
      'icon': "assets/icons/booking_complete.svg",
      'type': 'Booking Completed',
      'color': const Color(0xff9C27B0), // Purple
    },
  ];

  int activeIndex = Get.find<BookingHistoryController>().getStatusIndex(history.cast());

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(steps.length, (index) {
      bool isReached = index <= activeIndex;
      bool isActive = index == activeIndex;

      // Logic: If reached, use its specific color. If not reached, use Grey.
      Color stepColor = isReached ? steps[index]['color'] : const Color(0xffA7A7A7);

      // Lighten the background color for the circle
      Color bgColor = isReached
          ? (steps[index]['color'] as Color).withOpacity(0.1)
          : const Color(0xffF5F5F5);

      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                // Line BEFORE
                Expanded(
                  child: index == 0
                      ? const SizedBox()
                      : Container(
                    height: 2.h,
                    // Line is colored if the CURRENT step is reached
                    color: isReached ? steps[index - 1]['color'] : const Color(0xffD9D9D9),
                  ),
                ),

                // Icon Circle
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: stepColor, width: 2) : null,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    steps[index]['icon'],
                    height: 20.sp,
                    colorFilter: ColorFilter.mode(stepColor, BlendMode.srcIn),
                  ),
                ),

                // Line AFTER
                Expanded(
                  child: index == steps.length - 1
                      ? const SizedBox()
                      : Container(
                    height: 2.h,
                    // Line is colored if the NEXT step is already reached
                    color: (index < activeIndex) ? steps[index]['color'] : const Color(0xffD9D9D9),
                  ),
                ),
              ],
            ),
            8.height,
            CommonText(
              text: steps[index]['title'],
              maxLines: 2,
              fontSize: 10.sp,
              // Make text bold only if it is the current active status
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: stepColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }),
  );
}

// ─── UI Components ──────────────────────────────────────────────────────────

Widget _buildHeader(dynamic order) {
  return Container(
    padding: EdgeInsets.all(12.sp),
    decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(20.sp)),
    child: Row(
      children: [
        CommonImage(imageSrc: order.chef.image, size: 40, borderRadius: 50, fill: BoxFit.fill),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(text: order.chef.name, fontSize: 12, fontWeight: FontWeight.w600),
              CommonText(text: order.orderId, fontSize: 12, color: const Color(0xff777777)),
            ],
          ),
        ),
        _buildStatusBadge(order.status),
      ],
    ),
  );
}

Widget _buildOrderDetailsAccordion(BookingHistoryController controller, dynamic order) {
  return Column(
    children: [
      InkWell(
        onTap: () => controller.onChangeOrderDetailsPopup(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(text: AppString.orderDetails, fontSize: 16, fontWeight: FontWeight.w600),
            Icon(
              controller.isOrderDetailsPopup ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
              color: const Color(0xff777777),
            ),
          ],
        ),
      ),
      if (controller.isOrderDetailsPopup) ...[
        24.height,
        ...order.staticItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(text: item.menuName, fontSize: 14, fontWeight: FontWeight.w600),
                  CommonText(
                    text: "${item.quantity} Items + ${item.customizations.join(', ').replaceAll('_', ' ')}",
                    fontSize: 12, color: const Color(0xff777777),
                  ),
                ],
              ),
              CommonText(text: "\$${item.totalPrice.toStringAsFixed(2)}", fontSize: 14),
            ],
          ),
        )).toList(),
        const Divider(),
        _buildPriceRow("Subtotal", order.priceBreakdown.subtotal),
        _buildPriceRow("Tax", order.priceBreakdown.taxs),
        _buildPriceRow("Service Fee", order.priceBreakdown.serviceFee),
        const Divider(),
        _buildPriceRow("Total", order.priceBreakdown.total, isBold: true),
      ],
    ],
  );
}

Widget _buildBottomActions(BuildContext context, dynamic order) {
  // 1. Safely check history using property access (.type) instead of Map access (['type'])
  bool alreadyOrderedGroceries = false;
  final String status = order.status;

  if (order.history != null) {
    // We iterate through the list of OrderHistory objects
    for (var entry in order.history) {
      // Use the dot operator because entry is an Instance of OrderHistory
      if (entry.type == "Groceries Ordered") {
        alreadyOrderedGroceries = true;
        break;
      }
    }
  }

  // 2. The Condition: Show only if status is "Confirm" AND groceries haven't been ordered yet
  bool showGroceryButton = (order.status == "Confirm") && !alreadyOrderedGroceries;
  bool showEditButton = (status == "Awaiting Confirmation" || status == "Confirm");

  return Row(
    children: [
      if (showGroceryButton)
        Expanded(
          child: CommonButton(
            titleText: AppString.orderGroceries,
            buttonHeight: 48,
            buttonRadius: 16,
            onTap: () {
              Get.back(); // Close BottomSheet
              Get.to(() => const GroceryScreen(), arguments: order.id);
            },
          ),
        )
      else
      // Using a Spacer or a 'Status' message if button is hidden
        const Spacer(),

      _circularIconButton(AppIcons.chats, () {
        // Handle chat navigation
      }),

      if (showEditButton)
        _circularIconButton(AppIcons.edit, () {
          Get.back();
          requestChange(context,order);
        }),
    ],
  );
}

// ─── Internal Helpers ───────────────────────────────────────────────────────

Widget _buildIconRow({IconData? iconData, String? iconPath, required String title, required String subTitle}) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(10.sp),
        decoration: const BoxDecoration(color: Color(0xffF2F2F2), shape: BoxShape.circle),
        child: iconPath != null
            ? SvgPicture.asset(iconPath, colorFilter: const ColorFilter.mode(Color(0xffFD713F), BlendMode.srcIn), width: 20)
            : Icon(iconData, color: const Color(0xffFD713F)),
      ),
      12.width,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(text: title, fontSize: 12, fontWeight: FontWeight.w600),
            CommonText(text: subTitle, fontSize: 12, color: const Color(0xff777777)),
          ],
        ),
      ),
    ],
  );
}

Widget _buildPriceRow(String label, double val, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(text: label, fontSize: isBold ? 16 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        CommonText(text: "\$${val.toStringAsFixed(2)}", fontSize: isBold ? 16 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ],
    ),
  );
}

Widget _buildStatusBadge(String status) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xffF2E3C7), borderRadius: BorderRadius.circular(8)),
    child: CommonText(text: status, fontSize: 10, color: const Color(0xffE39400), fontWeight: FontWeight.w500),
  );
}

Widget _circularIconButton(String icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(left: 8),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(20)),
      child: CommonImage(imageSrc: icon, size: 20),
    ),
  );
}

String _formatSimpleDate(String isoDate) {
  try {
    DateTime dt = DateTime.parse(isoDate);
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${dt.day} ${months[dt.month - 1]}, ${dt.year}";
  } catch (e) {
    return isoDate;
  }
}