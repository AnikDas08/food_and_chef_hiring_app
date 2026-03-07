import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/kitchen/presentation/screen/plan_pot.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../data/equipment_data.dart';
import '../controller/kitchen_setup_controller.dart';

class CookingAppliancesScreen extends StatelessWidget {
  const CookingAppliancesScreen({super.key});

  // The API category name for cooking appliances
  static const String _category = 'Cooking Appliances';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KitchenSetupController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _ProgressBar(totalSteps: 5, currentStep: 2),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios, size: 20.sp, color: AppColors.black),
                  ),
                  SizedBox(height: 24.h),
                  CommonText(
                    text: 'Cooking Appliances',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  CommonText(
                    text: 'Select the appliances available in your kitchen.',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Select all that apply ',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.black),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.red),
                      ),
                    ]),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            // ── Scrollable list ──
            Expanded(
              child: Obx(() {
                // Loading state
                if (controller.isLoadingEquipment.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.black));
                }
                // Error state
                if (controller.equipmentError.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText(
                          text: controller.equipmentError.value,
                          fontSize: 13,
                          color: const Color(0xFF888888),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: controller.fetchEquipmentList,
                          child: CommonText(
                            text: 'Tap to retry',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final items = controller.itemsFor(_category);

                if (items.isEmpty) {
                  return Center(
                    child: CommonText(
                      text: 'No appliances found.',
                      fontSize: 13,
                      color: const Color(0xFF888888),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: const Color(0xFFF0F0F0)),
                  itemBuilder: (context, index) {
                    return _EquipmentCheckRow(
                      controller: controller,
                      category: _category,
                      index: index,
                      item: items[index],
                    );
                  },
                );
              }),
            ),

            // ── Fixed footer ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
              child: Column(
                children: [
                  CommonButton(
                    titleText: 'Skip For Now',
                    buttonColor: const Color(0xFFF2F2F2),
                    titleColor: AppColors.black,
                    onTap: () => Get.to(() => const CookwareToolsScreen()),
                  ),
                  SizedBox(height: 10.h),
                  CommonButton(
                    titleText: 'Continue',
                    buttonColor: AppColors.black,
                    titleColor: AppColors.white,
                    onTap: () => Get.to(() => const CookwareToolsScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Reusable Equipment Check Row
// ─────────────────────────────────────────────────────
class _EquipmentCheckRow extends StatelessWidget {
  final KitchenSetupController controller;
  final String category;
  final int index;
  final EquipmentItemModel item;

  const _EquipmentCheckRow({
    required this.controller,
    required this.category,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Reading categoryItemsMap triggers rebuild when toggled
      final bool isChecked =
          controller.categoryItemsMap[category]?[index].isSelected ?? false;

      return GestureDetector(
        onTap: () => controller.toggleItem(category, index),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: CommonText(
                  text: item.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  textAlign: TextAlign.start,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.black : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked ? AppColors.black : const Color(0xFFCCCCCC),
                    width: 1.5,
                  ),
                ),
                child: isChecked
                    ? Icon(Icons.check_rounded, size: 14.sp, color: AppColors.white)
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  const _ProgressBar({required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4.w : 0),
            height: 3.h,
            decoration: BoxDecoration(
              color: index < currentStep ? AppColors.black : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}