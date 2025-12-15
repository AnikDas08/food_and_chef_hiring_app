import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

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
              children: [
                chefInfo(),
                ...List.generate(2, (index) => cartItem(context)),
              ],
            ),
          );
        },
      ),
    );
  }
}
