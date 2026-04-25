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

  static const String _category = 'Cooking Appliances';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KitchenSetupController>();

    // Fetch equipment list on first load if not already loaded
    if (controller.equipmentCategories.isEmpty &&
        !controller.isLoadingEquipment.value) {
      controller.fetchEquipmentList();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: CommonText(
            text: 'Cooking Appliances',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        const _ProgressBar(totalSteps: 5, currentStep: 2),
                        SizedBox(height: 20.h),

                        SizedBox(height: 8.h),
                        const CommonText(
                          text:
                              'Select the appliances available in your kitchen.',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF888888),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (controller.isLoadingEquipment.value) {
                      return SizedBox(
                        height: 200.h,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      );
                    }
                    if (controller.equipmentError.value.isNotEmpty) {
                      return _ErrorRetry(
                        message: controller.equipmentError.value,
                        onRetry: controller.fetchEquipmentList,
                      );
                    }

                    final items = controller.itemsFor(_category);
                    if (items.isEmpty) {
                      return SizedBox(
                        height: 100.h,
                        child: const Center(
                          child: CommonText(
                            text: 'No appliances found.',
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _CollapsibleSection(
                        controller: controller,
                        category: _category,
                        title: 'Cooking Appliances',
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Column(
                children: [
                  CommonButton(
                    titleText: 'Continue',
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
// Collapsible Section with arrow + selected count badge
// ─────────────────────────────────────────────────────
class _CollapsibleSection extends StatelessWidget {
  final KitchenSetupController controller;
  final String category;
  final String title;

  const _CollapsibleSection({
    required this.controller,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool expanded = controller.isExpanded(category);
      final int count = controller.selectedCountFor(category);
      final items = controller.itemsFor(category);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header with arrow ──
          GestureDetector(
            onTap: () => controller.toggleCategoryExpanded(category),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Selected count badge when collapsed
                      if (!expanded && count > 0) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CommonText(
                            text: '$count selected',
                            fontSize: 11,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                      ],
                      AnimatedRotation(
                        turns: expanded ? 0 : 0.5,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 22.sp,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Items list ──
          AnimatedCrossFade(
            firstChild: Column(
              children: List.generate(items.length, (index) {
                return Column(
                  children: [
                    _EquipmentCheckRow(
                      controller: controller,
                      category: category,
                      index: index,
                      item: items[index],
                    ),
                    if (index < items.length - 1)
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  ],
                );
              }),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState:
                expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      );
    });
  }
}

// ─── Equipment Check Row ───
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
                  fontWeight: FontWeight.w400,
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
                    color:
                        isChecked ? AppColors.black : const Color(0xFFCCCCCC),
                    width: 1.5,
                  ),
                ),
                child:
                    isChecked
                        ? Icon(
                          Icons.check_rounded,
                          size: 14.sp,
                          color: AppColors.white,
                        )
                        : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonText(
            text: message,
            fontSize: 13,
            color: const Color(0xFF888888),
            maxLines: 3,
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onRetry,
            child: const CommonText(
              text: 'Tap to retry',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
              color:
                  index < currentStep
                      ? AppColors.black
                      : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
