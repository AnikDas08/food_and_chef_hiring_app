import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            automaticallyImplyLeading: false, // আমরা custom leading দিচ্ছি
            centerTitle: false,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: const Color(0xff272727), // আপনার title color এর সাথে মিলিয়ে
                size: 24.r,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: CommonText(
              text: AppString.cart,
              fontSize: 24.sp, // Scaled title
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
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64.r, // Scaled Icon
                  color: const Color(0xffC0C0C0),
                ),
                16.height,
                CommonText(
                  text: "Your cart is empty",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff777777),
                ),
              ],
            ),
          )
          // ── Cart content ────────────────────────────────────────
              : ListView(
            // Bottom padding 120.h ensures list content clears the floating checkout button
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 120.h),
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
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff272727),
                textAlign: TextAlign.start,
                top: 8.h,
                bottom: 8.h,
              ),
              CommonTextField(
                hintText: AppString.notesToPrivaeChef,
              ),

              24.height,

              // ── Price breakdown ─────────────────────────────────
              _buildPriceSection(controller),
            ],
          ),

          // ── Continue to checkout button ───────────────────────────────────
          bottomNavigationBar: controller.chefGroups.isEmpty
              ? null
              : Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, bottom: 16.h),
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

  // Extracted Price Section for cleaner code and responsiveness
  Widget _buildPriceSection(CartController controller) {
    // calculation logic remains the same
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _priceRow("Subtotal", subtotal),
        8.height,
        _priceRow("Tax", tax),
        8.height,
        _priceRow("Service Fee", fee),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: const Divider(height: 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: "Subtotals",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
            CommonText(
              text: "\$${total.toStringAsFixed(2)}",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
          ],
        ),

        // Estimated time section - Fixed responsiveness
        if (controller.estimatedTime != null) ...[
          12.height,
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16.r, // Scaled Icon size
                  color: const Color(0xff777777),
                ),
                8.width,
                // Flexible ensures the text wraps if the screen is too narrow
                Flexible(
                  child: CommonText(
                    text: "Estimated time: ${controller.estimatedTime}",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _priceRow(String label, double? amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 14.sp,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: const Color(0xff272727),
        ),
        CommonText(
          text: "\$${(amount ?? 0).toStringAsFixed(2)}",
          fontSize: 12.sp,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: const Color(0xff555555),
        ),
      ],
    );
  }
}