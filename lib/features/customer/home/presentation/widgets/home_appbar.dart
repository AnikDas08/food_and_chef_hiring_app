import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/customer/home/presentation/controller/home_controller.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';

AppBar homeAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    actionsPadding: EdgeInsets.zero,
    title: Row(
      children: [
        Expanded(
          child: GetBuilder<HomeController>(
            builder: (controller)=> GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.addressScreen);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.yourLocation,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    bottom: 2,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xffA7A7A7),
                        size: 20,
                      ),

                      Flexible(
                        child: CommonText(
                          text: controller.address,
                          color: Color(0xff272727),
                          fontWeight: FontWeight.w500,
                          left: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          ),
          child: CommonImage(imageSrc: AppIcons.notification),
        ),
      ),
      12.width,
      Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: Color(0xffF2F2F2),
          shape: BoxShape.circle,
        ),
        child: CommonImage(imageSrc: AppIcons.basket),
      ),
      12.width,
    ],
  );
}
