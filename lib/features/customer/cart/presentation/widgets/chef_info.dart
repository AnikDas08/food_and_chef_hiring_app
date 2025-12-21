import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';

Widget chefInfo() {
  return Row(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonText(
              text: "Javier A.",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),
            CommonText(
              text: "\$40 per hour",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff777777),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.mode_edit_outline_outlined, size: 16),
            CommonText(
              text: AppString.editOrder,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
              left: 6,
            ),
          ],
        ),
      ),
    ],
  );
}
