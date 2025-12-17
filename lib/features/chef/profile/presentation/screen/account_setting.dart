import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/features/chef/profile/presentation/controller/chef_profile_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../widgets/delete_pop_up.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefProfileController>(
      builder: (controller) {
        return Scaffold(
          /// App Bar Sections Starts here
          appBar: AppBar(),

          /// Body Sections Starts here
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: controller.formKey,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: AppString.accountSettings,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      bottom: 28,
                    ),

                    CommonText(
                      text: "ACCOUNT DETAILS",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff777777),
                      bottom: 8,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          text: AppString.email,
                          fontWeight: FontWeight.w600,
                          top: 20,
                          bottom: 8,
                        ),
                        CommonTextField(
                          validator: OtherHelper.validator,
                          hintText: AppString.email,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        /// User Phone number here
                        const CommonText(
                          text: AppString.phoneNumber,
                          fontWeight: FontWeight.w600,
                          top: 20,
                          bottom: 8,
                        ),

                        CommonTextField(
                          controller: controller.nameController,
                          validator: OtherHelper.validator,
                          hintText: AppString.phoneNumber,
                          keyboardType: TextInputType.text,
                        ),

                        CommonText(
                          text: "Link Account".toUpperCase(),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff777777),
                          top: 28,
                          bottom: 8,
                        ),

                        12.height,

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xffF8F4F1),
                                shape: BoxShape.circle,
                              ),
                              child: CommonImage(imageSrc: AppIcons.google),
                            ),
                            12.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: "Google",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                  CommonText(
                                    text: "darremonarch@gmail.com",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff777777),
                                    top: 2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xffF2F2F2),
                              ),
                              child: CommonText(
                                text: "Disconnect",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                            ),
                          ],
                        ),
                        CommonText(
                          text: "ACCOUNT ACTION",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff777777),
                          top: 28,
                          bottom: 16,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.delete,
                                color: Color(0xff343330),
                              ),
                              CommonText(
                                text: AppString.deleteAccount,
                                color: Color(0xff343330),
                                fontWeight: FontWeight.w600,
                                left: 4,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    60.height,
                    CommonButton(
                      titleText: AppString.saveChanges,
                      isLoading: controller.isLoading,
                      onTap: deletePopUp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
