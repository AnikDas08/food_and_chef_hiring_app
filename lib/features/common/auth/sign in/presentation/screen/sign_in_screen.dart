import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import '../../../../../../../config/route/app_routes.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart'
    show CommonTextField;
import '../controller/sign_in_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../../../../../../../utils/helpers/other_helper.dart';
import '../widgets/do_not_account.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode emailFocusNode = FocusNode();

  final FocusNode passwordFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        /// App Bar Sections Starts here
        appBar: AppBar(),

        /// Body Sections Starts here
        body: GetBuilder<SignInController>(
          builder: (controller) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Log In Instruction here
                      const CommonText(
                        text: AppString.welcomeBack,
                        fontSize: 24,
                        color: Color(0xff272727),
                        top: 10,
                      ),

                      const CommonText(
                        text: AppString.signInToYourPrivaeAccount,
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

                      /// Account Password Input here
                      const CommonText(
                        text: AppString.password,
                        bottom: 8,
                        top: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      CommonTextField(
                        controller: controller.passwordController,
                        isPassword: true,
                        hintText: AppString.password,
                        validator: OtherHelper.passwordValidator,
                      ),

                      /// Forget Password Button here
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                          child: const CommonText(
                            text: AppString.forgotThePassword,
                            top: 8,
                            bottom: 24,
                            color: Color(0xff272727),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      /// Submit Button here
                      CommonButton(
                        titleText: AppString.signIn,
                        isLoading: controller.isLoading,
                        onTap: controller.signInUser,
                      ),

                      20.height,
                      CommonButton(
                        titleText: "Sign as Chef",
                        isLoading: controller.isLoading,
                        onTap: () {
                          LocalStorage.myRole = "chef";
                          Get.toNamed(AppRoutes.chefHome);
                        },
                      ),
                      20.height,

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

                      20.height,
                      Container(
                        height: 60.h,
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
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Color(0xffF2F2F2)),
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
                      24.height,
                      DoNotHaveAccount().center,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
