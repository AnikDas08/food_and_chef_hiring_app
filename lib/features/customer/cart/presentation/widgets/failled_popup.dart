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

failledPopup() {
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
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonImage(imageSrc: AppImages.error, size: 88),
                      CommonText(
                        text: AppString.checkoutFailed,
                        fontSize: 16,
                        top: 16,
                        bottom: 8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: AppString.checkoutFailedMessage,
                        fontSize: 12,
                        bottom: 32,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                        maxLines: 5,
                      ),
                      CommonButton(
                        titleText: AppString.tryAgain,
                        buttonHeight: 48,
                        buttonRadius: 16,
                        titleColor: Color(0xffFFFFFF),
                        onTap: () async {
                          await AnimationPopUpState.closeDialog();
                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );
                          // successPopup();
                          failledPopup();
                        },
                      ),
                      12.height,
                      CommonButton(
                        titleText: AppString.cancel,
                        buttonHeight: 48,
                        buttonRadius: 16,
                        buttonColor: Color(0xffF2F2F2),
                        borderColor: Colors.transparent,
                        titleColor: Color(0xff777777),
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
