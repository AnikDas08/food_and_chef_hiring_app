import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/grocerie_controller.dart';
import '../controller/my_grocerires_controller.dart';

class GroceryConfirmationPopup extends StatelessWidget {
  const GroceryConfirmationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 1. Yellow Warning Icon
            Container(
              width: 80.w,
              height: 80.w,
              decoration: const BoxDecoration(
                color: Color(0xffEBB02D), // Golden/Yellow color from image
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.priority_high, color: Colors.white, size: 45.sp),
            ),
            SizedBox(height: 24.h),

            /// 2. Header Title
            const CommonText(
              text: 'By clicking "I got my groceries", you confirm that:',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),

            /// 3. Description Text
            CommonText(
              text: 'You\'ve purchased the list of groceries here selected, '
                  'and they are ready in your kitchen for the booking to take place.',
              fontSize: 13,
              color: Colors.grey,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            /// 4. Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  // 1. Close the popup first
                  Get.back();

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
                  "I got my groceries",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            /// 5. Cancel Button
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffF5F5F5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}