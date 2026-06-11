import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/features/customer/groceries/presentations/controller/grocerie_controller.dart';
import '../../../../../component/text/common_text.dart';

import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../groceries/presentations/screens/groceries_screen.dart';
import '../controller/home_controller.dart';

class ConfirmGroceriesPopup extends StatelessWidget {
  const ConfirmGroceriesPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CommonText(
              text: 'Confirm Grocery Purchase',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),
            SizedBox(height: 12.h,),
            const CommonText(
              text: 'Please confirm that all ingredients have been purchased for your chef visit. We’ll let your chef know that everything is ready.',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff777777),
              maxLines: 4,
            ),
            SizedBox(height: 32.h),


            CommonButton(
              titleText: "Confirm Ingredients",
              onTap: () async {
                Get.back(); // Close dialog
                await homeController.confirmGroceriesMyself();
              },
            ),
            SizedBox(height: 12.h),

            CommonButton(
              titleText: "Cancel",
              onTap: () async {
                Get.back();
              },
              buttonColor: const Color(0xffF2F2F2),
              titleColor: const Color(0xff777777),
            ),
          ],
        ),
      ),
    );
  }
}