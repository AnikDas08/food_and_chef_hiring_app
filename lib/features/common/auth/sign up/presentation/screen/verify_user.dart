
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../widget/resend_otp.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    SignUpController.instance.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section starts here
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
      ),

      /// Body Section starts here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.pleaseVerifyYourEmailAddress,
                    fontSize: 24,
                    color: Color(0xff272727),
                    top: 10,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    right: 40,
                    fontWeight: FontWeight.w600,
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
                    text: AppString.enterCode,
                    bottom: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.otpController,
                    hintText: AppString.enterCode,
                    validator: OtherHelper.validator,
                    keyboardType: TextInputType.number,
                  ),

                  12.height,

                  /// Resent OTP or show Timer
                  GestureDetector(
                    onTap:
                        controller.time == '00:00'
                            ? () {
                              controller.startTimer();
                              controller.signUpUser(LocalStorage.myRole);
                            }
                            : () {},
                    child:
                        controller.time == '00:00'
                            ? const ResendOtp()
                            : CommonText(
                              text:
                                  '${AppString.resendCodeIn} ${controller.time} ${AppString.minute}',
                              fontSize: 12,
                              color: const Color(0xff272727),
                            ),
                  ),

                  78.height,

                  ///  Submit Button here
                  CommonButton(
                    titleText: AppString.continues,
                    isLoading: controller.isLoadingVerify,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.verifyOtpRepo();
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
