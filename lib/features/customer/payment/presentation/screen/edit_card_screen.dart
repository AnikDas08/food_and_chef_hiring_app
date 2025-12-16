import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
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
                    fillColor: Colors.transparent,
                    borderColor: Color(0xffF1F1F1),
                    borderRadius: 12,
                    hintText: "Card Number",
                    paddingVertical: 14,
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(8),
                      child: CommonImage(imageSrc: AppIcons.master, size: 24),
                    ),
                  ),

                  CommonText(
                    text: "Holder Name",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 12,
                  ),
                  CommonTextField(
                    fillColor: Colors.transparent,
                    borderColor: Color(0xffF1F1F1),
                    borderRadius: 12,
                    hintText: "Holder Name",
                    paddingVertical: 14,
                  ),
                  12.height,
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
                            CommonTextField(
                              fillColor: Colors.transparent,
                              borderColor: Color(0xffF1F1F1),
                              borderRadius: 12,
                              hintText: "Expiry Date",
                              paddingVertical: 14,
                            ),
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
                            CommonTextField(
                              fillColor: Colors.transparent,
                              borderColor: Color(0xffF1F1F1),
                              borderRadius: 12,
                              hintText: "CVC",
                              paddingVertical: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: controller.isBilling,
                        onChanged: controller.changeBilling,
                        checkColor: Colors.white,
                        activeColor: Color(0xffFD713F),
                      ),

                      Expanded(
                        child: CommonText(
                          text: "Use Current Billing Address",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff272727),
                          textAlign: TextAlign.start,
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
        SafeArea(
          child: CommonButton(
            titleText: AppString.saveChanges,
            buttonHeight: 48,
            buttonRadius: 30,
            titleSize: 14,
            titleWeight: FontWeight.w600,
            titleColor: Color(0xff272727),
            buttonColor: Colors.white,
            borderColor: Color(0xffF1F1F1),
            onTap: Get.back,
          ),
        ),
      ],
    );
  }
}
