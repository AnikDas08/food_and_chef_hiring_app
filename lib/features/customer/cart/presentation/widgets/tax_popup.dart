import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/cart_controller.dart';
import '../controller/text_controller.dart';

taxPopup() {
  if (!Get.isRegistered<TaxController>()) Get.put(TaxController());
  Get.find<TaxController>().fetchTaxDetails();
  final CartController cartController = Get.find<CartController>();

  showDialog(
    context: Get.context!,
    builder: (context) {
      return AnimationPopUp(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          ),
          builder: (context, child) {
            return FadeTransition(
              opacity: ModalRoute.of(context)!.animation!,
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GetBuilder<TaxController>(
                    builder: (taxController) {
                      if (taxController.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final hasBusiness = taxController.businessTax != null;
                      final hasPersonal = taxController.personalTax != null;

                      return GetBuilder<CartController>(
                        builder: (cartCtrl) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Header ─────────────────────────────────
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CommonText(
                                      text: AppString.pleaseSelectTheTaxDetailsYouWantToUse,
                                      fontSize: 16,
                                      top: 16,
                                      bottom: 8,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff272727),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => AnimationPopUpState.closeDialog(),
                                    child: Icon(
                                      Icons.close,
                                      color: Color(0xffABABAB),
                                      size: 24.sp,
                                    ),
                                  ),
                                ],
                              ),

                              // ── Business Tax Row ────────────────────────
                              GestureDetector(
                                onTap: hasBusiness
                                    ? () {
                                  cartController.onTaxSelected(
                                      taxController.businessTax!.id);
                                  AnimationPopUpState.closeDialog();
                                }
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 15.sp,
                                      width: 15.sp,
                                      decoration: BoxDecoration(
                                        color: cartCtrl.selectedTaxId ==
                                            taxController.businessTax?.id
                                            ? Colors.black
                                            : hasBusiness
                                            ? Colors.black
                                            : Color(0xffF2F2F2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: (hasBusiness)
                                          ? Icon(Icons.check,
                                          color: Colors.white, size: 12.sp)
                                          : null,
                                    ),
                                    12.width,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CommonText(
                                            text: "Business tax profile",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff272727),
                                          ),
                                          CommonText(
                                            text: hasBusiness
                                                ? "${taxController.businessTax!.name} (${taxController.businessTax!.city})"
                                                : "Add tax details",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff777777),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        AnimationPopUpState.closeDialog();
                                        if (hasBusiness) {
                                          taxController.loadForEdit(
                                              taxController.businessTax!);
                                        } else {
                                          taxController.clearForm();
                                        }
                                        Get.toNamed(
                                          AppRoutes.businessTaxDetails,
                                          arguments: {
                                            'isEdit': hasBusiness,
                                            'tax': hasBusiness
                                                ? taxController.businessTax
                                                : null,
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Color(0xffF2F2F2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: CommonText(
                                            text: hasBusiness ? "Edit" : "Add"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              30.height,

                              // ── Personal Tax Row ────────────────────────
                              GestureDetector(
                                onTap: hasPersonal
                                    ? () {
                                  cartController.onTaxSelected(
                                      taxController.personalTax!.id);
                                  AnimationPopUpState.closeDialog();
                                }
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 15.sp,
                                      width: 15.sp,
                                      decoration: BoxDecoration(
                                        color: cartCtrl.selectedTaxId ==
                                            taxController.personalTax?.id
                                            ? Colors.black
                                            : Color(0xffF2F2F2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: cartCtrl.selectedTaxId ==
                                          taxController.personalTax?.id
                                          ? Icon(Icons.check,
                                          color: Colors.white, size: 12.sp)
                                          : null,
                                    ),
                                    12.width,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CommonText(
                                            text: "Personal tax profile",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff272727),
                                          ),
                                          CommonText(
                                            text: hasPersonal
                                                ? "${taxController.personalTax!.name} (${taxController.personalTax!.city})"
                                                : "Add tax details",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff777777),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        AnimationPopUpState.closeDialog();
                                        if (hasPersonal) {
                                          taxController.loadForEdit(
                                              taxController.personalTax!);
                                        } else {
                                          taxController.clearForm();
                                        }
                                        Get.toNamed(
                                          AppRoutes.personalTaxDetails,
                                          arguments: {
                                            'isEdit': hasPersonal,
                                            'tax': hasPersonal
                                                ? taxController.personalTax
                                                : null,
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Color(0xffF2F2F2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: CommonText(
                                            text: hasPersonal ? "Edit" : "Add"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              16.height,
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}