import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../component/button/common_button.dart';
import '../../../../component/image/common_image.dart';
import '../../../../component/text/common_text.dart';
import '../../../../config/route/app_routes.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_string.dart';
import 'indicatior.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F4F1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    28.height,
                    CommonImage(imageSrc: AppImages.logo),
                    28.height,
                    CommonImage(
                      imageSrc: AppImages.onboarding_1,
                      fill: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  CommonText(
                    text: AppString.welcomeToPrivae,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 28,
                  ),
                  CommonText(
                    text: AppString.effortlesslyHirePersonal,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    top: 12,
                    bottom: 20,
                    maxLines: 3,
                  ),

                  indicator(currentIndex: 0),
                  28.height,

                  CommonButton(
                    titleText: AppString.signIn,
                    onTap: () => Get.toNamed(AppRoutes.signIn),
                  ),
                  12.height,

                  CommonButton(
                    titleText: "I’m New, Sign Me Up",
                    buttonColor: Color(0xffF2F2F2),
                    borderColor: Colors.transparent,
                    titleColor: Colors.black,
                    titleSize: 16,
                    titleWeight: FontWeight.w600,
                    onTap: () => Get.toNamed(AppRoutes.signUp),
                  ),
                  20.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
