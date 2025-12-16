import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';

Widget addressItem() {
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xffF8F4F1),
                shape: BoxShape.circle,
              ),
              child: CommonImage(imageSrc: AppIcons.house),
            ),

            12.width,
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "House - Darren Monarch",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text: "+111 4857 2736",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                              top: 2,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffDBEBD9),
                          border: Border.all(color: Color(0xffC2E2BE)),
                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: CommonText(text: "Active"),
                      ),
                    ],
                  ),
                  CommonText(
                    text:
                        "United States -1901 Thornridge Cir. Shiloh, Hawaii, ID : 81063",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff272727),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    top: 12,
                  ),
                  12.height,
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.addAddress);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF1F1F1)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CommonText(
                            text: AppString.editAddress,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.addAddress);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffFF3C3C).withOpacity(0.24),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CommonText(
                            text: AppString.delete,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFF3C3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
