import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text_field/common_phone_number_text_filed.dart';
import 'package:new_untitled/utils/app_utils.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../widget/account_create_popup.dart';
import '../widget/profile_image.dart';

class ReviewDetailScreen extends StatelessWidget {
  ReviewDetailScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts Here
      appBar: AppBar(),

      /// Body Section Starts Here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.reviewYourDetailsBeforeCreatingTheAccount,
                    fontSize: 24,
                    color: Color(0xff272727),
                    top: 10,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),

                  const CommonText(
                    text:
                        AppString
                            .hereAreTheDetailsOfTheDataYouHaveFilledInPreviouslyYouCanChangeItIfItIsWrong,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    maxLines: 2,
                    top: 8,
                    textAlign: TextAlign.start,
                  ),

                  28.height,
                  profileImage(controller),

                  CommonText(
                    text: AppString.personalDetails.toUpperCase(),
                    fontSize: 12,
                    color: Color(0xff777777),
                    bottom: 12,
                    top: 28,
                  ),
                  const CommonText(
                    text: AppString.fullName,
                    bottom: 8,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                  ),
                  CommonTextField(
                    hintText: AppString.fullName,
                    paddingHorizontal: 10,
                    controller: TextEditingController(
                      text:
                          "${controller.firstNameController.text} ${controller.lastNameController.text}",
                    ),
                    validator: OtherHelper.validator,
                  ),

                  const CommonText(
                    text: AppString.email,
                    bottom: 8,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: AppString.enterYourAddress,
                    paddingHorizontal: 10,
                    controller: controller.emailController,
                    validator: OtherHelper.emailValidator,
                  ),

                  const CommonText(
                    text: AppString.phoneNumber,
                    bottom: 8,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                    top: 16,
                  ),

                  // CommonTextField(
                  //   hintText: AppString.phoneNumber,
                  //   paddingHorizontal: 10,
                  //   controller: controller.numberController,
                  //   validator: OtherHelper.validator,
                  // ),
                  CommonPhoneNumberTextFiled(
                    controller: controller.numberController,
                    countryChange: (value) {
                      controller.countryCode = value.dialCode;
                    },
                  ),
                  CommonText(
                    text: AppString.detailedAddress,
                    fontSize: 12,
                    color: Color(0xff777777),
                    bottom: 12,
                    top: 28,
                  ),
                  CommonText(
                    text: AppString.address.toUpperCase(),
                    bottom: 8,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                  ),
                  CommonTextField(
                    hintText: AppString.enterYourAddress,
                    paddingHorizontal: 10,
                    controller: controller.addressController,
                    suffixIcon: InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        controller.addressController.text = "Dhaka Bangladesh";
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImage(
                          imageSrc: AppIcons.location,
                          imageColor: Color(0xffFD713F),
                        ),
                      ),
                    ),
                    validator: OtherHelper.validator,
                  ),

                  CommonText(
                    text: AppString.allergicPreferences.toUpperCase(),
                    fontSize: 12,
                    color: Color(0xff777777),
                    bottom: 12,
                    top: 28,
                  ),
                  const CommonText(
                    text: AppString.selectedFood,
                    bottom: 8,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                  ),
                  CommonTextField(
                    hintText: AppString.selectedFood,
                    paddingHorizontal: 10,
                    controller: controller.dietaryController,
                    validator: OtherHelper.validator,
                  ),

                  /// Submit Button Here
                ],
              ),
            ),
          );
        },
      ),

      /// Bottom Section Starts Here
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 16, left: 16),
        child: SafeArea(
          child: CommonButton(
            titleText: AppString.createAccount,
            onTap: () {
              final controller = Get.find<SignUpController>();
              if (_formKey.currentState!.validate()) {
                controller.completeProfile();
              } else {
                Utils.errorSnackBar("Error", "Please, Full fill all Field");
              }
            },
          ),
        ),
      ),
    );
  }
}
