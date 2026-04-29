import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../controller/customize_kitchen_controller.dart';
import '../../controller/kitchen_equipment_controller.dart';

const List<String> _kCategories = [
  'Cooking Appliances',
  'Pots & Pans',
  'Tools',
  'Special Equipment',
];

class CustomizeKitchenScreen extends StatelessWidget {
  const CustomizeKitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomizeKitchenController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Hero image with back button overlay ──
            Stack(
              children: [
                _KitchenHeroImage(controller: controller),
                // ── Back Button overlay on hero image ──
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8.h,
                  left: 16.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: LiquidGlassLayer(
                      child: LiquidGlass(
                        shape: const LiquidRoundedSuperellipse(borderRadius: 30),
                        child: Container(
                          width: 40.sp,
                          height: 40.sp,
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  const CommonText(
                    text: 'Kitchen Equipment',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(height: 14.h),
                  _ReadyForCookingCard(controller: controller),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Which kitchen best describes yours? ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
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
                    ]),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),

            // ── Preset cards + Custom Setup ──
            _PresetCards(controller: controller),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            SizedBox(height: 4.h),

            // ── Equipment sections (qty or read-only) ──
            _EquipmentBody(controller: controller),

            SizedBox(height: 100.h),
          ],
        ),

      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        child: Obx(() => CommonButton(
          titleText: controller.isSaving.value ? 'Saving...' : 'Save',
          buttonColor: controller.isSaving.value
              ? const Color(0xff2727272)
              : AppColors.primaryColor,
          onTap: controller.isSaving.value ? null : controller.save,
        )),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Hero image — shows server image or placeholder
// Edit icon top-right
// ─────────────────────────────────────────────────────
class _KitchenHeroImage extends StatelessWidget {
  final CustomizeKitchenController controller;
  const _KitchenHeroImage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dynamic localFile = controller.localImage.value;
      final String server = controller.serverImage.value;
      final bool hasLocal = localFile != null;
      final bool hasServer = server.isNotEmpty;

      return Stack(
        children: [
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: hasLocal
                ? Image.file(File(localFile.path),
                fit: BoxFit.cover, width: double.infinity)
                : hasServer
                ? CachedNetworkImage(
              imageUrl: '${ApiEndPoint.imageUrl}$server',
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) => _placeholder(),
              errorWidget: (_, __, ___) => _placeholder(),
            )
                : _placeholder(),
          ),
          Container(
            height: 200.h,
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
          // ── Scrolling Edit Button ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            right: 16.w,
            child: GestureDetector(
              onTap: controller.pickImage,
              child: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: const LiquidRoundedSuperellipse(borderRadius: 30),
                  child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.edit_outlined,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _placeholder() => Container(
    height: 200.h,
    color: const Color(0xFFF1F1F1),
    child: const Center(
        child: Icon(Icons.kitchen_outlined, size: 48, color: AppColors.secondaryTextColor)),
  );

  Widget _overlayBtn(IconData icon) => Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 16, color: AppColors.primaryColor),
  );
}

// ─────────────────────────────────────────────────────
// Preset cards + Custom Setup
// ─────────────────────────────────────────────────────
class _PresetCards extends StatelessWidget {
  final CustomizeKitchenController controller;
  const _PresetCards({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPresets.value) {
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CupertinoActivityIndicator(color: AppColors.primaryColor),
            ));
      }

      final int total = controller.presets.length + 1; // +1 for Custom Setup
      return Column(
        children: List.generate(total, (index) {
          final bool isCustom = index == controller.presets.length;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
            child: isCustom
                ? _CustomSetupCard(controller: controller)
                : _PresetCard(controller: controller, index: index),
          );
        }),
      );
    });
  }
}

class _PresetCard extends StatelessWidget {
  final CustomizeKitchenController controller;
  final int index;
  const _PresetCard({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final preset = controller.presets[index];
      final bool isSelected = controller.selectedPresetIndex.value == index;
      return GestureDetector(
        onTap: () => controller.onPresetTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              _PresetThumbnail(imageUrl: preset.image, isSelected: isSelected),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: preset.name,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.primaryColor,
                      textAlign: TextAlign.start,
                    ),
                    if (preset.items.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      CommonText(
                        text: preset.items,
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF777777),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected && controller.isLoadingPresetDetail.value)
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CupertinoActivityIndicator(
                      radius: 8, color: Colors.white),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _PresetThumbnail extends StatelessWidget {
  final String? imageUrl;
  final bool isSelected;

  const _PresetThumbnail({this.imageUrl, required this.isSelected});

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 24.w,
        height: 24.w,
        child: _hasImage
            ? CachedNetworkImage(
          imageUrl: imageUrl!.startsWith('http') ? imageUrl! : '${ApiEndPoint.imageUrl}/$imageUrl!',
          width: 24.w,
          height: 24.w,
          fit: BoxFit.cover,
          placeholder: (_, __) => _iconFallback(),
          errorWidget: (_, __, ___) => _iconFallback(),
        )
            : _iconFallback(),
      ),
    );
  }

  Widget _iconFallback() => Icon(
    Icons.kitchen_outlined,
    size: 24.sp,
    color: isSelected ? Colors.white : const Color(0xFF888888),
  );
}

