import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import 'earning_chart.dart';

Widget earning() {
  return Container(
    height: 320.h,
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xffF2F2F2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: AppString.totalEarning,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                ),
                CommonText(
                  text: "\$9,280",
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                Row(
                  children: [
                    CommonImage(imageSrc: AppIcons.arrowUpDown),
                    CommonText(
                      text: "0.48%",
                      fontSize: 12,
                      left: 4,
                      right: 4,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2F8328),
                    ),
                    CommonText(
                      text: "higher than last week",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff272727),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CommonText(
                    text: "Weekly",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff272727),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
        Expanded(child: LineChartSample2()),
      ],
    ),
  );
}
