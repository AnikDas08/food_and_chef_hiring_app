// lib/features/customer/cart/presentation/screens/business_tax_details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../controller/text_controller.dart';

class BusinessTaxDetailsScreen extends StatelessWidget {
  const BusinessTaxDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final bool isEdit = args?['isEdit'] == true;

    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<TaxController>(
        builder: (controller) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonText(
                text: AppString.businessTaxDetails,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),

              const CommonText(
                text: AppString.name,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: 'Company name',
                controller: controller.nameController,
              ),

              const CommonText(
                text: AppString.streetAddress,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.streetAddress,
                controller: controller.streetController,
              ),

              const CommonText(
                text: AppString.city,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.city,
                controller: controller.cityController,
              ),

              const CommonText(
                text: AppString.postalCode,
                top: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.postalCode,
                controller: controller.postalController,
              ),

              const CommonText(
                text: AppString.taxId,
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
                      activeColor: const Color(0xffFD713F),
                      checkColor: Colors.white,
                      onChanged: controller.onChangeDefault,
                    ),
                  ),
                  const Expanded(
                    child: CommonText(
                      text: 'Make Default Invoicing Address',
                      textAlign: TextAlign.start,
                      left: 8,
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: GetBuilder<TaxController>(
          builder: (controller) => CommonButton(
            titleText: controller.isSubmitting
                ? 'Saving...'
                : AppString.saveAndChanges,
            onTap: controller.isSubmitting
                ? () {}
                : () {
              if (isEdit && args?['tax'] != null) {
                controller.updateTax(args!['tax'].id, 'business');
              } else {
                controller.submitTax('business');
              }
            },
          ),
        ),
      ),
    );
  }
}