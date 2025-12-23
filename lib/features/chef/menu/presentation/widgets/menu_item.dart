import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';

Widget menuItem() {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonText(
                  text: "Quesadilla",
                  color: Color(0xff272727),
                  fontWeight: FontWeight.w600,
                ),
                4.height,
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.ingredients,
                      size: 16,
                      imageColor: Color(0xff777777),
                    ),
                    CommonText(
                      text: "Ingredients : ",
                      fontSize: 12,
                      left: 4,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w400,
                    ),
                    CommonText(
                      text: "10 items",
                      fontSize: 12,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                4.height,
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.time,
                      size: 16,
                      imageColor: Color(0xff777777),
                    ),
                    CommonText(
                      text: "Cooking Time : ",
                      fontSize: 12,
                      left: 4,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w400,
                    ),
                    CommonText(
                      text: "40 minutes",
                      fontSize: 12,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                28.height,
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.editMenu);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16),
                            CommonText(
                              text: "Edit Item",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(CupertinoIcons.delete, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          CommonImage(
            imageSrc: AppImages.image6,
            size: 120,
            borderRadius: 8,
          ),
        ],
      ),
    ),
  );
}
