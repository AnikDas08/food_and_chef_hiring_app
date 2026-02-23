import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/other_widgets/common_loader.dart';
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
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: CommonText(
              text: AppString.cart,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
          ),

          body: controller.isLoadingCart
              ? const CommonLoader()
              : controller.chefGroups.isEmpty
          // ── Empty state ─────────────────────────────────────────
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Color(0xffC0C0C0),
                ),
                16.height,
                CommonText(
                  text: "Your cart is empty",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff777777),
                ),
              ],
            ),
          )
          // ── Cart content ────────────────────────────────────────
              : ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              // Each chef group
              ...controller.chefGroups.map((group) {
                final menus = group.menus ?? [];
                final chefId = group.chef?.id ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Chef info ───────────────────────────────
                    chefInfo(group.chef),

                    // ── Cart items ──────────────────────────────
                    ...menus.map(
                          (item) => cartItem(context, item, chefId),
                    ),

                    16.height,
                  ],
                );
              }),

              // ── Notes to chef ───────────────────────────────────
              CommonText(
                text: AppString.notesToPrivaeChef,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xff272727),
                top: 8,
                bottom: 8,
              ),
              CommonTextField(
                hintText: AppString.notesToPrivaeChef,
              ),

              24.height,

              // ── Price breakdown ─────────────────────────────────
              Builder(
                builder: (_) {
                  // subtotal = chef pricing × total quantity of all items
                  double subtotal = 0;
                  for (final group in controller.chefGroups) {
                    final double chefPrice = group.chef?.pricing ?? 0;
                    final int totalQty = (group.menus ?? [])
                        .fold(0, (sum, m) => sum + (m.quantity ?? 1));
                    subtotal += chefPrice * totalQty;
                  }
                  final double tax = controller.priceBreakdown?.tax ?? 0;
                  final double fee = controller.priceBreakdown?.fee ?? 0;
                  final double total = subtotal + tax + fee;

                  return Column(
                    children: [
                      _priceRow("Subtotal", subtotal),
                      8.height,
                      _priceRow("Tax", tax),
                      8.height,
                      _priceRow("Service Fee", fee),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Total",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff272727),
                          ),
                          CommonText(
                            text: "\$${total.toStringAsFixed(2)}",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff272727),
                          ),
                        ],
                      ),

                      // Estimated time
                      if (controller.estimatedTime != null) ...[
                        12.height,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: Color(0xff777777),
                              ),
                              8.width,
                              CommonText(
                                text:
                                "Estimated time: ${controller.estimatedTime}",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),

          // ── Continue to checkout button ───────────────────────────────────
          bottomNavigationBar: controller.chefGroups.isEmpty
              ? null
              : Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 16),
            child: SafeArea(
              child: CommonButton(
                titleText: AppString.continueToCheckout,
                onTap: () => Get.toNamed(AppRoutes.checkout),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _priceRow(
      String label,
      double? amount, {
        bool isBold = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: const Color(0xff272727),
        ),
        CommonText(
          text: "\$${(amount ?? 0).toStringAsFixed(2)}",
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: const Color(0xff555555),
        ),
      ],
    );
  }
}