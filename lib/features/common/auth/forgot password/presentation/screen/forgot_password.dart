
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../controller/forget_password_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../../../../../../../utils/helpers/other_helper.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 60,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.pleaseEnterYourEmail,
                    fontSize: 24,
                    color: Color(0xff272727),
                    top: 10,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),

                  const CommonText(
                    text: AppString.enterYourEmail,
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
                    text: AppString.enterEmail,
                    bottom: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.emailController,
                    hintText: AppString.enterYourEmailAddress,
                    validator: OtherHelper.validator,
                  ),

                  12.height,

                  /// Submit Button Here
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            child: SafeArea(
              child: CommonButton(
                titleText: AppString.submit,
                isLoading: controller.isLoadingEmail,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.forgotPasswordRepo();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
