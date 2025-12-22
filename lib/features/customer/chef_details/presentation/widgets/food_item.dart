import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import 'item_details.dart';

Widget foodItem(BuildContext context) {
  return InkWell(
    onTap: () {
      itemDetails(context);
    },
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Row(
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xffDBEBD9),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0xffC2E2BE)),
                      ),
                      child: CommonText(
                        text: "Your Kitchen is Ready",
                        color: Color(0xff2F8328),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
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
        ],
      ),
    ),
  );
}
