import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';

AppBar homeAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    centerTitle: false,
    title: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: AppString.yourLocation,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                bottom: 2,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Color(0xffA7A7A7),
                    size: 20,
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.addressScreen);
                      },
                      child: CommonText(
                        text: "4140 Parker Rd. Allentown, New Mexico 31134",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        left: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    flexibleSpace: Stack(
      fit: StackFit.expand,
      children: [
        // 🌊 GLASS BACKGROUND (ONLY)
        LiquidGlassLayer(
          settings: LiquidGlassSettings(
            thickness: 14,
            blur: 22,
            glassColor: Colors.white.withOpacity(0.22),
          ),
          child: LiquidGlass(

            shape: LiquidRoundedSuperellipse(borderRadius: 30),
            child: Container(),
          ),
        ),

        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.35),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 0.6,
            color: Colors.white.withOpacity(0.25),
          ),
        ),
      ],
    ),


    actions: [
      LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 30),
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withOpacity(0.07)),
              ),
              child: CommonImage(imageSrc: AppIcons.notification, imageColor: Colors.black,),
            ),
          ),
        ),
      ),
      12.width,
      LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 30),
          child: Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withOpacity(0.07)),
            ),
            child: CommonImage(imageSrc: AppIcons.basket, imageColor: Colors.black,),
          ),
        ),
      ),
      12.width,
    ],
  );
}
