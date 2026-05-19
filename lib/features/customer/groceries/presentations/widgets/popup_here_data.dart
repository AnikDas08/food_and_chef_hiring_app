import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/features/customer/groceries/presentations/controller/grocerie_controller.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/my_grocerires_controller.dart';

class GroceryConfirmationPopup extends StatelessWidget {
  final GroceryController controller; // <-- add this

  const GroceryConfirmationPopup({
    super.key,
    required this.controller, // <-- add this
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/icons/info.svg",
              height: 56,
              width: 56,
            ),
            SizedBox(height: 24.h),

            const CommonText(
              text: 'By clicking "I got my groceries", you confirm that:',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),
            SizedBox(height: 16.h),

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

            CommonButton(
              titleText: "I got my groceries",
              onTap: () async {
                Navigator.pop(Get.context!); // close popup first
                await controller.confirmGroceries(); // use passed controller
              },
            ),
            SizedBox(height: 12.h),

            CommonButton(
              titleText: "Cancel",
              onTap: () => Get.back(),
              buttonColor: const Color(0xffF2F2F2),
              titleColor: const Color(0xff777777),
            ),
          ],
        ),
      ),
    );
  }
}