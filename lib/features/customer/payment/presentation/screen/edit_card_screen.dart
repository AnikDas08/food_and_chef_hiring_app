import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/payment_method_controller.dart';

class EditCardScreen extends StatelessWidget {
  const EditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<PaymentMethodController>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Edit a Card",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 28,
                    top: 12,
                  ),

                  CommonText(
                    text: "Card Number",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(
                    hintText: "Card Number",
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(8),
                      child: CommonImage(imageSrc: AppIcons.master, size: 24),
                    ),
                  ),

                  CommonText(
                    text: "Cardholder Name",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(hintText: "Cardholder Name"),
                  16.height,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Expiry Date",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                              bottom: 8,
                            ),
                            CommonTextField(hintText: "Expiry Date"),
                          ],
                        ),
                      ),
                      16.width,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "CVC",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                              bottom: 8,
                            ),
                            CommonTextField(hintText: "CVC"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      persistentFooterButtons: [
        SafeArea(child: CommonButton(titleText: "Edit Card", onTap: Get.back)),
      ],
    );
  }
}
