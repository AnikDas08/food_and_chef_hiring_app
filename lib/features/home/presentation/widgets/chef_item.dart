import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';

import '../../../../component/image/common_image.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_images.dart';

dynamic checkCondition() {
  int randomNumber = Random().nextInt(100); // generates 0–99
  return randomNumber < 10 ? true : false;
}

Widget chefItem({num height = 200}) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xffF1F1F1)),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.only(right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Stack(
          children: [
            CommonImage(
              imageSrc: AppImages.image3,
              height: height.toDouble(),
              borderRadius: 8,
              fill: BoxFit.fill,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(0xffFFFFFF).withOpacity(0.16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Color(0xffE39400), size: 16),
                    CommonText(
                      text: "4.5(482 Reviews)",
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            if (checkCondition())
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff00580F), Color(0xff00AB1D)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color(0xff00B41E)),
                  ),
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: AppIcons.chef,
                        imageColor: Colors.white,
                      ),
                      CommonText(
                        text: "Professional Chef",
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Javier A.",
                fontSize: 12,
                color: Color(0xff272727),
                fontWeight: FontWeight.w600,
                top: 8,
                bottom: 4,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonImage(imageSrc: AppIcons.location),
                  CommonText(
                    text: "2km",
                    fontSize: 12,
                    color: Color(0xff777777),
                    left: 4,
                    right: 4,
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
              SizedBox(
                height: 20,
                width: 200.w,
                child: Divider(color: Color(0xffF1F1F1)),
              ),

              CommonText(
                text: "\$70.00",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
