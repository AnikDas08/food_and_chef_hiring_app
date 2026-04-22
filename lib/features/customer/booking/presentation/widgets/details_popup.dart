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
import '../../../../../utils/constants/app_colors.dart';
import '../../../groceries/presentations/screens/groceries_screen.dart';
import '../controller/booking_history_controller.dart';

void bookingDetails(BuildContext context, String orderId) {
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
          if (controller.isDetailLoading) {
            return const SizedBox(
              height: 350,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xffFD713F)),
              ),
            );
          }

          final order = controller.selectedOrderDetail;
          if (order == null) {
            return const SizedBox(
              height: 200,
              child: Center(child: CommonText(text: 'Order details not found')),
            );
          }

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SafeArea(
              bottom: false, // ✅ Prevent gray bottom area
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16), // ✅ Clean padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(order),
                    34.height,

                    // 📍 Location
                    _buildIconRow(
                      iconData: CupertinoIcons.location,
                      title: 'Location',
                      subTitle: order.formattedAddress,
                    ),
                    16.height,

                    // 📅 Date & Time
                    _buildIconRow(
                      iconPath: AppIcons.calendar,
                      title: _formatSimpleDate(order.formattedDate),
                      subTitle: 'at ${order.strTime}',
                    ),

                    const CommonText(
                      text: AppString.orderStatus,
                      top: 32,
                      bottom: 16,
                      fontWeight: FontWeight.w600,
                    ),

                    _buildOrderStatusTimeline(order.history),

                    if (order.status == 'Awaiting Confirmation')
                      const CommonText(
                        text:
                            'The chef is reviewing your order and should confirm soon.',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffFD713F),
                        top: 16,
                      ),

                    33.height,

                    // 📦 Order Details
                    _buildOrderDetailsAccordion(controller, order),

                    16.height,

                    // 🔘 Actions
                    _buildBottomActions(context, order, controller),
                    20.height,
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// ─── Timeline Logic ─────────────────────────────────────────────────────────

Widget _buildOrderStatusTimeline(List<dynamic> history) {
  // Define unique colors for each stage
  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Booking\nMade',
      'icon': 'assets/icons/booking_order.svg',
      'type': 'Booking Ordered',
      'color': const Color(0xff2F8328), // Green
    },
    {
      'title': 'Chef\nConfirmed',
      'icon': 'assets/icons/chef_confirmed.svg',
      'type': 'Chef Confirmed',
      'color': const Color(0xff2F8328), // Green
    },
    {
      'title': 'Groceries\nOrdered',
      'icon': 'assets/icons/groceries_ordered.svg',
      'type': 'Groceries Ordered',
      'color': const Color(0xff2F8328), // Green
    },
    {
      'title': 'Booking\nComplete',
      'icon': 'assets/icons/booking_complete.svg',
      'type': 'Booking Completed',
      'color': const Color(0xff2F8328), // Green
    },
  ];

  final int activeIndex = Get.find<BookingHistoryController>().getStatusIndex(
    history.cast(),
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(steps.length, (index) {
      final bool isReached = index <= activeIndex;
      final bool isActive = index == activeIndex;

      Color stepColor =
          isReached ? steps[index]['color'] : AppColors.secondaryTextColor;

      if (isActive) {
        stepColor = const Color(0xffFD713F);
      }

      final Color bgColor =
          isReached ? stepColor.withOpacity(0.3) : const Color(0xffF5F5F5);

      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                // Line BEFORE
                Expanded(
                  child:
                      index == 0
                          ? const SizedBox()
                          : Container(
                            height: 2.h,
                            color:
                                isReached
                                    ? steps[index - 1]['color']
                                    : const Color(0xffD9D9D9),
                          ),
                ),

                // Icon Circle
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    steps[index]['icon'],
                    height: 20.sp,
                    color: steps[index]['color'],
                    colorFilter: ColorFilter.mode(stepColor, BlendMode.srcIn),
                  ),
                ),

                // Line AFTER
                Expanded(
                  child:
                      index == steps.length - 1
                          ? const SizedBox()
                          : Container(
                            height: 2.h,
                            color:
                                (index <= activeIndex)
                                    ? stepColor
                                    : const Color(0xffD9D9D9),
                          ),
                ),
              ],
            ),
            8.height,
            CommonText(
              text: steps[index]['title'],
              maxLines: 2,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: stepColor,
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
    decoration: BoxDecoration(
      color: const Color(0xffF2F2F2),
      borderRadius: BorderRadius.circular(20.sp),
    ),
    child: Row(
      children: [
        CommonImage(
          imageSrc: order.chef.image,
          size: 40,
          borderRadius: 50,
          fill: BoxFit.fill,
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
              ),
              CommonText(
                text: order.orderId,
                fontSize: 12,
                color: const Color(0xff777777),
              ),
            ],
          ),
        ),
        _buildStatusBadge(order.status),
      ],
    ),
  );
}

