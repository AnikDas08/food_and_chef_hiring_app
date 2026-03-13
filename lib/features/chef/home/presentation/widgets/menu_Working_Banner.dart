import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import '../../../../../component/text/common_text.dart';

Widget menuWorkingBanner() {
  return Container(
    // margin: EdgeInsets.symmetric(horizontal: 16.w),
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
    decoration: BoxDecoration(
      color: const Color(0xff2C2C2C),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [

        /// Image
        CircleAvatar(
          radius: 25.r,
          backgroundImage: AssetImage(AppImages.image3),
        ),

        SizedBox(width: 12.w),

        /// Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                maxLines: 1,
                text: "Your booking with Jimmy starts in 1 hour",
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2.h),
              CommonText(
                maxLines: 1,
                text: "Click here when you've arrived to the customer and you're ready to start cooking!",
                fontSize: 12.sp,
                color: Colors.white70,
              ),
            ],
          ),
        ),

        Icon(Icons.chevron_right, color: Colors.white)
      ],
    ),
  );
}