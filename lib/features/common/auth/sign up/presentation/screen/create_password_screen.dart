import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';

class CreatePasswordScreen extends StatelessWidget {
  CreatePasswordScreen({super.key});

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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  // Conditional Icon based on Platform
                  Platform.isIOS
                      ? Icons.arrow_back_ios_new
                      : Icons.arrow_back,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
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
                    text: AppString.createYourPassword,
                    fontSize: 24,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                    top: 10,
                  ),

                  const CommonText(
                    text: AppString.createYourPasswordMessage,
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
                    text: AppString.newPassword,
                    bottom: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.passwordController,
                    hintText: AppString.enterPassword,
                    validator: OtherHelper.passwordValidator,
                    isPassword: true,
                  ),

                  /// Account Email Input here
                  const CommonText(
                    text: AppString.confirmPassword,
                    bottom: 8,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.confirmPasswordController,
                    hintText: AppString.enterPassword,
                    isPassword: true,
                    validator:
                        (value) => OtherHelper.confirmPasswordValidator(
                          value,
                          controller.passwordController,
                        ),
                  ),
                  28.height,

                  /// Submit Button Here
                  CommonButton(
                    titleText: AppString.continueString,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Get.toNamed(AppRoutes.nameScreen);
                      }
                    },
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
