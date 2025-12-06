import 'package:flutter/cupertino.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../component/text/common_text.dart';

Widget orderAgain() {
  return ListView.builder(
    itemCount: 5,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffF1F1F1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CommonImage(imageSrc: AppImages.image4, size: 40),
                Column(
                  children: [
                    CommonText(
                      text: "Michael A.",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: "Yesterday",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
              ],
            ),
            12.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: List.generate(3, (index) {
                return CommonImage(imageSrc: AppImages.image5, height: 78);
              }),
            ),
          ],
        ),
      );
    },
  );
}
