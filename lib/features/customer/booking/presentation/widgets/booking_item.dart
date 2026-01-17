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
import 'details_popup.dart';

Widget bookingItem() {
  return InkWell(
    onTap: () {
      // Get.toNamed(AppRoutes.requestChange);
      bookingDetails(Get.context!);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp).copyWith(right: 0),
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

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
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

              PopupMenuButton<int>(
                padding: EdgeInsets.zero,

                menuPadding: EdgeInsets.zero,
                elevation: 0,
                icon: const Icon(Icons.more_vert),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    Get.toNamed(AppRoutes.requestChange);
                  } else if (value == 2) {

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
                            CommonImage(imageSrc: AppImages.xmark, imageColor: Colors.red,),
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
                left: 8,
                fontWeight: FontWeight.w400,
                color: Color(0xff272727),
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
                color: Color(0xff272727),
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
                color: Color(0xff272727),
              ),
            ],
          ),

          20.height,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.sp),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.info, color: Color(0xffFD713F), size: 16),
                CommonText(
                  text: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffFD713F),
                ),
              ],
            ),
          ),
          20.height,

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
    ),
  );
}
