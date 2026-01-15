import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';

AppBar chefHomeAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    centerTitle: false,
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(color: Colors.white.withOpacity(0.1)),
      ),
    ),
    title: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Hello, Javier 👋",
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonText(
                text: "Let's get cooking!",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff777777),
                left: 4,
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      InkWell(
        onTap: () => Get.toNamed(AppRoutes.notifications),
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.07)),
          ),
          child: CommonImage(imageSrc: AppIcons.notification),
        ),
      ),
      12.width,
    ],
  );
}
