import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/profile/presentation/screen/kitchen/customize_kitchen_screen.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../controller/kitchen_equipment_controller.dart';


class KitchenEquipmentScreen extends StatelessWidget {
  const KitchenEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KitchenEquipmentController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ── Hero kitchen image ──
          _KitchenHeroImage(),

          // ── Scrollable body ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                SizedBox(height: 20.h),

                // Title
                CommonText(
                  text: 'Your Kitchen Equipment',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 14.h),

                // ── Ready for cooking card ──
                _ReadyForCookingCard(controller: controller),
                SizedBox(height: 20.h),

                // ── Kitchen type label ──
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Which kitchen best describes yours? ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                // ── Kitchen type cards ──
                ...List.generate(controller.kitchenTypes.length, (index) {
                  final item = controller.kitchenTypes[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _KitchenTypeCard(
                      controller: controller,
                      index: index,
                      emoji: item['emoji'],
                      title: item['title'],
                      subtitle: item['subtitle'],
                    ),
                  );
                }),

                SizedBox(height: 10.h),

                // ── Collapsible sections ──
                _CollapsibleSection(
                  label: 'Cooking Appliances',
                  isRequired: true,
                  isExpandedFn: () => controller.appliancesExpanded.value,
                  onToggle: controller.toggleAppliances,
                  items: controller.appliances,
                  isCheckedFn: (i) => controller.appliancesSelected[i],
                  onItemTap: controller.toggleAppliance,
                ),

                _CollapsibleSection(
                  label: 'Pans & Pots',
                  isRequired: true,
                  isExpandedFn: () => controller.pansPotsExpanded.value,
                  onToggle: controller.togglePansPots,
                  items: controller.pansPots,
                  isCheckedFn: (i) => controller.pansPotsSelected[i],
                  onItemTap: controller.togglePanPot,
                ),

                _CollapsibleSection(
                  label: 'Tools',
                  isRequired: true,
                  isExpandedFn: () => controller.toolsExpanded.value,
                  onToggle: controller.toggleTools,
                  items: controller.tools,
                  isCheckedFn: (i) => controller.toolsSelected[i],
                  onItemTap: controller.toggleTool,
                ),

                _CollapsibleSection(
                  label: 'Special Equipment',
                  isRequired: true,
                  isExpandedFn: () => controller.specialEquipmentExpanded.value,
                  onToggle: controller.toggleSpecialEquipment,
                  items: controller.specialEquipment,
                  isCheckedFn: (i) => controller.specialEquipmentSelected[i],
                  onItemTap: controller.toggleSpecialEquipments,
                ),

                SizedBox(height: 100.h), // space for sticky button
              ],
            ),
          ),
        ],
      ),

      // ── Sticky bottom button ──
      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        child: CommonButton(
          titleText: 'Customize Your Kitchen',
          buttonColor: AppColors.black,
          titleColor: AppColors.white,
          onTap: () {
            Get.to(()=>CustomizeKitchenScreen());
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Hero kitchen image with back button
// ─────────────────────────────────────────────────────
class _KitchenHeroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2C),
            image: DecorationImage(
              image: AssetImage('assets/images/profile_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // dark gradient overlay
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
        ),
        // back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 16.w,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Ready for Cooking progress card
// ─────────────────────────────────────────────────────
class _ReadyForCookingCard extends StatelessWidget {
  final KitchenEquipmentController controller;

  const _ReadyForCookingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final percent = controller.matchPercent;
      final percentInt = (percent * 100).round();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFFE0B2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: 'You\'re Ready for Cooking',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE65100),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8.h),
            // Progress bar
            Stack(
              children: [
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  height: 6.h,
                  width: (MediaQuery.of(context).size.width - 68.w) * percent,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6D00),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Your kitchen can handle ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  TextSpan(
                    text: '$percentInt%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF6D00),
                    ),
                  ),
                  TextSpan(
                    text: ' of recipes on the platform',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Kitchen Type Card
// ─────────────────────────────────────────────────────
class _KitchenTypeCard extends StatelessWidget {
  final KitchenEquipmentController controller;
  final int index;
  final String emoji;
  final String title;
  final String subtitle;

  const _KitchenTypeCard({
    required this.controller,
    required this.index,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedKitchenType.value == index;
      return GestureDetector(
        onTap: () => controller.selectKitchenType(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: title,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.black,
                      textAlign: TextAlign.start,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      CommonText(
                        text: subtitle,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFFCCCCCC)
                            : const Color(0xFF888888),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Collapsible Section (Appliances / Pans / Tools / Special)
// ─────────────────────────────────────────────────────
class _CollapsibleSection extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool Function() isExpandedFn;
  final VoidCallback onToggle;
  final List<String> items;
  final bool Function(int) isCheckedFn;
  final void Function(int) onItemTap;

  const _CollapsibleSection({
    required this.label,
    required this.isRequired,
    required this.isExpandedFn,
    required this.onToggle,
    required this.items,
    required this.isCheckedFn,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool expanded = isExpandedFn();
      return Column(
        children: [
          // ── Section header ──
          GestureDetector(
            onTap: onToggle,
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
                          text: label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        if (isRequired)
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
            ),
          ),

          // ── Animated expand/collapse ──
          AnimatedCrossFade(
            firstChild: Column(
              children: List.generate(items.length, (index) {
                return Column(
                  children: [
                    _CheckboxRow(
                      label: items[index],
                      isCheckedFn: () => isCheckedFn(index),
                      onTap: () => onItemTap(index),
                    ),
                    if (index < items.length - 1)
                      Divider(height: 1, color: const Color(0xFFF0F0F0)),
                  ],
                );
              }),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),

          Divider(height: 1, color: const Color(0xFFEEEEEE)),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Checkbox Row
// ─────────────────────────────────────────────────────
class _CheckboxRow extends StatelessWidget {
  final String label;
  final bool Function() isCheckedFn;
  final VoidCallback onTap;

  const _CheckboxRow({
    required this.label,
    required this.isCheckedFn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isChecked = isCheckedFn();
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.black : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked
                        ? AppColors.black
                        : const Color(0xFFCCCCCC),
                    width: 1.5,
                  ),
                ),
                child: isChecked
                    ? Icon(
                  Icons.check_rounded,
                  size: 14.sp,
                  color: AppColors.white,
                )
                    : null,
              ),
              SizedBox(width: 14.w),
              CommonText(
                text: label,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      );
    });
  }
}