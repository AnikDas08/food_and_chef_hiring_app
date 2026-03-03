import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../cart/presentation/widgets/order_summary.dart';
import '../controller/booking_history_controller.dart';
import 'request_change_popup.dart';

String text =
    "For making Chopped Burrito, you'll need 2 cups of cold, cooked jasmine rice (preferably day-old) and 2 tablespoons of vegetable oil for stir-frying. Use 3 large eggs, lightly beaten, along with a small onion finely chopped and 2 cloves of garlic minced. Add 1 cup of mixed vegetables such as peas, carrots, and corn, and 1/2 cup of finely diced cooked ham or shrimp for added protein if desired. Season with 3 tablespoons of soy sauce (preferably low sodium), 1 tablespoon of oyster sauce, and 1 teaspoon of sesame oil. Include 2 thinly sliced green onions (including the green parts), and adjust the flavor with salt and pepper to taste. For extra spice, add 1/2 teaspoon of white pepper, and enhance the aroma with 1 teaspoon of finely grated ginger. Optionally, you can include 1 tablespoon of fish sauce for added umami flavor. For garnishes, consider fresh chopped cilantro, lime wedges, and Sriracha or chili sauce for added heat.";
void bookingDetails(BuildContext context, String orderId) {
  final BookingHistoryController controller = Get.find();
  controller.fetchBookingDetail(orderId); // API call

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
          return SafeArea(
            child: controller.detailLoading.value
                ? SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xffFD713F)),
              ),
            )
                : controller.bookingDetail.value == null
                ? SizedBox(
              height: 300,
              child: Center(child: Text("No data found")),
            )
                : _buildContent(context, controller),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}

Widget _buildContent(BuildContext context, BookingHistoryController controller) {
  final data = controller.bookingDetail.value!;

  // Status mapping
  final List<String> allStatuses = [
    'Booking Ordered',
    'Chef Confirmed',
    'Groceries Ordered',
    'Booking Completed',
  ];

  int currentStatusIndex = allStatuses.indexWhere(
        (s) => data.history.any((h) => h.type.toLowerCase() == s.toLowerCase()),
  );

  // Date format
  final date = DateTime.tryParse(data.formattedDate);
  final formattedDate = date != null
      ? "${_monthName(date.month)} ${date.day}, ${date.year}"
      : '';

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16).copyWith(bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Customer info ──
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  data.user.image.startsWith('http')
                      ? data.user.image
                      : 'https://YOUR_BASE_URL${data.user.image}',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.person, size: 40),
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: data.user.name,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: data.orderId,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusBadgeColor(data.status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CommonText(
                  text: data.status,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: _statusTextColor(data.status),
                ),
              ),
            ],
          ),
        ),

        34.height,

        // ── Address ──
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                shape: BoxShape.circle,
              ),
              child: Icon(CupertinoIcons.location, color: Color(0xffFD713F)),
            ),
            12.width,
            CommonText(
              text: data.formattedAddress,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff777777),
            ),
          ],
        ),

        16.height,

        // ── Date & Time ──
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                shape: BoxShape.circle,
              ),
              child: Icon(CupertinoIcons.calendar, color: Color(0xffFD713F)),
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
                    color: Color(0xff272727),
                  ),
                  CommonText(
                    text: "at ${data.strTime}",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── Order Status ──
        CommonText(
          text: "Order Status",
          fontSize: 14,
          top: 32,
          bottom: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),

        CommonImage(imageSrc: AppImages.orderStatus, height: 88),

        16.height,

        InkWell(
          onTap: () => controller.onChangeOrderDetailsPopup(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: "Order Details",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              Icon(
                controller.isOrderDetailsPopup
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 20,
                color: Color(0xff777777),
              ),
            ],
          ),
        ),

        32.height,

        if (controller.isOrderDetailsPopup) ...[
          // ── Menu items ──
          ...data.staticItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: item.menuName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text:
                      "${item.quantity} item(s) • ${item.customizations.join(', ')}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                CommonText(
                  text: "\$${item.totalPrice.toStringAsFixed(2)}",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
          )),

          // ── Price breakdown ──
          CommonText(
            text: "Order Summary",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
            bottom: 12,
          ),
          _summaryRow("Subtotal", "\$${data.priceBreakdown.subtotal.toStringAsFixed(2)}"),
          _summaryRow("Fees", "\$${data.priceBreakdown.serviceFee.toStringAsFixed(2)}"),
          _summaryRow("Estimated Taxes", "\$${data.priceBreakdown.taxs.toStringAsFixed(2)}"),
          _summaryRow("Total", "\$${data.priceBreakdown.total.toStringAsFixed(2)}", isBold: true),
        ],

        Divider(),

        // ── Bottom buttons ──
        Row(
          children: [
            Expanded(
              child: CommonButton(
                titleText: "Order Groceries",
                buttonHeight: 48,
                buttonRadius: 16,
              ),
            ),
            InkWell(
              onTap: () => Get.toNamed(AppRoutes.message, parameters: {
                "chatId": data.id,
                "name": data.user.name,
                "image": data.user.image,
              }),
              child: Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CommonImage(imageSrc: AppIcons.chats, size: 20),
              ),
            ),
            InkWell(
              onTap: () {
                Get.back();
                requestChange(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CommonImage(imageSrc: AppIcons.edit, size: 20),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ── Helper functions ──
Widget _summaryRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: isBold ? Color(0xff272727) : Color(0xff777777),
        ),
        CommonText(
          text: value,
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: Color(0xff272727),
        ),
      ],
    ),
  );
}

Color _statusBadgeColor(String status) {
  switch (status.toLowerCase()) {
    case 'confirm': return Color(0xffF2E3C7);
    case 'completed': return Color(0xffDFF5E3);
    case 'cancelled': return Color(0xffFFE0E0);
    default: return Color(0xffF2E3C7);
  }
}

Color _statusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'confirm': return Color(0xffE39400);
    case 'completed': return Color(0xff2E7D32);
    case 'cancelled': return Color(0xffD32F2F);
    default: return Color(0xffE39400);
  }
}

String _monthName(int month) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'];
  return months[month - 1];
}