
import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Navigator.canPop(context)
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xffF6F6F6),
                      shape: BoxShape.circle,
                    ),
                    child: CommonImage(
                      imageSrc: AppIcons.backIcon,
                      size: 24,
                    ),
                  ),
                ),
              )
            : null,
      ),
      /// Body Section Starts Here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
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
                    hintText: AppString.lastName,
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
