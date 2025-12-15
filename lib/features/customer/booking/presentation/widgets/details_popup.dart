import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(12.sp),
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
                      child: CommonImage(
                        imageSrc: AppIcons.location,
                        imageColor: Color(0xffFD713F),
                        size: 20,
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
                            text: "4140 Parker Rd. Allentown, New Mexico 31134",
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
                      child: CommonImage(
                        imageSrc: AppIcons.date,
                        imageColor: Color(0xffFD713F),
                        size: 20,
                      ),
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

                CommonImage(imageSrc: AppImages.orderStatus, height: 88),

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
                        Icons.arrow_forward_ios_sharp,
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
                    Container(
                      margin: EdgeInsets.only(left: 8.sp),
                      padding: EdgeInsets.all(14.sp),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CommonImage(imageSrc: AppIcons.chats, size: 20),
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
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}
