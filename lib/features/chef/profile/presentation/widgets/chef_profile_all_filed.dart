import 'package:flutter/material.dart';
import 'package:new_untitled/component/button/switch_button.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/text/common_text.dart';
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
          borderRadius: 12,
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
          borderRadius: 12,
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
          borderRadius: 12,
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
          hintText: AppString.about,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          borderRadius: 12,
        ),

        CommonText(
          text: AppString.price.toUpperCase(),
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: Color(0xff777777),
          top: 28,
          bottom: 12,
        ),

        const CommonText(
          text: AppString.setAmount,
          fontWeight: FontWeight.w600,
          bottom: 8,
        ),
        CommonTextField(
          validator: OtherHelper.validator,
          hintText: AppString.setAmount,
          keyboardType: TextInputType.number,
          borderRadius: 12,
        ),

        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonText(
                      text:
                          "Offer discounted rate during specific hours on weekdays",
                      maxLines: 3,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      textAlign: TextAlign.start,
                    ),
                  ),

                  switchButton(
                    value: controller.isNotification,
                    onTap: controller.notification,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextField(
                      fillColor: Colors.white,
                      prefixText: "From: ",
                      hintText: "From",
                      controller: controller.fromController,
                      paddingHorizontal: 4,
                      paddingVertical: 14,
                      fontSize: 12,
                      keyboardType: TextInputType.none,
                      borderRadius: 12,
                      onTap:
                          () => OtherHelper.openTimePickerDialog(
                            controller.fromController,
                          ),
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: CommonTextField(
                      fillColor: Colors.white,
                      prefixText: "To: ",
                      hintText: "To",
                      paddingHorizontal: 10,
                      fontSize: 12,
                      paddingVertical: 14,
                      keyboardType: TextInputType.none,
                      controller: controller.toController,
                      borderRadius: 12,
                      onTap:
                          () => OtherHelper.openTimePickerDialog(
                            controller.toController,
                          ),
                    ),
                  ),
                ],
              ),
              16.height,
              CommonTextField(
                prefixText: "\$  ",
                keyboardType: TextInputType.number,
                fillColor: Colors.white,
                borderRadius: 12,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: CommonText(
                    text: "/hr",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff777777),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonText(
                      text: "Ask for higher rate on weekends",
                      maxLines: 3,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      textAlign: TextAlign.start,
                    ),
                  ),

                  switchButton(
                    value: controller.isNotification,
                    onTap: controller.notification,
                  ),
                ],
              ),

              10.height,
              CommonTextField(
                prefixText: "\$  ",
                keyboardType: TextInputType.number,
                fillColor: Colors.white,
                borderRadius: 12,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: CommonText(
                    text: "/hr",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff777777),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
