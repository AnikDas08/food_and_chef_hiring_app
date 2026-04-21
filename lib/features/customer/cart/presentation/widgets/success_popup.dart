import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../utils/constants/app_string.dart';

void successPopup() {
  showDialog(
    context: Get.context!,
    builder: (context) {
      // Controller for the animation
      return AnimationPopUp(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          ),
          builder: (context, child) {
            return FadeTransition(
              opacity: ModalRoute.of(context)!.animation!,
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: const Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CommonImage(imageSrc: AppImages.reviewSuccess, size: 88),
                      const CommonText(
                        text: AppString.checkoutSuccessful,
                        fontSize: 16,
                        top: 16,
                        bottom: 8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      const CommonText(
                        text: AppString.yourChefWillConfirmYouOrderShortly,
                        fontSize: 12,
                        bottom: 32,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                        maxLines: 5,
                      ),
                      CommonButton(
                        titleText: AppString.seeOrderDetails,
                        buttonHeight: 48,
                        buttonRadius: 16,
                        onTap: () async {
                          await AnimationPopUpState.closeDialog();
                        },
                      ),

                      16.height,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
