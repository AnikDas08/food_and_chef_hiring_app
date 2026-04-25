import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/cart_controller.dart';
import '../controller/text_controller.dart';

void taxPopup() {
  if (!Get.isRegistered<TaxController>()) Get.put(TaxController());
  final TaxController taxController = Get.find<TaxController>();
  final CartController cartController = Get.find<CartController>();

  // Set loading = true BEFORE opening dialog so it never flashes empty content
  taxController.isLoading = true;
  taxController.update();
  taxController.fetchTaxDetails();

  showDialog(
    context: Get.context!,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: const Color(0xffFFFFFF),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<TaxController>(
            builder: (taxCtrl) {
              if (taxCtrl.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final hasBusiness = taxCtrl.businessTax != null;
              final hasPersonal = taxCtrl.personalTax != null;

              return GetBuilder<CartController>(
                builder: (cartCtrl) {
                  final isBusinessSelected = cartCtrl.selectedTaxId != null &&
                      cartCtrl.selectedTaxId == taxCtrl.businessTax?.id;
                  final isPersonalSelected = cartCtrl.selectedTaxId != null &&
                      cartCtrl.selectedTaxId == taxCtrl.personalTax?.id;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ─────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
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
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: const Color(0xffABABAB),
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),

                      // ── Business Tax Row ────────────────────────
                      GestureDetector(
                        onTap: hasBusiness
                            ? () {
                          cartController.onTaxSelected(taxCtrl.businessTax!.id);
                          Navigator.pop(context);
                        }
                            : null,
                        child: Row(
                          children: [
                            Container(
                              height: 15.sp,
                              width: 15.sp,
                              decoration: BoxDecoration(
                                color: isBusinessSelected ? Colors.black : const Color(0xffF2F2F2),
                                shape: BoxShape.circle,
                              ),
                              child: isBusinessSelected
                                  ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                                  : null,
                            ),
                            12.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CommonText(
                                    text: 'Business tax profile',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                  CommonText(
                                    text: hasBusiness
                                        ? '${taxCtrl.businessTax!.name} (${taxCtrl.businessTax!.city})'
                                        : 'Add tax details',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (hasBusiness) {
                                  taxCtrl.loadForEdit(taxCtrl.businessTax!);
                                } else {
                                  taxCtrl.clearForm();
                                }
                                Get.toNamed(
                                  AppRoutes.businessTaxDetails,
                                  arguments: {
                                    'isEdit': hasBusiness,
                                    'tax': hasBusiness ? taxCtrl.businessTax : null,
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF2F2F2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CommonText(text: hasBusiness ? 'Edit' : 'Add'),
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
                          cartController.onTaxSelected(taxCtrl.personalTax!.id);
                          Navigator.pop(context);
                        }
                            : null,
                        child: Row(
                          children: [
                            Container(
                              height: 15.sp,
                              width: 15.sp,
                              decoration: BoxDecoration(
                                color: isPersonalSelected ? Colors.black : const Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: isPersonalSelected
                                  ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                                  : null,
                            ),
                            12.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CommonText(
                                    text: 'Personal tax profile',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                  CommonText(
                                    text: hasPersonal
                                        ? '${taxCtrl.personalTax!.name} (${taxCtrl.personalTax!.city})'
                                        : 'Add tax details',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (hasPersonal) {
                                  taxCtrl.loadForEdit(taxCtrl.personalTax!);
                                } else {
                                  taxCtrl.clearForm();
                                }
                                Get.toNamed(
                                  AppRoutes.personalTaxDetails,
                                  arguments: {
                                    'isEdit': hasPersonal,
                                    'tax': hasPersonal ? taxCtrl.personalTax : null,
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF2F2F2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CommonText(text: hasPersonal ? 'Edit' : 'Add'),
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
      );
    },
  );
}