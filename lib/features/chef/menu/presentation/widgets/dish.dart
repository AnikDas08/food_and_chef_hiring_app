import 'package:flutter/cupertino.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';

Widget dish(String title) {
  return Row(
    children: [
      CommonImage(imageSrc: AppIcons.dish),
      CommonText(
        text: title,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xff272727),
        left: 8,
      ),
    ],
  );
}
