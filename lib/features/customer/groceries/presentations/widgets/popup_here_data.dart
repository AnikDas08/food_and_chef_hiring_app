import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/my_grocerires_controller.dart';

class GroceryConfirmationPopup extends StatelessWidget {
  const GroceryConfirmationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 1. Yellow Warning Icon
            SvgPicture.asset(
              "assets/icons/info.svg",
              height: 56,
              width: 56,
            ),
            SizedBox(height: 24.h),

            /// 2. Header Title
            const CommonText(
              text: 'By clicking "I got my groceries", you confirm that:',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),
            SizedBox(height: 16.h),

            /// 3. Description Text
            const CommonText(
              text: 'You\'ve purchased the list of groceries here selected, '
                  'and they are ready in your kitchen for the booking to take place.',
              fontSize: 12,
              color: Color(0xff777777),
              fontWeight: FontWeight.w400,
              maxLines: 3,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 32.h),

            /// 4. Confirm Button
            /*SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  // 1. Close the popup first
                  Navigator.pop(Get.context!);

                  // 2. Find the controller and trigger the API loop
                  final controller = Get.find<ConfirmedGroceryController>();
                  controller.confirmGroceries();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff262626),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  elevation: 0,
                ),
                child: const Text(
                  'I got my groceries',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),*/
            
            CommonButton(
                titleText: "I got my gorceries",
              onTap: (){
                // 1. Close the popup first
                Navigator.pop(Get.context!);

                // 2. Find the controller and trigger the API loop
                final controller = Get.find<ConfirmedGroceryController>();
                controller.confirmGroceries();
              },
            ),
            SizedBox(height: 12.h),

            /// 5. Cancel Button
            CommonButton(
              titleText: "Cancel",
              onTap: (){
                Get.back();
              },
              buttonColor: Color(0xffF2F2F2),
              titleColor: Color(0xff777777),
            )
          ],
        ),
      ),
    );
  }
}