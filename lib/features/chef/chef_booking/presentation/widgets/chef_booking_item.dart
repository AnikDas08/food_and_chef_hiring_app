import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/chef_booking_controller.dart';
import 'booking_details_popup.dart';
import 'package:get/get.dart';

import 'confirmation_booking_pop_up.dart';

Widget chefBookingItem() {
  final controller = Get.find<ChefBookingController>();
  return InkWell(
    onTap: () {
      bookingDetailsPopup(Get.context!);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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

              controller.selectedBookingHistory == "Unconfirmed"
                  ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.sp,
                      vertical: 5.sp,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffF5EDDD),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: CommonText(
                      text: "Requested",
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffE39400),
                    ),
                  )
                  : controller.selectedBookingHistory == "Upcoming"
                  ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.sp,
                      vertical: 5.sp,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffE3ECFD),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: CommonText(
                      text: "Upcoming",
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff4285F4),
                    ),
                  )
                  : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.sp,
                      vertical: 5.sp,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xfffdbebd9),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: CommonText(
                      text: "Completed",
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2F8328),
                    ),
                  ),

              PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    // Request a Change action
                  } else if (value == 2) {
                    // Cancel Booking action
                  }
                },
                itemBuilder:
                    (context) => [
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
              ),
            ],
          ),

          24.height,
          Row(
            children: [
              CommonImage(
                imageSrc: AppIcons.date,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              CommonText(
                text: "29 July, 2024 at 12:30 PM",
                fontSize: 12,
                left: 4,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              CommonImage(
                imageSrc: AppIcons.ingredients,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              CommonText(
                text: "2 items (Chopped Burrito & Italian Pizza)",
                fontSize: 12,
                left: 4,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              CommonImage(
                imageSrc: AppIcons.location,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              CommonText(
                text: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                fontSize: 12,
                left: 4,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),

          20.height,
          if (controller.selectedBookingHistory != "Completed")
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  Icon(CupertinoIcons.info, color: Color(0xffFD713F), size: 16),
                  CommonText(
                    text: "You have 1h35m left to confirm the order",
                    fontSize: 12,
                    left: 4,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFD713F),
                  ),
                ],
              ),
            ),

          if (controller.selectedBookingHistory == "Completed")
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Review",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonText(
                    text:
                        "Javier was awesome! The food was so delicious! Everything was well done, and it made the experience great. I’d love to work with Javier again!",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff272727),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          20.height,

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.total,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: "\$145.00",
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 2,
                  ),
                ],
              ),
              Spacer(),
              if (controller.selectedBookingHistory == "Unconfirmed") ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: CommonText(
                    text: AppString.decline,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFF3C3C),
                  ),
                ),
                InkWell(
                  onTap: () {
                    confirmBookingPopUp();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.sp,
                      vertical: 8.sp,
                    ),
                    margin: EdgeInsets.only(left: 8.sp),
                    decoration: BoxDecoration(
                      color: Color(0xff272727),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: CommonText(
                      text: AppString.accept,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              if (controller.selectedBookingHistory == "Upcoming") ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: AppIcons.chat,
                        size: 16,
                        imageColor: Color(0xff272727),
                      ),
                      CommonText(
                        text: AppString.chatWithCustomer,
                        fontSize: 12,
                        left: 6,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                    ],
                  ),
                ),
              ],
              if (controller.selectedBookingHistory == "Completed") ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Row(
                    children: [
                      CommonText(
                        text: "${AppString.rating} 5",
                        fontSize: 12,
                        right: 6,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),

                      Icon(
                        Icons.star_rate_rounded,
                        size: 12,
                        color: Color(0xffFD713F),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}
