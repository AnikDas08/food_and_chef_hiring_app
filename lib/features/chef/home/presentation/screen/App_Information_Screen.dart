import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../utils/constants/app_icons.dart';

class AppInformationScreen extends StatelessWidget {

  const AppInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: CommonImage(
                imageSrc: AppIcons.backIcon,
                size: 24,
              ),
            ),
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AppImages.app_logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              "Version 1.01.01",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}