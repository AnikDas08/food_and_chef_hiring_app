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
import '../controller/chef_booking_controller.dart';

declineBookingPopUp() {
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
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: Color(0xffFFFFFF),
                child: GetBuilder<ChefBookingController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(
                            text: "Want to cancel order?",
                            fontSize: 16,
                            top: 16,
                            bottom: 8,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                          CommonText(
                            text:
                                "Please select a reason why you want to decline the request?",
                            fontSize: 12,
                            bottom: 12,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                            maxLines: 5,
                          ),
                          ListView.builder(
                            itemCount: controller.dietaryOption.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              String value = controller.dietaryOption[index];
                              return InkWell(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,

                                onTap: () {
                                  controller.onChangeDietary(value);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 15.sp,
                                        height: 15.sp,
                                        decoration: BoxDecoration(
                                          color:
                                              controller.selectDietary.contains(
                                                    value,
                                                  )
                                                  ? Color(0xff272727)
                                                  : Color(0xffF1F1F1),
                                          shape: BoxShape.circle,
                                        ),
                                        child:
                                            !controller.selectDietary.contains(
                                                  value,
                                                )
                                                ? null
                                                : Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                      ),
                                      CommonText(
                                        text: value,
                                        fontSize: 12,
                                        left: 8,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff272727),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          12.height,
                          CommonButton(
                            titleText: AppString.submit,
                            buttonHeight: 48,
                            titleSize: 16,
                            buttonRadius: 16,
                            titleWeight: FontWeight.w600,
                            titleColor: Colors.white,
                            onTap: () async {
                              await AnimationPopUpState.closeDialog();
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                            },
                          ),
                          16.height,
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
