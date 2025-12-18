import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../utils/constants/app_string.dart';

accountCreatePopup() {
  showDialog(
    context: Get.context!,
    builder: (context) {
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                insetPadding: EdgeInsets.all(16.sp),

                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonImage(imageSrc: AppImages.success, size: 88),
                      CommonText(
                        text: AppString.accountCreated,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                        top: 16,
                        bottom: 8,
                      ),
                      CommonText(
                        text: AppString.accountCreatedMessage,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                        maxLines: 3,
                      ),

                      8.height,
                      Divider(),
                      16.height,
                      CommonButton(
                        titleText: "Go to Home",
                        buttonHeight: 48,
                        buttonRadius: 16,
                        onTap: () {
                          Get.toNamed(AppRoutes.signIn);
                        },
                      ),
                      12.height,
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
