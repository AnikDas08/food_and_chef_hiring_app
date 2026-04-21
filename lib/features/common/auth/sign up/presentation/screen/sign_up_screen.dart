import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts Here
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,

      ),

      /// Body Section Starts Here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.registerAccount,
                    fontSize: 24,
                    color: Color(0xff272727),
                    maxLines: 2,
                    fontWeight: FontWeight.w600,
                    top: 10,
                  ),

                  const CommonText(
                    text: AppString.registerAccountMessage,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    maxLines: 2,
                    top: 8,
                    textAlign: TextAlign.start,
                    bottom: 28,
                  ),

                  /// Account Email Input here
                  const CommonText(
                    text: AppString.email,
                    bottom: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.emailController,
                    hintText: AppString.email,
                    validator: OtherHelper.emailValidator,
                  ),
                  28.height,

                  /// Submit Button Here
                  CommonButton(
                    titleText: AppString.signUp,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.signUpUser("CUSTOMER");
                      }
                    },
                  ),
                  28.height,

                  Row(
                    children: [
                      Expanded(child: Divider()),
                      10.width,
                      const CommonText(
                        text: AppString.orUsing,
                        fontSize: 12,
                        color: Color(0xff777777),
                      ),
                      10.width,
                      Expanded(child: Divider()),
                    ],
                  ),

                  28.height,
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonImage(imageSrc: AppIcons.facebook),
                        CommonText(
                          text: AppString.signInWithFacebook,
                          left: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  12.height,
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonImage(imageSrc: AppIcons.google),
                        CommonText(
                          text: AppString.signInWithGoogle,
                          left: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RichText(
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                          ),
                          children: [
                            TextSpan(text: "Sign up to Privae as a "),
                            TextSpan(
                              text: "Chef",
                              style: TextStyle(
                                fontWeight: FontWeight.w600, // different style
                                color: Color(
                                  0xff000000,
                                ), // change color যদি চাও
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.offNamed(AppRoutes.signUpChef);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
