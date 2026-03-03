import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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

void bookingDetails(BuildContext context) {
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Row(
                      children: [
                        CommonImage(
                          imageSrc: AppImages.image3,
                          size: 40,
                          borderRadius: 50,
                          fill: BoxFit.fill,
                        ),

                        12.width,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: "Javier A.",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                              CommonText(
                                text: "#HC-59375959",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff777777),
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
                            color: Color(0xffF2E3C7),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: CommonText(
                            text: AppString.awaitingConfirmation,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffE39400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  34.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
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
                              text: "Darren Monarch",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text:
                                  "4140 Parker Rd. Allentown, New Mexico 31134",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child:
                            CommonImage(
                              imageSrc: AppIcons.calendar,
                              imageColor: Color(0xffFD713F),
                              size: 20,
                            ).center,
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "August 30, 2024 ",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text: "at 01:00 PM - 03:40 PM",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  CommonText(
                    text: AppString.orderStatus,
                    fontSize: 14,
                    top: 32,
                    bottom: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),

                  _buildOrderStatusTimeline("Awaiting Confirmation"),

                  CommonText(
                    text:
                        "The chef is reviewing your order, and should confirm within 1h32m",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFD713F),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    top: 16,
                  ),
                  33.height,
                  InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      controller.onChangeOrderDetailsPopup();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: AppString.orderDetails,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Chopped Burrito",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text: "2 Items + Without Onions",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                        CommonText(
                          text: "\$20.00",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff272727),
                        ),
                      ],
                    ),
                    12.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Chopped Burrito",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text: "2 Items + Without Onions",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                        CommonText(
                          text: "\$20.00",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff272727),
                        ),
                      ],
                    ),
                    16.height,
                    orderSummary(),
                  ],
                  Divider(),

                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          titleText: AppString.orderGroceries,
                          buttonHeight: 48,
                          buttonRadius: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.message,
                            parameters: {
                              "chatId": "1234",
                              "name": "Cody F.",
                              "image": AppImages.image3,
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 8.sp),
                          padding: EdgeInsets.all(14.sp),
                          decoration: BoxDecoration(
                            color: Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CommonImage(
                            imageSrc: AppIcons.chats,
                            size: 20,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          requestChange(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 8.sp),
                          padding: EdgeInsets.all(14.sp),
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
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}

Widget _buildOrderStatusTimeline(String currentStatus) {
  // Define the order of statuses with SVG paths from your AppIcons
  final List<Map<String, dynamic>> steps = [
    {'title': 'Booking\nOrdered', 'icon': "assets/icons/booking_order.svg", 'status': 'Pending'},
    {'title': 'Chef\nConfirmed', 'icon': "assets/icons/chef_confirmed.svg", 'status': 'Awaiting Confirmation'},
    {'title': 'Groceries\nOrdered', 'icon': "assets/icons/groceries_ordered.svg", 'status': 'Groceries'},
    {'title': 'Booking\nComplete', 'icon': "assets/icons/booking_complete.svg", 'status': 'Complete'},
  ];

  // Logic to determine progress index based on the status string
  int currentStepIndex = 1;
  if (currentStatus == "Pending") currentStepIndex = 0;
  else if (currentStatus == "Awaiting Confirmation") currentStepIndex = 1;
  else if (currentStatus == "Groceries") currentStepIndex = 2;
  else if (currentStatus == "Complete") currentStepIndex = 3;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(steps.length, (index) {
      bool isCompleted = index < currentStepIndex;
      bool isActive = index == currentStepIndex;

      // Color logic for the theme
      Color mainColor = isCompleted
          ? const Color(0xff4CAF50) // Green for finished
          : isActive
          ? const Color(0xffFD713F) // Orange for current
          : const Color(0xffA7A7A7); // Grey for upcoming

      Color bgColor = isCompleted
          ? const Color(0xffE8F5E9)
          : isActive
          ? const Color(0xffFFF2EE)
          : const Color(0xffF5F5F5);

      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                // Connecting line BEFORE the circle
                Expanded(
                  child: index == 0
                      ? const SizedBox()
                      : Container(
                      height: 2.h,
                      color: isCompleted ? const Color(0xff4CAF50) : const Color(0xffD9D9D9)
                  ),
                ),

                // The Step Circle using SvgPicture
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
                    width: 20.sp,
                    colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                    // Add this to debug
                    placeholderBuilder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(10),
                        child: const CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),

                // Connecting line AFTER the circle
                Expanded(
                  child: index == steps.length - 1
                      ? const SizedBox()
                      : Container(
                      height: 2.h,
                      color: index < currentStepIndex ? const Color(0xff4CAF50) : const Color(0xffD9D9D9)
                  ),
                ),
              ],
            ),
            8.height,
            CommonText(
              text: steps[index]['title'],
              fontSize: 10.sp,
              fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.w400,
              color: mainColor,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      );
    }),
  );
}
