// lib/features/customer/cart/presentation/screens/promo_code_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';

class PromoCodeScreen extends StatelessWidget {
  PromoCodeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonText(
                text: "Promotions",
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              const CommonText(
                text: "Claim your discount by entering the promo code.",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                top: 8,
                bottom: 28,
                color: Color(0xff777777),
              ),
              CommonTextField(
                hintText: "Enter promo code",
                controller: _promoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Promo code is required';
                  }
                  /*if (value.length < 5) {
                    return 'The code is not valid';
                  }*/
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
          child: CommonButton(
            titleText: "Submit",
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // Return promo code back to caller
                Get.back(result: _promoController.text.trim());
              }
            },
          ),
        ),
      ),
    );
  }
}