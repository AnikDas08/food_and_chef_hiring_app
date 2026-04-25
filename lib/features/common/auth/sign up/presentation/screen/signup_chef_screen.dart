
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_untitled/component/other_widgets/app_bar_opacity.dart';
import 'package:new_untitled/features/common/auth/signup_chef/presentation/controller/sign_up_chef_controller.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../../../../../../../utils/constants/app_string.dart';

class SignupChefScreen extends StatelessWidget {
  SignupChefScreen({super.key});

  final _formKeys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: appBarOpacity(),
      ),
      /// Body Section Starts Here
      body: GetBuilder<SignUpChefController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKeys,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.registerAccountchef,
                    fontSize: 24,
                    color: Color(0xff272727),
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

                  CommonButton(
                    titleText: AppString.signUp,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKeys.currentState!.validate()) {
                        controller.signUpUser('CHEF');
                      }
                    },
                  ),
                  28.height,
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      10.width,
                      const CommonText(
                        text: AppString.orUsing,
                        fontSize: 12,
                        color: Color(0xff777777),
                      ),
                      10.width,
                      const Expanded(child: Divider()),
                    ],
                  ),

                  28.height,
                  Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonImage(imageSrc: AppIcons.facebook),
                        CommonText(
                          text: AppString.signUpWithFacebook,
                          left: 14,
                        ),
                      ],
                    ),
                  ),
                  12.height,
                  Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonImage(imageSrc: AppIcons.google),
                        CommonText(
                          text: AppString.signUpWithGoogle,
                          left: 14,
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                          ),
                          children: [
                            const TextSpan(text: 'Sign up to Privae as a '),
                            TextSpan(
                              text: 'Customer',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff000000),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offNamed(AppRoutes.signUp);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
