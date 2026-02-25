import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/constants/app_string.dart';

deletePopUp() {
  final passwordController = TextEditingController();
  final RxBool isObscure = true.obs;

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonImage(imageSrc: AppImages.delete, size: 88),
                      CommonText(
                        text: AppString.deleteAccount,
                        fontSize: 16,
                        top: 16,
                        bottom: 8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: AppString.areYouSureYouWantToDeleteYourAccount,
                        fontSize: 12,
                        bottom: 16,
                        left: 30,
                        right: 30,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                        maxLines: 5,
                      ),

                      // Password Input
                      Obx(() => TextField(
                        controller: passwordController,
                        obscureText: isObscure.value,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(fontSize: 13, color: Color(0xff999999)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          filled: true,
                          fillColor: Color(0xffF2F2F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => isObscure.value = !isObscure.value,
                            child: Icon(
                              isObscure.value ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xff999999),
                              size: 20,
                            ),
                          ),
                        ),
                      )),

                      16.height,

                      CommonButton(
                        titleText: AppString.no,
                        buttonHeight: 48,
                        titleSize: 16,
                        buttonRadius: 16,
                        titleWeight: FontWeight.w600,
                        titleColor: Color(0xffFFFFFF),
                        onTap: () async {
                          await AnimationPopUpState.closeDialog();
                        },
                      ),
                      12.height,
                      CommonButton(
                        titleText: AppString.yes,
                        buttonHeight: 48,
                        titleSize: 16,
                        buttonRadius: 16,
                        buttonColor: Color(0xffF2F2F2),
                        borderColor: Colors.transparent,
                        titleWeight: FontWeight.w600,
                        titleColor: Color(0xff777777),
                        onTap: () async {
                          final password = passwordController.text.trim();

                          if (password.isEmpty) {
                            Get.snackbar("Warning", "Please enter your password");
                            return;
                          }

                          await AnimationPopUpState.closeDialog();

                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          try {
                            final res = await ApiService.delete(
                              ApiEndPoint.deleteAccount,
                              body: {"password": password},
                            );

                            Get.back();

                            if (res.statusCode == 200 && res.data?['success'] == true) {
                              Get.snackbar("Success", "Account deleted successfully");
                              Get.offAllNamed('/login');
                            } else {
                              Get.snackbar("Message", res.data?['message']?.toString() ?? "Something went wrong");
                            }
                          } catch (e) {
                            Get.back();
                            Get.snackbar("Message", "Something went wrong");
                          }
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