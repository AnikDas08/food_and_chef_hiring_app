import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../controller/cart_controller.dart';

class BusinessTaxDetailsScreen extends StatelessWidget {
  const BusinessTaxDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<CartController>(
        builder:
            (controller) => SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.businessTaxDetails,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),

                  CommonText(
                    text: AppString.name,
                    fontSize: 14,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(hintText: "Privae LLC"),

                  CommonText(
                    text: AppString.streetAddress,
                    fontSize: 14,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(hintText: AppString.streetAddress),

                  CommonText(
                    text: AppString.city,
                    fontSize: 14,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(hintText: AppString.city),

                  CommonText(
                    text: AppString.postalCode,
                    fontSize: 14,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(hintText: AppString.postalCode),

                  CommonText(
                    text: AppString.taxId,
                    fontSize: 14,
                    top: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(hintText: AppString.taxId),

                  18.height,
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: controller.isDefaultAddress,
                          activeColor: Color(0xffFD713F),
                          checkColor: Colors.white,

                          onChanged: controller.onChangeDefaultAddress,
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
        child: CommonButton(
          titleText: AppString.saveAndChanges,
          onTap: Get.back,
        ),
      ),
    );
  }
}
