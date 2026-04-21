
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../../../sign up/presentation/widget/resend_otp.dart';
import '../controller/forget_password_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();

  /// init State here
  @override
  void initState() {
    ForgetPasswordController.instance.startTimer();
    super.initState();
  }

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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.enter6DigitsCode,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 10,
                  ),

                  const CommonText(
                    text: AppString.weveSentAnEmailToDarrenmonarchGmailCom,
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
                  16.height,
                  GestureDetector(
                    onTap:
                        controller.time == '00:00'
                            ? () {
                              controller.startTimer();
                            }
                            : () {},
                    child:
                        controller.time == '00:00'
                            ? const ResendOtp()
                            : CommonText(
                              text:
                                  '${AppString.resendCodeIn} ${controller.time} ${AppString.minute}',
                            ),
                  ),

                  /// Submit Button Here
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            child: SafeArea(
              child: CommonButton(
                titleText: AppString.continueString,
                isLoading: controller.isLoadingEmail,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.verifyOtpRepo();
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
