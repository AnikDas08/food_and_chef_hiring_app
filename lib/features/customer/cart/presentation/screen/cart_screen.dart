import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/other_widgets/app_bar_opacity.dart';
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
          // CRITICAL: This allows the cart items to scroll behind the AppBar
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            //automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: appBarOpacity(),
            actions: [LiquidGlassLayer(
              child: LiquidGlass(
                shape: const LiquidRoundedSuperellipse(borderRadius: 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ],

            title: const CommonText(
              text: AppString.cart,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),
          ),

          body:
              controller.isLoadingCart
                  ? const Center(child: CupertinoActivityIndicator())
                  : controller.cartResponse == null
                  ? const SizedBox.shrink()
                  : controller.chefGroups.isEmpty
                  ? _buildEmptyState()
                  : _buildCartContent(controller, context),

          // ── Bottom Checkout Button ───────────────────────────────────────
          bottomNavigationBar:
              controller.chefGroups.isEmpty
                  ? null
                  : Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: SafeArea(
                      child: CommonButton(
                        titleText:
                            "Continue for \$${controller.priceBreakdown?.subtotal?.toStringAsFixed(2) ?? '0.00'}/hr",
                        onTap: () => Get.toNamed(AppRoutes.checkout),
                      ),
                    ),
                  ),
        );
      },
    );
  }

  // ── Helper: Empty State UI ──────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64.r,
            color: const Color(0xffC0C0C0),
          ),
          16.height,
          CommonText(
            text: 'Your cart is empty',
            fontSize: 14.sp,
            color: const Color(0xff777777),
          ),
        ],
      ),
    );
  }

  // ── Helper: Main Cart Content ────────────────────────────────────────────
  Widget _buildCartContent(CartController controller, BuildContext context) {
    return ListView(
      // Top padding (110.h) ensures content starts visually below the AppBar
      padding: EdgeInsets.fromLTRB(16.w, 110.h, 16.w, 120.h),
      physics: const BouncingScrollPhysics(), // Better feel for glass scrolling
      children: [
        const SizedBox(height: 12),
        ...controller.chefGroups.map((group) {
          final menus = group.menus ?? [];
          final chefId = group.chef?.id ?? '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              chefInfo(group.chef),
              ...menus.map((item) => cartItem(context, item, chefId)),
              16.height,
            ],
          );
        }),

        CommonText(
          text: AppString.notesToPrivaeChef,
          fontWeight: FontWeight.w600,
          color: const Color(0xff272727),
          textAlign: TextAlign.start,
          top: 8.h,
          bottom: 8.h,
        ),
        CommonTextField(hintText: AppString.notesToPrivaeChefHint),

        24.height,
        _buildPriceSection(controller),
      ],
    );
  }

  // ── Helper: Price Section ────────────────────────────────────────────────
  Widget _buildPriceSection(CartController controller) {
    final double subtotal = controller.priceBreakdown?.subtotal ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: 'Subtotals',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
            CommonText(
              text: '\$${subtotal.toStringAsFixed(2)}',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
          ],
        ),*/
        if (controller.estimatedTime != null) ...[
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                text: 'Estimated cooking time',
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonText(
                text: '${controller.estimatedTime} hours',
                fontWeight: FontWeight.w600,
                color: const Color(0xff272727),
              ),
            ],
          ),
        ],
        SizedBox(height: 4.h,),
        const Text(
          'For scheduling only: Billing reflects time worked.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontFamily: 'SF Pro',
            fontSize: 14,
            color: Color(0xff777777),
              letterSpacing: 0,
            fontWeight: FontWeight.w400
          ),
        )
      ],
    );
  }
}
