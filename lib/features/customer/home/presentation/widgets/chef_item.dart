import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';

dynamic checkCondition() {
  int randomNumber = Random().nextInt(100); // generates 0–99
  return randomNumber < 10 ? true : false;
}

Widget chefItem({num height = 200}) {
  return InkWell(
    onTap: () => Get.toNamed(AppRoutes.chefDetails),
    child: Container(
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CommonImage(
                imageSrc: AppImages.image3,
                height: height.toDouble(),
                width: 240.w,
                borderRadius: 8,
                fill: BoxFit.fill,
              ),

              if (checkCondition())
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: CommonImage(imageSrc: AppIcons.chef),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 210.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: "Olivia Z.",
                        fontSize: 12,
                        color: Color(0xff272727),
                        fontWeight: FontWeight.w600,
                        top: 8,
                        bottom: 4,
                      ),
                      Spacer(),
                      Icon(Icons.star, color: Color(0xffFD713F), size: 16.sp),
                      CommonText(
                        text: "4.5",
                        fontSize: 12,
                        color: Color(0xff272727),
                        fontWeight: FontWeight.w600,
                        left: 4,
                        right: 4,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: 200.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonImage(imageSrc: AppIcons.location),
                      CommonText(
                        text: "2km",
                        fontSize: 12,
                        color: Color(0xff777777),
                        left: 4,
                        right: 16,
                      ),
                      CommonImage(imageSrc: AppIcons.briefcase),
                      Expanded(
                        child: CommonText(
                          text: "4 years Experience",
                          fontSize: 12,
                          left: 4,
                          color: Color(0xff777777),
                        ),
                      ),
                    ],
                  ),
                ),

                24.height,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "\$70.00",
                        style: GoogleFonts.inter(
                          color: Color(0xff272727),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      /// Sign Up Button here
                      TextSpan(
                        text: " /hr",
                        style: GoogleFonts.inter(
                          color: Color(0xff272727),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
