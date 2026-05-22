import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/features/customer/groceries/presentations/controller/grocerie_controller.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/chef_detail_controller.dart';

class CartConfirmPopUp extends StatelessWidget {
  final ChefDetailsController controller;
  final Map<String, dynamic> data;
  const CartConfirmPopUp({
    super.key,
    required this.controller,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
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
              text: 'By clicking ‘Confirm’, your previous cart will be replaced.',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              maxLines: 2,
            ),
            SizedBox(height: 16.h),

            const CommonText(
              text: 'Your current action will replace the previous cart. Any items saved in your existing cart will be replaced with the new cart.',
              fontSize: 12,
              color: Color(0xff777777),
              fontWeight: FontWeight.w400,
              maxLines: 3,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 32.h),

            CommonButton(
              titleText: "Confirm",
              onTap: () async {
                await controller.addToCart(data, forceReplace: true);
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