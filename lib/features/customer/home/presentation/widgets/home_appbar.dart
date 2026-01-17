import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    elevation: 0,
    scrolledUnderElevation: 0,
    shadowColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,


    title: Column(
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
            Icon(Icons.location_on_rounded, color: Color(0xffA7A7A7), size: 20),

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
    // flexibleSpace: ClipRect(
    //   child: BackdropFilter(
    //     filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    //     child: Container(
    //       decoration: const BoxDecoration(
    //         gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: [
    //             Color.fromRGBO(255, 255, 255, 1.0),
    //             Color.fromRGBO(255, 255, 255, 0.0),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ),

    /// With Liquid Glass
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1.0),
                    Color.fromRGBO(255, 255, 255, 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
              child: CommonImage(
                imageSrc: AppIcons.notification,
                imageColor: Colors.black,
              ),
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
            child: CommonImage(
              imageSrc: AppIcons.basket,
              imageColor: Colors.black,
            ),
          ),
        ),
      ),
      12.width,
    ],
  );
}
