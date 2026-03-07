import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../controller/customize_kitchen_controller.dart';

class CustomizeKitchenScreen extends StatelessWidget {
  const CustomizeKitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomizeKitchenController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // ── Hero image ──
          _KitchenHeroImage(),

          // ── Scrollable content ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      CommonText(
                        text: 'Your Kitchen Equipment',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 14.h),

                      // ── Ready for Cooking card ──
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
                    ],
                  ),
                ),

                // ── Kitchen type cards ──
                _KitchenTypeSection(controller: controller),

                // ── Divider ──
                Divider(height: 1, color: const Color(0xFFEEEEEE)),
                SizedBox(height: 4.h),

                // ── Cooking Appliances (quantity rows, expanded) ──
                _QuantitySection(
                  label: 'Cooking Appliances',
                  isRequired: true,
                  isExpandedFn: () => controller.appliancesExpanded.value,
                  onToggle: controller.toggleAppliances,
                  items: controller.appliances,
                  qtyFn: (i) => controller.appliancesQty[i],
                  onIncrement: controller.incrementAppliance,
                  onDecrement: controller.decrementAppliance,
                  selectedCountFn: () => controller.appliancesSelectedCount,
                ),

                // ── Pans & Pots (collapsed, shows arrow + count) ──
                _QuantitySection(
                  label: 'Pans & Pots',
                  isRequired: true,
                  isExpandedFn: () => controller.pansPotsExpanded.value,
                  onToggle: controller.togglePansPots,
                  items: controller.pansPots,
                  qtyFn: (i) => controller.pansPotsQty[i],
                  onIncrement: controller.incrementPanPot,
                  onDecrement: controller.decrementPanPot,
                  selectedCountFn: () => controller.pansPotsSelectedCount,
                ),

                // ── Tools ──
                _QuantitySection(
                  label: 'Tools',
                  isRequired: true,
                  isExpandedFn: () => controller.toolsExpanded.value,
                  onToggle: controller.toggleTools,
                  items: controller.tools,
                  qtyFn: (i) => controller.toolsQty[i],
                  onIncrement: controller.incrementTool,
                  onDecrement: controller.decrementTool,
                  selectedCountFn: () => controller.toolsSelectedCount,
                ),

                // ── Special Equipment ──
                _QuantitySection(
                  label: 'Special Equipment',
                  isRequired: true,
                  isExpandedFn: () =>
                  controller.specialEquipmentExpanded.value,
                  onToggle: controller.toggleSpecialEquipment,
                  items: controller.specialEquipment,
                  qtyFn: (i) => controller.specialEquipmentQty[i],
                  onIncrement: controller.incrementSpecial,
                  onDecrement: controller.decrementSpecial,
                  selectedCountFn: () =>
                  controller.specialEquipmentSelectedCount,
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),

      // ── Sticky Save button ──
      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        child: CommonButton(
          titleText: 'Save',
          buttonColor: AppColors.black,
          titleColor: AppColors.white,
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Hero image with back button
// ─────────────────────────────────────────────────────
class _KitchenHeroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 160.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF3A3A3A),
            image: DecorationImage(
              image: AssetImage('assets/images/profile_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 160.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.25),
                Colors.black.withOpacity(0.05),
              ],
            ),
          ),
        ),
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
// Ready for Cooking card — live progress from qty counts
// ─────────────────────────────────────────────────────
class _ReadyForCookingCard extends StatelessWidget {
  final CustomizeKitchenController controller;

  const _ReadyForCookingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int total = controller.appliances.length +
          controller.pansPots.length +
          controller.tools.length +
          controller.specialEquipment.length;
      final int selected = controller.appliancesSelectedCount +
          controller.pansPotsSelectedCount +
          controller.toolsSelectedCount +
          controller.specialEquipmentSelectedCount;
      final double percent = total == 0 ? 0 : selected / total;
      final int percentInt = (percent * 100).round();

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
// Kitchen type selection row
// ─────────────────────────────────────────────────────
class _KitchenTypeSection extends StatelessWidget {
  final CustomizeKitchenController controller;

  const _KitchenTypeSection({required this.controller});

  static const List<Map<String, String>> _types = [
    {
      'title': 'Standard Home Kitchen',
      'subtitle': 'Oven, stove-top, basic pans, knives',
      'emoji': '🏠',
    },
    {
      'title': 'Minimal Kitchen',
      'subtitle': 'Stove-top only, basic tools',
      'emoji': '🔍',
    },
    {
      'title': 'Well-Equipped',
      'subtitle': 'Oven, blender, food processor, grill pan',
      'emoji': '⭐',
    },
    {
      'title': 'Custom Setup',
      'subtitle': '',
      'emoji': '🔨',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_types.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Obx(() {
            final bool isSelected =
                controller.selectedKitchenType.value == index;
            return GestureDetector(
              onTap: () => controller.selectedKitchenType.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color:
                  isSelected ? AppColors.black : const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Text(
                      _types[index]['emoji']!,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: _types[index]['title']!,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.black,
                            textAlign: TextAlign.start,
                          ),
                          if (_types[index]['subtitle']!.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            CommonText(
                              text: _types[index]['subtitle']!,
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
          }),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────
// Quantity Section — collapsible with +/- counters
// ─────────────────────────────────────────────────────
class _QuantitySection extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool Function() isExpandedFn;
  final VoidCallback onToggle;
  final List<String> items;
  final int Function(int) qtyFn;
  final void Function(int) onIncrement;
  final void Function(int) onDecrement;
  final int Function() selectedCountFn;

  const _QuantitySection({
    required this.label,
    required this.isRequired,
    required this.isExpandedFn,
    required this.onToggle,
    required this.items,
    required this.qtyFn,
    required this.onIncrement,
    required this.onDecrement,
    required this.selectedCountFn,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool expanded = isExpandedFn();
      final int count = selectedCountFn();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
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
                  Row(
                    children: [
                      // show selected count badge when collapsed
                      if (!expanded && count > 0) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CommonText(
                            text: '$count selected',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF555555),
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

          // ── Expanded items ──
          AnimatedCrossFade(
            firstChild: Column(
              children: List.generate(items.length, (index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _QuantityRow(
                        label: items[index],
                        qtyFn: () => qtyFn(index),
                        onIncrement: () => onIncrement(index),
                        onDecrement: () => onDecrement(index),
                      ),
                    ),
                    if (index < items.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Divider(
                            height: 1, color: const Color(0xFFF0F0F0)),
                      ),
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
// Quantity Row — item name + decrement / count / increment
// ─────────────────────────────────────────────────────
class _QuantityRow extends StatelessWidget {
  final String label;
  final int Function() qtyFn;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityRow({
    required this.label,
    required this.qtyFn,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int qty = qtyFn();
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Row(
          children: [
            Expanded(
              child: CommonText(
                text: label,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
            ),
            // ── Decrement ──
            GestureDetector(
              onTap: onDecrement,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove_rounded,
                  size: 16.sp,
                  color: qty == 0
                      ? const Color(0xFFCCCCCC)
                      : AppColors.black,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // ── Count ──
            SizedBox(
              width: 20.w,
              child: CommonText(
                text: '$qty',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(width: 12.w),
            // ── Increment ──
            GestureDetector(
              onTap: onIncrement,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 16.sp,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}