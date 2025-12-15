import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';

Widget cartItem(BuildContext context) {
  RxInt count = 1.obs;

  return InkWell(
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(8),
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
                      text: "Chopped Burrito",
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w600,
                    ),
                    4.height,
                    CommonText(
                      text: "1 items / Without Onions",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                    4.height,

                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (count.value == 0) return;
                              count.value--;
                            },
                            child: Icon(Icons.remove, size: 16),
                          ),
                          Obx(
                            () => SizedBox(
                              width: 30,
                              child: CommonText(
                                text: count.value.toString(),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                left: 12,
                                right: 12,
                                color: Color(0xff272727),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              count.value++;
                            },
                            child: Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                    ),
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
          8.height,
          Divider(),
        ],
      ),
    ),
  );
}
