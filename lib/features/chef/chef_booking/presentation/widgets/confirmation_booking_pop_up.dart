import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/chef/chef_booking/presentation/widgets/success_booking.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';
confirmBookingPopUp({required String orderMongoId}) {
  showDialog(
    context: Get.context!,
    builder: (_) {
      return AnimationPopUp(
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: const Color(0xffFFFFFF),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonImage(imageSrc: AppImages.warning, size: 88),
                CommonText(
                  text: AppString.customersAreBusyToo,
                  fontSize: 16,
                  top: 16,
                  bottom: 8,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),
                CommonText(
                  text: AppString.pleaseAcceptOrDeclineTheOrder,
                  fontSize: 12,
                  bottom: 32,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff777777),
                  maxLines: 5,
                ),

                CommonButton(
                  titleText: AppString.accept,
                  buttonHeight: 48,
                  titleSize: 16,
                  buttonRadius: 16,
                  titleWeight: FontWeight.w600,
                  titleColor: const Color(0xffFFFFFF),
                  onTap: () async {

                    if (Get.isDialogOpen == true) Get.back();

                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      final homeC = Get.find<ChefHomeController>();
                      final res = await homeC.confirmBooking(orderMongoId);

                      // 3) Loader close
                      if (Get.isDialogOpen == true) Get.back();

                      if (res.statusCode == 200 && res.data?['success'] == true) {
                        // 4) List refresh (চাইলে instant removeও করতে পারো)
                        homeC.fetchRequestedBookings();
                        homeC.fetchUpcomingBookings();

                        // 5) Success popup
                        await Future.delayed(const Duration(milliseconds: 200));
                        successBookingPopUp();
                      } else {
                        Get.snackbar(
                          "Error",
                          res.data?['message']?.toString() ?? "Something went wrong",
                        );
                      }
                    } catch (e) {
                      if (Get.isDialogOpen == true) Get.back();
                      Get.snackbar("Error", "Something went wrong");
                    }
                  },
                ),

                12.height,

                CommonButton(
                  titleText: AppString.decline,
                  buttonHeight: 48,
                  titleSize: 16,
                  buttonRadius: 16,
                  buttonColor: const Color(0xffF2F2F2),
                  borderColor: Colors.transparent,
                  titleWeight: FontWeight.w600,
                  titleColor: const Color(0xff777777),
                  onTap: () async {

                    Get.back();
                  },
                ),
                16.height,
              ],
            ),
          ),
        ),
      );
    },
  );
}