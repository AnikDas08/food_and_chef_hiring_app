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
      appBar: AppBar(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                chefInfo(),
                ...List.generate(2, (index) => cartItem(context)),

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
                    ),
                    CommonText(
                      text: "\$58.32",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
        child: CommonButton(
          titleText: AppString.continueToCheckout,
          onTap: () => Get.toNamed(AppRoutes.checkout),
        ),
      ),
    );
  }
}
