import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

AppBar homeAppbar() {
  return AppBar(
    leading: CommonImage(imageSrc: AppIcons.menu),
    title: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonText(
                text: AppString.yourLocation,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff777777),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Color(0xffFD713F),
                    size: 20,
                  ),

                  Expanded(
                    child: CommonText(
                      text: "4140 Parker Rd. Allentown, New Mexico 31134",
                      color: Color(0xff272727),
                      left: 4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [CommonImage(imageSrc: AppIcons.shop)],
  );
}
