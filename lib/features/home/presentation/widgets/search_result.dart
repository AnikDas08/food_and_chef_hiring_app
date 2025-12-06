import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../component/image/common_image.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_icons.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_string.dart';

Widget searchResult() {
  return Column(
    children: [
      CommonText(
        text: AppString.relatedResult.toUpperCase(),
        fontSize: 12,
        color: Color(0xff777777),
        fontWeight: FontWeight.w500,
        top: 20,
        bottom: 16,
      ).start,
      Expanded(
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    CommonImage(imageSrc: AppImages.image4, size: 42),

                    12.width,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: "Albert Smith",
                            fontSize: 12,
                            color: Color(0xff272727),
                            fontWeight: FontWeight.w500,
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
                              CommonText(
                                text: "4 years Experience",
                                fontSize: 12,
                                left: 4,
                                color: Color(0xff777777),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    ],
  );
}
