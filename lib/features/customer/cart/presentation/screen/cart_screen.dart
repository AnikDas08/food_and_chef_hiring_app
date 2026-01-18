import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';
import '../controller/cart_controller.dart';
import '../widgets/cart_item.dart';
import '../widgets/chef_info.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.white.withValues(alpha: 0.1), // tint (optional)
            ),
          ),
        ),
        title: CommonText(
          text: AppString.cart,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                chefInfo(),
                ...List.generate(5, (index) => cartItem(context)),

                CommonText(
                  text: AppString.notesToPrivaeChef,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                  top: 16,
                  bottom: 8,
                ),
                CommonTextField(hintText: AppString.notesToPrivaeChef),

                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: AppString.subtotal,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: "\$58.32",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: SafeArea(
          child: CommonButton(
            titleText: AppString.continueToCheckout,
            onTap: () => Get.toNamed(AppRoutes.checkout),
          ),
        ),
      ),
    );
  }
}
