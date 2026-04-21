import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../address/data/address_model.dart';
import '../controller/cart_controller.dart';
import '../controller/text_controller.dart';
import '../widgets/booking_date_time_pop_up.dart';
import '../widgets/confirm_checking_popup.dart';
import '../widgets/tax_popup.dart';
import '../../data/cart_model.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: CommonText(
          text: AppString.checkout,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xff272727),
        ),
        flexibleSpace: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 0),
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
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              top: 110.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Booking Details ────────────────────────────────────
                CommonText(
                  text: AppString.bookingDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                  bottom: 8,
                ),
                CommonTextField(
                  controller: controller.dateController,
                  keyboardType: TextInputType.none,
                  borderRadius: 20,
                  fontSize: 12,
                  hintTextSize: 12,
                  hintText: "1 January 2026, 5:20PM",
                  onTap:
                      () => bookingDateTimePopup(
                        id:
                            controller.chefGroups.isNotEmpty
                                ? controller.chefGroups.first.chef?.id
                                : null,
                      ),
                  suffixIcon: InkWell(
                    onTap:
                        () => bookingDateTimePopup(
                          id:
                              controller.chefGroups.isNotEmpty
                                  ? controller.chefGroups.first.chef?.id
                                  : null,
                        ),
                    child: const Icon(
                      CupertinoIcons.calendar,
                      color: Color(0xffFD713F),
                    ),
                  ),
                ),

                20.height,

                // ── Address ────────────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    final result = await Get.toNamed(
                      AppRoutes.addressScreen,
                      arguments: {
                        'fromCheckout': true,
                        'selectedAddressId': controller.selectedAddress?.id,
                      },
                    );
                    if (result != null && result is AddressModel) {
                      controller.onAddressSelected(result);
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(minHeight: 60.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CommonImage(
                          imageSrc: AppIcons.mapIcon,
                          imageColor: const Color(0xffFD713F),
                          size: 24,
                        ),
                        8.width,
                        Expanded(
                          child:
                              controller.selectedAddress != null
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CommonText(
                                        text:
                                            controller
                                                    .selectedAddress!
                                                    .ownerName
                                                    .isNotEmpty
                                                ? controller
                                                    .selectedAddress!
                                                    .ownerName
                                                : controller
                                                    .selectedAddress!
                                                    .label,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff272727),
                                      ),
                                      CommonText(
                                        text:
                                            controller
                                                .selectedAddress!
                                                .detailsAddress,
                                        fontSize: 12,
                                        top: 2,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff777777),
                                      ),
                                    ],
                                  )
                                  : CommonText(
                                    text: "Select delivery address",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff777777),
                                  ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xff777777),
                        ),
                      ],
                    ),
                  ),
                ),

                40.height,

                // ── Chef Groups with Items ─────────────────────────────
                ...controller.chefGroups.map((group) {
                  final menus = group.menus ?? [];
                  final chef = group.chef;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chef Info Row
                      _buildChefInfo(chef),

                      16.height,

                      // Expandable toggle row
                      InkWell(
                        onTap: controller.onChangeExpanded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text:
                                  "${menus.length} Item${menus.length != 1 ? 's' : ''}",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff777777),
                            ),
                            Icon(
                              controller.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down_outlined,
                              size: 24,
                              color: const Color(0xff777777),
                            ),
                          ],
                        ),
                      ),

                      // Expanded item list
                      if (controller.isExpanded) ...[
                        16.height,
                        ...menus.map((item) => _buildOrderItem(item)),
                      ],

                      20.height,
                    ],
                  );
                }),

                // ── Order Summary ──────────────────────────────────────
                _buildOrderSummary(controller),

                42.height,

                // ── Promo Code ─────────────────────────────────────────
                InkWell(
                  onTap: () async {
                    final result = await Get.toNamed(AppRoutes.promoCode);
                    if (result != null && result is String) {
                      controller.onPromoCodeApplied(result);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: "Add promo code",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff272727),
                          ),
                          if (controller.promoCode != null)
                            CommonText(
                              text: controller.promoCode!,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffFD713F),
                              top: 2,
                            ),
                        ],
                      ),
                      controller.promoCode != null
                          ? InkWell(
                            onTap: () => controller.onPromoCodeApplied(''),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xffE53935),
                            ),
                          )
                          : const Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 16,
                            color: Color(0xff777777),
                          ),
                    ],
                  ),
                ),

                24.height,

                // ── Tax / Invoice ──────────────────────────────────────
                _buildTaxSection(controller),

                // ── Terms ──────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Terms: ",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff222222),
                      top: 36,
                    ),
                    CommonText(
                      text: "All prices excl. VAT. For your order the",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff636363),
                      top: 36,
                    ),
                  ],
                ),
                CommonText(
                  text: "Privae Chef Terms & Conditions apply",
                  fontSize: 14,
                  left: 2,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffFD713F),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: SafeArea(
          child: GetBuilder<CartController>(
            builder:
                (controller) => CommonButton(
                  titleText:
                      controller.isCheckingOut
                          ? "Placing Order..."
                          : AppString.checkoutNow,
                  onTap:
                      controller.isCheckingOut ? () {} : confirmCheckingPopup,
                ),
          ),
        ),
      ),
    );
  }

  // ── Tax / Invoice Section ──────────────────────────────────────────────────
  Widget _buildTaxSection(CartController controller) {
    final TaxController? taxCtrl =
        Get.isRegistered<TaxController>() ? Get.find<TaxController>() : null;

    String taxLabel = "Add tax details";
    if (controller.selectedTaxId != null && taxCtrl != null) {
      if (taxCtrl.businessTax?.id == controller.selectedTaxId) {
        taxLabel = taxCtrl.businessTax!.name;
      } else if (taxCtrl.personalTax?.id == controller.selectedTaxId) {
        taxLabel = taxCtrl.personalTax!.name;
      }
    }

    return InkWell(
      onTap: taxPopup,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 15.sp,
            width: 15.sp,
            decoration: BoxDecoration(
              color:
                  controller.selectedTaxId != null
                      ? Colors.black
                      : const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                controller.selectedTaxId != null
                    ? Icon(Icons.check, color: Colors.white, size: 10.sp)
                    : null,
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: "Request an invoice",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff272727),
                ),
                CommonText(
                  text: taxLabel,
                  fontSize: 12,
                  top: 4,
                  fontWeight: FontWeight.w500,
                  color:
                      controller.selectedTaxId != null
                          ? const Color(0xffFD713F)
                          : const Color(0xff818181),
                ),
              ],
            ),
          ),
          controller.selectedTaxId != null
              ? InkWell(
                onTap: () => controller.onTaxSelected(null),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Color(0xffE53935),
                ),
              )
              : const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 16,
                color: Color(0xff777777),
              ),
        ],
      ),
    );
  }

  // ── Chef Info Widget ───────────────────────────────────────────────────────
  Widget _buildChefInfo(CartChefInfo? chef) {
    final String imageUrl =
        (chef?.image != null && chef!.image!.isNotEmpty)
            ? (chef.image!.startsWith('http')
                ? chef.image!
                : ApiEndPoint.imageUrl + chef.image!)
            : AppImages.image3;

    return Row(
      children: [
        CommonImage(
          imageSrc: imageUrl,
          size: 44,
          borderRadius: 50,
          fill: BoxFit.cover,
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: chef?.name ?? 'Chef',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xff272727),
              ),
              CommonText(
                text:
                    chef?.pricing != null
                        ? "\$${chef!.pricing!.toStringAsFixed(0)} per hour"
                        : '',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xff777777),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Single Order Item Row ──────────────────────────────────────────────────
  Widget _buildOrderItem(CartMenuItem item) {
    final menuDetail =
        item.menu != null && item.menu!.isNotEmpty ? item.menu!.first : null;
    final String name = menuDetail?.name ?? 'Item';
    final String customizations =
        item.customizations != null && item.customizations!.isNotEmpty
            ? "${item.quantity ?? 1} Items + ${item.customizations!.join(', ')}"
            : "${item.quantity ?? 1} Items";
    final double price = item.totalPrice ?? 0;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: name,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                  bottom: 10,
                ),
                CommonText(
                  text: customizations,
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  color: const Color(0xff777777),
                ),
              ],
            ),
          ),
          /*8.width,
          CommonText(
            text: "\$${price.toStringAsFixed(2)}",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff272727),
          ),*/
        ],
      ),
    );
  }

  // ── Order Summary (Price Breakdown) ───────────────────────────────────────
  Widget _buildOrderSummary(CartController controller) {
    double subtotal = 0;
    double priceSubtotal = 0;
    for (final group in controller.chefGroups) {
      final double chefPrice = group.chef?.pricing ?? 0;
      final int totalQty = (group.menus ?? []).fold(
        0,
        (sum, m) => sum + (m.quantity ?? 1),
      );
      subtotal += chefPrice * totalQty;
      priceSubtotal += chefPrice;
    }
    final double tax = controller.priceBreakdown?.tax ?? 0;
    final double fee = controller.priceBreakdown?.fee ?? 0;
    final double total = controller.priceBreakdown?.total ?? 0;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: "Order Summary",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff272727),
            bottom: 12,
          ),
          _summaryRow("Subtotal", priceSubtotal),
          8.height,
          _summaryRow("Fees", fee),
          8.height,
          _summaryRow("Estimated Taxes", tax),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(height: 1, color: Color(0xffE0E0E0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: "Totals",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff272727),
              ),
              CommonText(
                text: "\$${total.toStringAsFixed(2)}",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff272727),
              ),
            ],
          ),
          if (controller.estimatedTime != null) ...[
            12.height,
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: Color(0xff777777),
                ),
                6.width,
                CommonText(
                  text: "Estimated time: ${controller.estimatedTime}",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff777777),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xff777777),
        ),
        CommonText(
          text: "\$${amount.toStringAsFixed(2)}",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xff272727),
        ),
      ],
    );
  }
}
