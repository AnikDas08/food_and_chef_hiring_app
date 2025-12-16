import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import 'past_item_details_popup.dart';

Widget pastItem( BuildContext context) {
  return InkWell(
    onTap: () {
      pastItemDetailsPopup(context);
      // Get.toNamed(AppRoutes.requestChange);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        border: Border.all(color: Color(0xffF1F1F1)),
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

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  color: Color(0xffDBEBD9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xffC2E2BE), width: 1),
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

          16.height,
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color: Color(0xffF1F1F1)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.date,
                      size: 16,
                      imageColor: Color(0xffFD713F),
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
                      imageColor: Color(0xffFD713F),
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
                      imageColor: Color(0xffFD713F),
                    ),
                    CommonText(
                      text: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                      fontSize: 12,
                      left: 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),

          12.height,

          Divider(color: Color(0xffF1F1F1)),
          8.height,
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
                  vertical: 8.sp,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.sp),
                  border: Border.all(color: Color(0xffF1F1F1)),
                ),
                child: Row(
                  children: [
                    CommonText(
                      text: "You rated 5",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      right: 4,
                    ),
                    Icon(Icons.star, color: Color(0xffFD713F), size: 16),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.sp,
                  vertical: 8.sp,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff272727),
                  borderRadius: BorderRadius.circular(30.sp),
                  border: Border.all(color: Color(0xffF1F1F1)),
                ),
                child: CommonText(
                  text: AppString.reorder,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  right: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
