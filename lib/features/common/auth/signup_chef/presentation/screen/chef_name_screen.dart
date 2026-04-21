import 'package:flutter/material.dart';
import 'package:new_untitled/features/common/auth/signup_chef/presentation/controller/sign_up_chef_controller.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../Widget/ChefDocFlowState.dart';

class ChefNameScreen extends StatelessWidget {
  ChefNameScreen({super.key});

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
      body: GetBuilder<SignUpChefController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.tellUsYourFullName,
                    fontSize: 24,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                    top: 10,
                  ),

                  const CommonText(
                    text: AppString.byTellingUsYourFullName,
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
                    text: AppString.firstName,
                    bottom: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.firstNameController,
                    hintText: AppString.firstName,
                    validator: OtherHelper.validator,
                  ),

                  const CommonText(
                    text: AppString.lastName,
                    bottom: 8,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    controller: controller.lastNameController,
                    hintText: AppString.lastName,
                    validator: OtherHelper.validator,
                  ),
                  38.height,

                  /// Submit Button Here
                  CommonButton(
                    titleText: AppString.continueString,
                    isLoading: controller.isLoading,
                    onTap: () {
                      controller.chefSignUp();
                      if (_formKey.currentState!.validate()) {
                        Get.to(() => const ChefDocFlow());
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