Widget _buildOrderDetailsAccordion(
  BookingHistoryController controller,
  dynamic order,
) {
  return Column(
    children: [
      InkWell(
        onTap: () => controller.onChangeOrderDetailsPopup(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonText(
              text: 'Order Summary',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Icon(
              controller.isOrderDetailsPopup
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              color: const Color(0xff777777),
            ),
          ],
        ),
      ),
      if (controller.isOrderDetailsPopup) ...[
        24.height,
        ...order.staticItems
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: item.menuName,
                          fontWeight: FontWeight.w600,
                        ),
                        CommonText(
                          text:
                              "${item.quantity} Items + ${item.customizations.join(', ').replaceAll('_', ' ')}",
                          fontSize: 12,
                          color: AppColors.secondaryTextColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        24.height,

        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: 'Estimated cooking time:',
                    fontWeight: FontWeight.w600,
                  ),
                  CommonText(text: '1-1.5 hours', fontWeight: FontWeight.w600),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'For scheduling only: Billing reflects time worked.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        _buildPriceRow('Hourly rate', order.priceBreakdown.subtotal),
        _buildPriceRow('Fees', order.priceBreakdown.serviceFee),
        _buildPriceRow('Estimated taxes ', order.priceBreakdown.taxs),
        _buildPriceRow(
          'Hourly Total',
          order.priceBreakdown.total,
          isBold: true,
        ),
      ],
    ],
  );
}

Widget _buildBottomActions(
  BuildContext context,
  dynamic order,
  BookingHistoryController controller,
) {
  // 1. Safely check history using property access (.type) instead of Map access (['type'])
  bool alreadyOrderedGroceries = false;
  final String status = order.status;

  if (order.history != null) {
    // We iterate through the list of OrderHistory objects
    for (var entry in order.history) {
      // Use the dot operator because entry is an Instance of OrderHistory
      if (entry.type == 'Groceries Ordered') {
        alreadyOrderedGroceries = true;
        break;
      }
    }
  }

  // 2. The Condition: Show only if status is "Confirm" AND groceries haven't been ordered yet
  final bool showGroceryButton =
      (order.status == 'Confirm') && !alreadyOrderedGroceries;
  final bool showEditButton =
      (status == 'Awaiting Confirmation' || status == 'Confirm');

  return Row(
    children: [
      if (showGroceryButton)
        Expanded(
          child: CommonButton(
            titleText: AppString.orderGroceries,
            buttonHeight: 48,
            buttonRadius: 16,
            onTap: () {
              Navigator.pop(Get.context!); // Close BottomSheet
              Get.to(() => const GroceryScreen(), arguments: order.id);
            },
          ),
        )
      else
        // Using a Spacer or a 'Status' message if button is hidden
        const Spacer(),

      _circularIconButton(AppIcons.chats, () {
        controller.createChat(
          controller.selectedOrderDetail!.chef.id,
          controller.selectedOrderDetail!.chef.name,
          controller.selectedOrderDetail!.chef.image,
        );
      }),

      if (showEditButton)
        _circularIconButton(AppIcons.edit, () {
          Navigator.pop(Get.context!);
          requestChange(context, order);
        }),
    ],
  );
}

// ─── Internal Helpers ───────────────────────────────────────────────────────

Widget _buildIconRow({
  IconData? iconData,
  String? iconPath,
  required String title,
  required String subTitle,
}) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(10.sp),
        decoration: const BoxDecoration(
          color: Color(0xffF2F2F2),
          shape: BoxShape.circle,
        ),
        child:
            iconPath != null
                ? SvgPicture.asset(
                  iconPath,
                  colorFilter: const ColorFilter.mode(
                    Color(0xffFD713F),
                    BlendMode.srcIn,
                  ),
                  width: 20,
                )
                : Icon(iconData, color: const Color(0xffFD713F)),
      ),
      12.width,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(text: title, fontSize: 12, fontWeight: FontWeight.w600),
            CommonText(
              text: subTitle,
              fontSize: 12,
              color: const Color(0xff777777),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildPriceRow(String label, double val, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: isBold ? 14 : 14,
          color: isBold ? AppColors.black : AppColors.secondaryTextColor,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          textAlign: TextAlign.start,
        ),
        CommonText(
          text: '\$${val.toStringAsFixed(2)}',
          fontSize: isBold ? 14 : 14,
          color: isBold ? AppColors.black : AppColors.secondaryTextColor,
          textAlign: TextAlign.end,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        ),
      ],
    ),
  );
}

Widget _buildStatusBadge(String status) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xffF2E3C7),
      borderRadius: BorderRadius.circular(8),
    ),
    child: CommonText(
      text: status,
      fontSize: 10,
      color: const Color(0xffE39400),
    ),
  );
}

Widget _circularIconButton(String icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(left: 8),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CommonImage(imageSrc: icon, size: 20),
    ),
  );
}

String _formatSimpleDate(String isoDate) {
  try {
    final DateTime dt = DateTime.parse(isoDate);
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
    return '${dt.day} ${months[dt.month - 1]}, ${dt.year}';
  } catch (e) {
    return isoDate;
  }
}
