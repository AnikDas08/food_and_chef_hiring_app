import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/kitchen/presentation/screen/spacial_equipment_screen.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../data/equipment_data.dart';
import '../controller/kitchen_setup_controller.dart';

class CookwareToolsScreen extends StatelessWidget {
  const CookwareToolsScreen({super.key});

  static const String _categoryPots = 'Pots & Pans';
  static const String _categoryTools = 'Tools';

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
                  _ProgressBar(totalSteps: 5, currentStep: 3),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios, size: 20.sp, color: AppColors.black),
                  ),
                  SizedBox(height: 24.h),
                  CommonText(
                    text: 'Cookware & Tools',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  CommonText(
                    text: 'Select the pots, pans and tools available in your kitchen.',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // ── Scrollable list — both categories merged ──
            Expanded(
              child: Obx(() {
                if (controller.isLoadingEquipment.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.black));
                }
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

                final potsItems = controller.itemsFor(_categoryPots);
                final toolsItems = controller.itemsFor(_categoryTools);

                // Merge: [pots header, ...pots, tools header, ...tools]
                final int total = 1 + potsItems.length + 1 + toolsItems.length;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: total,
                  itemBuilder: (context, index) {
                    // Pots & Pans section header
                    if (index == 0) {
                      return _SectionHeader(
                        title: 'Pans & Pots',
                        selectedCount: () => controller.selectedCountFor(_categoryPots),
                      );
                    }

                    // Pots items
                    if (index <= potsItems.length) {
                      final i = index - 1;
                      return Column(
                        children: [
                          _EquipmentCheckRow(
                            controller: controller,
                            category: _categoryPots,
                            index: i,
                            item: potsItems[i],
                          ),
                          if (i < potsItems.length - 1)
                            Divider(height: 1, color: const Color(0xFFF0F0F0)),
                        ],
                      );
                    }

                    // Tools section header
                    if (index == potsItems.length + 1) {
                      return _SectionHeader(
                        title: 'Tools',
                        selectedCount: () => controller.selectedCountFor(_categoryTools),
                      );
                    }

                    // Tools items
                    final i = index - potsItems.length - 2;
                    return Column(
                      children: [
                        _EquipmentCheckRow(
                          controller: controller,
                          category: _categoryTools,
                          index: i,
                          item: toolsItems[i],
                        ),
                        if (i < toolsItems.length - 1)
                          Divider(height: 1, color: const Color(0xFFF0F0F0)),
                      ],
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
                    onTap: () => Get.to(() => const SpecialEquipmentScreen()),
                  ),
                  SizedBox(height: 10.h),
                  CommonButton(
                    titleText: 'Continue',
                    buttonColor: AppColors.black,
                    titleColor: AppColors.white,
                    onTap: () => Get.to(() => const SpecialEquipmentScreen()),
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
// Section Header with live selected count
// ─────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final int Function() selectedCount;

  const _SectionHeader({required this.title, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Obx(() {
        final count = selectedCount();
        return Row(
          children: [
            CommonText(
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              textAlign: TextAlign.start,
            ),
            if (count > 0) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CommonText(
                  text: '$count selected',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────
// Equipment Check Row
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