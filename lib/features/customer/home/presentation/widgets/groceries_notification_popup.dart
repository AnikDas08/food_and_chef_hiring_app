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

class GroceriesNotificationPopup extends StatelessWidget {
  const GroceriesNotificationPopup({
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
            CommonImage(
                imageSrc: "assets/images/groceries_notification_image.png",
              height: 190.h,
              width: 220.w,
            ),
            SizedBox(height: 16.h),

            const CommonText(
              text: 'Your booking\nis confirmed!...',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),
            SizedBox(height: 32.h),


            CommonButton(
              titleText: "Order Groceries Now",
              onTap: () {
                final orderId = homeController.groceriesOrder.value?['_id'];
                if (orderId != null) {
                  Get.back(); // Close dialog
                  Get.to(() => const GroceryScreen(), arguments: orderId);
                }
              },
            ),
            SizedBox(height: 12.h),

            CommonButton(
              titleText: "I will get Groceries Myself",
              onTap: () async {
                Get.back(); // Close dialog
                await homeController.confirmGroceriesMyself();
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