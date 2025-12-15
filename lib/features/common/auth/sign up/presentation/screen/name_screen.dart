import 'package:flutter/material.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';

class NameScreen extends StatelessWidget {
  NameScreen({super.key});

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
            padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                  const CommonText(text: AppString.firstName, bottom: 8),
                  CommonTextField(
                    controller: controller.nameController,
                    hintText: AppString.lastName,
                    validator: OtherHelper.validator,
                  ),

                  const CommonText(text: AppString.lastName, bottom: 8, top: 16,),
                  CommonTextField(
                    hintText: AppString.lastName,
                    validator: OtherHelper.validator,
                  ),
                  38.height,

                  /// Submit Button Here
                  CommonButton(
                    titleText: AppString.continueString,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Get.toNamed(AppRoutes.dietaryPreferences);
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
