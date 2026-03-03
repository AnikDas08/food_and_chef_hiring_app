// lib/features/customer/cart/presentation/screens/personal_tax_details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/text_controller.dart';

class PersonalTaxDetailsScreen extends StatelessWidget {
  const PersonalTaxDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final bool isEdit = args?['isEdit'] == true;

    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<TaxController>(
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: AppString.personalDetails,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),

              CommonText(
                text: AppString.fullName,
                fontSize: 14,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: "Privae LLC",
                controller: controller.nameController,
              ),

              CommonText(
                text: AppString.streetAddress,
                fontSize: 14,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.streetAddress,
                controller: controller.streetController,
              ),

              CommonText(
                text: AppString.city,
                fontSize: 14,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.city,
                controller: controller.cityController,
              ),

              CommonText(
                text: AppString.postalCode,
                fontSize: 14,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.postalCode,
                controller: controller.postalController,
              ),

              CommonText(
                text: AppString.taxId,
                fontSize: 14,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.taxId,
                controller: controller.taxIdController,
              ),

              18.height,
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: controller.isDefault,
                      activeColor: Color(0xffFD713F),
                      checkColor: Colors.white,
                      onChanged: controller.onChangeDefault,
                    ),
                  ),
                  Expanded(
                    child: CommonText(
                      text: "Make Default Invoicing Address",
                      textAlign: TextAlign.start,
                      left: 8,
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: GetBuilder<TaxController>(
          builder: (controller) => CommonButton(
            titleText: controller.isSubmitting ? "Saving..." : AppString.save,
            onTap: controller.isSubmitting
                ? () {}
                : () {
              if (isEdit && args?['tax'] != null) {
                controller.updateTax(args!['tax'].id, 'personal');
              } else {
                controller.submitTax('personal');
              }
            },
          ),
        ),
      ),
    );
  }
}