class _CustomSetupCard extends StatelessWidget {
  final CustomizeKitchenController controller;
  const _CustomSetupCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedPresetIndex.value == 9999;
      return GestureDetector(
        onTap: controller.selectCustomSetup,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                child:CommonImage(imageSrc: "assets/images/custom_image.png")
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CommonText(
                  text: 'Custom Setup',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.primaryColor,
                  textAlign: TextAlign.start,
                ),
              ),
              if (isSelected && controller.isLoadingCustomSetup.value)
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CupertinoActivityIndicator(
                      radius: 8, color: Colors.white),
                ),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Equipment body
// selected = -1 (default) → show nothing / placeholder
// selected = preset index or 9999 (custom) → show +/- qty rows
// ─────────────────────────────────────────────────────
class _EquipmentBody extends StatelessWidget {
  final CustomizeKitchenController controller;
  const _EquipmentBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading equipment list (init, preset tap or custom setup)
      if (controller.isLoadingEquipmentList.value ||
          controller.isLoadingPresetDetail.value ||
          controller.isLoadingMyKitchen.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: const Center(
              child: CupertinoActivityIndicator(color: AppColors.primaryColor)),
        );
      }

      // Error
      if (controller.equipmentListError.value.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.all(20.h),
          child: Center(
            child: CommonText(
              text: controller.equipmentListError.value,
              fontSize: 13,
              color: const Color(0xFF888888),
            ),
          ),
        );
      }

      // Qty +/- sections — same for both preset and custom setup
      return Column(
        children: _kCategories.map((cat) {
          final catData = controller.customSetupCategories
              .firstWhereOrNull((c) => c.category == cat);
          return _QuantitySection(
            controller: controller,
            categoryName: cat,
            items: catData?.items ?? [],
          );
        }).toList(),
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Quantity Section — collapsible with +/- per item
// Same design as original CustomizeKitchenScreen
// ─────────────────────────────────────────────────────
class _QuantitySection extends StatelessWidget {
  final CustomizeKitchenController controller;
  final String categoryName;
  final List<EquipmentListItem> items;

  const _QuantitySection({
    required this.controller,
    required this.categoryName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool expanded = controller.isExpanded(categoryName);
      final int count = controller.selectedCountFor(categoryName);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          GestureDetector(
            onTap: () => controller.toggleCategory(categoryName),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: categoryName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
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
                    ]),
                  ),
                  Row(
                    children: [
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
                            color: const Color(0xFF555555),
                          ),
                        ),
                        SizedBox(width: 6.w),
                      ],
                      AnimatedRotation(
                        turns: expanded ? 0 : 0.5,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_up_rounded,
                            size: 22.sp, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Items ──
          AnimatedCrossFade(
            firstChild: items.isEmpty
                ? Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
              child: const CommonText(
                text: 'No items',
                fontSize: 13,
                color: Color(0xFFAAAAAA),
                textAlign: TextAlign.start,
              ),
            )
                : Column(
              children: List.generate(items.length, (i) {
                return Column(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w),
                      child: _QuantityRow(
                        controller: controller,
                        categoryName: categoryName,
                        index: i,
                        item: items[i],
                      ),
                    ),
                    if (i < items.length - 1)
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Divider(
                            height: 1,
                            color: Color(0xFFF0F0F0)),
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

          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Quantity row — item name + decrement / count / increment
// ─────────────────────────────────────────────────────
class _QuantityRow extends StatelessWidget {
  final CustomizeKitchenController controller;
  final String categoryName;
  final int index;
  final EquipmentListItem item;

  const _QuantityRow({
    required this.controller,
    required this.categoryName,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int qty = controller.customSetupCategories
          .firstWhereOrNull((c) => c.category == categoryName)
          ?.items[index]
          .quantity ??
          0;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Row(
          children: [
            Expanded(
              child: CommonText(
                text: item.name,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
              ),
            ),
            // Decrement
            GestureDetector(
              onTap: () =>
                  controller.decrementCustomItem(categoryName, index),
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.remove_rounded,
                    size: 16.sp,
                    color: qty == 0
                        ? const Color(0xFFCCCCCC)
                        : AppColors.primaryColor),
              ),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 20.w,
              child: CommonText(
                text: '$qty',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 12.w),
            // Increment
            GestureDetector(
              onTap: () =>
                  controller.incrementCustomItem(categoryName, index),
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_rounded,
                    size: 16.sp, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      );
    });
  }
}


// ─────────────────────────────────────────────────────
// Ready for Cooking card
// ─────────────────────────────────────────────────────
class _ReadyForCookingCard extends StatelessWidget {
  final CustomizeKitchenController controller;
  const _ReadyForCookingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Count items with qty > 0 across all custom setup categories
      int total = 0;
      int selected = 0;
      for (final cat in controller.customSetupCategories) {
        for (final item in cat.items) {
          total++;
          if (item.quantity > 0) selected++;
        }
      }
      final double percent = total == 0 ? 0 : selected / total;
      final int percentInt = (percent * 100).round();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: 'You\'re Ready for Cooking',
              fontWeight: FontWeight.w600,
              color: Color(0xFF272727),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8.h),
            Stack(
              children: [
                Container(
                  height: 6.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  height: 6.h,
                  width:
                  (MediaQuery.of(context).size.width - 68.w) * percent,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6D00),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Your kitchen can handle ',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF888888)),
                ),
                TextSpan(
                  text: '$percentInt%',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF6D00)),
                ),
                TextSpan(
                  text: ' of recipes on the platform',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF888888)),
                ),
              ]),
            ),
          ],
        ),
      );
    });
  }
}