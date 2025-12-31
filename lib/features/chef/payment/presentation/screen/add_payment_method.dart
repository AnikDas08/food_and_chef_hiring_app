import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';

class AddPaymentMethod extends StatelessWidget {
  const AddPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Add payment",
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),

              CommonText(
                text: "Provide your banking details to enable payouts",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff777777),
              ),

              CommonText(
                text: "Account holder name",
                top: 28,
                bottom: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),

              CommonTextField(hintText: "Enter your account holder name"),

              CommonText(
                text: "Account number",
                top: 16,
                bottom: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonTextField(hintText: "Enter your Account number"),

              CommonText(
                text: "5-Digit transit number",
                top: 16,
                bottom: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonTextField(hintText: "Enter transit number"),

              CommonText(
                text: "Country",
                top: 16,
                bottom: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonTextField(hintText: "Enter your Country"),

              CommonText(
                text: "Currency",
                top: 16,
                bottom: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonTextField(hintText: "Enter Currency"),

              16.height,

              CommonButton(
                titleText: AppString.continues,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
