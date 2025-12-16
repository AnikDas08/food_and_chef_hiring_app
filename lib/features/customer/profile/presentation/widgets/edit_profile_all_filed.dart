import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/other_widgets/item.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_phone_number_text_filed.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../config/route/app_routes.dart';
import '../controller/profile_controller.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../../../../../utils/log/app_log.dart';

class EditProfileAllFiled extends StatelessWidget {
  const EditProfileAllFiled({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// User Full Name here
        const CommonText(
          text: AppString.fullName,
          fontWeight: FontWeight.w600,
          bottom: 14,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.nameController,
          validator: OtherHelper.validator,
          hintText: AppString.fullName,
          keyboardType: TextInputType.text,
          borderColor: Color(0xffF1F1F1),
          fillColor: Colors.transparent,
          paddingVertical: 14,
          borderRadius: 12,
        ),

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
          borderColor: Color(0xffF1F1F1),
          fillColor: Colors.transparent,
          paddingVertical: 14,
          borderRadius: 12,
        ),

        /// User Phone number here
        const CommonText(
          text: AppString.phoneNumber,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.phoneNumber,
          keyboardType: TextInputType.text,
          borderColor: Color(0xffF1F1F1),
          fillColor: Colors.transparent,
          paddingVertical: 14,
          borderRadius: 12,
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xffF1F1F1)),
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

        Item(
          icon: CupertinoIcons.delete_simple,
          title: AppString.deleteAccount,
          disableDivider: true,
          onTap:
              () => deletePopUp(
                controller: TextEditingController(),
                onTap: () {},
              ),
        ),
      ],
    );
  }
}
