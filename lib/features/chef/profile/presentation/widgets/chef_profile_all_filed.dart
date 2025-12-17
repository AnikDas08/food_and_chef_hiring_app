import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_phone_number_text_filed.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../controller/chef_profile_controller.dart';

class ChefProfileAllFiled extends StatelessWidget {
  const ChefProfileAllFiled({super.key, required this.controller});

  final ChefProfileController controller;

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
        ),

        const CommonText(
          text: AppString.geographical,
          fontWeight: FontWeight.w600,
          top: 20,
        ),
        const CommonText(
          text: "Accept orders within 10km of",
          fontWeight: FontWeight.w600,
          fontSize: 12,
          bottom: 8,
          top: 8,
          color: Color(0xff777777),
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.geographical,
        ),

        /// User Phone number here
        const CommonText(
          text: AppString.experience,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.experience,
          keyboardType: TextInputType.number,
        ),

        const CommonText(
          text: AppString.expertiseInCooking,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.expertiseInCooking,
          keyboardType: TextInputType.number,
          suffixIcon: PopUpMenu(
            items: controller.expertiseInCooking,
            selectedItem: [controller.selectExpertiseController.text],
            onTap: controller.onTap,
          ),
        ),

        const CommonText(
          text: AppString.about,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.experience,
          keyboardType: TextInputType.text,
        ),

        const CommonText(
          text: AppString.experience,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.experience,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
