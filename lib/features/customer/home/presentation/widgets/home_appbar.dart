import 'package:flutter/cupertino.dart';
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

import '../../../../../component/other_widgets/app_bar_opacity.dart';
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
            Icon(Icons.location_on_rounded, color: Color(0xff272727), size: 20),

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
    flexibleSpace: appBarOpacity(),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(20),
      child: Container(height: 20),
    ),

    actions: [
      LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 30),
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            child: Container(
              width: 40.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
              ),
              child:
                  Icon(
                    CupertinoIcons.bell,
                    color: Colors.black,
                    size: 24,
                  ).center,
            ),
          ),
        ),
      ),
      12.width,
      LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 30),
          child: Container(
            width: 40.sp,
            height: 40.sp,
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
            ),
            child:
                CommonImage(
                  imageSrc: AppIcons.basketSvg,
                  imageColor: Colors.black,
                ).center,
          ),
        ),
      ),
      16.width,
    ],
  );
}
