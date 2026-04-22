import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

class AppInformationScreen extends StatelessWidget {
  const AppInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160.sp,
              height: 160.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(AppImages.app_logo, fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: 20.h),

            CommonText(
              text: 'Version 1.0.1',
              fontSize: 14.sp,
              color: Colors.grey,
              bottom: 50.h,
            ).center,
          ],
        ),
      ),
    );
  }
}
