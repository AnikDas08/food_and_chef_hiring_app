import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';

AppBar chefHomeAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,

    centerTitle: false,
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 255, 255, 0.9),
                Color.fromRGBO(255, 255, 255, 0.80),
                Color.fromRGBO(255, 255, 255, 0.60),
                Color.fromRGBO(255, 255, 255, 0.40),
                Color.fromRGBO(255, 255, 255, 0.20),
                Color.fromRGBO(255, 255, 255, 0.0),
              ],
            ),
          ),
        ),
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
        child: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 30),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withOpacity(0.07)),
              ),
              child: Icon(CupertinoIcons.bell, color: Color(0xff272727)),
            ),
          ),
        ),
      ),
      12.width,
    ],
  );
}
