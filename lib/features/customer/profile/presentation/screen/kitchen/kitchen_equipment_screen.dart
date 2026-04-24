import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../controller/kitchen_equipment_controller.dart';
import 'customize_kitchen_screen.dart';

// Fixed 4 category names — always shown in this order
const List<String> _kCategories = [
  'Cooking Appliances',
  'Pots & Pans',
  'Tools',
  'Special Equipment',
];

class KitchenEquipmentScreen extends StatelessWidget {
  const KitchenEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KitchenEquipmentController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              // ── Hero kitchen image ──
              _KitchenHeroImage(controller: controller),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // Title
                    const CommonText(
                      text: 'Kitchen Equipment',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 14.h),

                    // ── Ready for cooking card ──
                    _ReadyForCookingCard(controller: controller),
                    SizedBox(height: 20.h),

                    // ── Kitchen type label ──
                    RichText(
                      text: TextSpan(children: [
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
                      ]),
                    ),
                    SizedBox(height: 10.h),

                    // ── Preset cards from API + Custom Setup at bottom ──
                    _PresetCards(controller: controller),
                    SizedBox(height: 10.h),

                    // ── Equipment sections ──
                    // Custom Setup selected: checkable list from API
                    // Preset selected / default: read-only sections from kitchen data
                    _EquipmentBody(controller: controller),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            child: InkWell(
              onTap: () => Get.back(),
              child: const CommonImage(
                imageSrc: 'assets/icons/back.svg',
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        child: CommonButton(
          titleText: 'Customize Your Kitchen',
          buttonColor: AppColors.black,
          onTap: () => Get.to(() => const CustomizeKitchenScreen()),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Hero image — original design, no edit button
// ─────────────────────────────────────────────────────
class _KitchenHeroImage extends StatelessWidget {
  final KitchenEquipmentController controller;
  const _KitchenHeroImage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final String image = controller.myKitchenImage.value;
      final bool hasImage = image.isNotEmpty;

      return Stack(
        children: [
          Container(
            height: 200.h,
            width: double.infinity,
            color: const Color(0xFF2C2C2C),
            child: hasImage
                ? CachedNetworkImage(
              imageUrl: ApiEndPoint.imageUrl + image,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              placeholder: (_, __) => _defaultImage(),
              errorWidget: (_, __, ___) => _defaultImage(),
            )
                : _defaultImage(),
          ),
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
        ],
      );
    });
  }

  Widget _defaultImage() => Image.asset(
    'assets/images/noImage.png',
    width: double.infinity,
    height: 200,
    fit: BoxFit.cover,
  );
}

// ─────────────────────────────────────────────────────
// Preset cards — API list + fixed Custom Setup at bottom
// ─────────────────────────────────────────────────────
class _PresetCards extends StatelessWidget {
  final KitchenEquipmentController controller;
  const _PresetCards({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPresets.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(color: Colors.black),
          ),
        );
      }
      if (controller.presetsError.value.isNotEmpty) {
        return _ErrorRetry(
          message: controller.presetsError.value,
          onRetry: controller.fetchPresets,
        );
      }

      // Preset list + Custom Setup card at end
      final int total = controller.presets.length + 1;
      return Column(
        children: List.generate(total, (index) {
          final bool isCustom = index == controller.presets.length;
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: isCustom
                ? _CustomSetupCard(controller: controller)
                : _PresetCard(
              controller: controller,
              index: index,
            ),
          );
        }),
      );
    });
  }
}

class _PresetCard extends StatelessWidget {
  final KitchenEquipmentController controller;
  final int index;
  const _PresetCard({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final preset = controller.presets[index];
      final bool isSelected = controller.selectedPresetIndex.value == index;
      final String? imageUrl = preset.image; // add this field to your preset model if not there

      return GestureDetector(
        onTap: () => controller.onPresetTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff272727) : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              // ── Image or icon ──
              _PresetThumbnail(imageUrl: imageUrl, isSelected: isSelected),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: preset.name,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.black,
                      textAlign: TextAlign.start,
                    ),
                    if (preset.items.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      CommonText(
                        text: preset.items,
                        fontSize: 11,
                        color: isSelected
                            ? const Color(0xFFFFFFFF)
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
                  child: const CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
            ],
          ),
        ),
      );
    });
  }
}

// ── Thumbnail: network image if available, icon fallback ──
class _PresetThumbnail extends StatelessWidget {
  final String? imageUrl;
  final bool isSelected;

  const _PresetThumbnail({this.imageUrl, required this.isSelected});

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: _hasImage
            ? CachedNetworkImage(
          imageUrl: ApiEndPoint.imageUrl + imageUrl!,
          width: 40.w,
          height: 40.w,
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
    size: 22.sp,
    color: isSelected ? Colors.white : const Color(0xFF888888),
  );
}

class _CustomSetupCard extends StatelessWidget {
  final KitchenEquipmentController controller;
  const _CustomSetupCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedPresetIndex.value == 9999;
      return GestureDetector(
        onTap: () => controller.selectCustomSetup(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.15)
                      : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text('🔨', style: TextStyle(fontSize: 20.sp)),
                ),
              ),
              SizedBox(width: 12.w),
              CommonText(
                text: 'Custom Setup',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.black,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      );
    });
  }
}


// ─────────────────────────────────────────────────────
// Equipment body — switches between custom setup and normal view
// ─────────────────────────────────────────────────────
class _EquipmentBody extends StatelessWidget {
  final KitchenEquipmentController controller;
  const _EquipmentBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isCustom = controller.selectedPresetIndex.value == 9999;

      if (isCustom) {
        // ── Custom Setup — checkable list from equipment?type=list ──
        if (controller.isLoadingCustomSetup.value) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(
                child: CircularProgressIndicator(color: Colors.black)),
          );
        }
        if (controller.customSetupError.value.isNotEmpty) {
          return _ErrorRetry(
            message: controller.customSetupError.value,
            onRetry: controller.selectCustomSetup,
          );
        }
        if (controller.customSetupCategories.isEmpty) {
          return const SizedBox.shrink();
        }
        // Show each category as collapsible with checkboxes
        return Column(
          children: controller.customSetupCategories
              .map((cat) => _CustomSetupSection(
            controller: controller,
            category: cat,
          ))
              .toList(),
        );
      }

      // ── Normal view — always show all 4 sections ──
      return Column(
        children: _kCategories
            .map((cat) => _CollapsibleSection(
          controller: controller,
          categoryName: cat,
        ))
            .toList(),
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Custom Setup Section — collapsible with checkboxes
// Items pre-checked if user already has them
// ─────────────────────────────────────────────────────
class _CustomSetupSection extends StatelessWidget {
  final KitchenEquipmentController controller;
  final EquipmentListCategory category;

  const _CustomSetupSection({
    required this.controller,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool expanded = controller.isExpanded(category.category);

      return Column(
        children: [
          // ── Header ──
          GestureDetector(
            onTap: () => controller.toggleCategory(category.category),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: category.category,
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
                    ]),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_up_rounded,
                        size: 22.sp, color: AppColors.black),
                  ),
                ],
              ),
            ),
          ),

          // ── Items with checkboxes ──
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: List.generate(category.items.length, (i) {
                final item = category.items[i];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleCustomItem(
                          category.category, i),
                      behavior: HitTestBehavior.opaque,
                      child: Obx(() {
                        final bool isChecked = controller
                            .customSetupCategories
                            .firstWhereOrNull(
                                (c) => c.category == category.category)
                            ?.items[i]
                            .isSelected ??
                            false;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  color: isChecked
                                      ? AppColors.black
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isChecked
                                        ? AppColors.black
                                        : const Color(0xFFCCCCCC),
                                    width: 1.5,
                                  ),
                                ),
                                child: isChecked
                                    ? Icon(Icons.check_rounded,
                                    size: 14.sp, color: AppColors.white)
                                    : null,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: CommonText(
                                  text: item.name,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    if (i < category.items.length - 1)
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  ],
                );
              }),
            ),
            secondChild: const SizedBox.shrink(),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Collapsible section — always rendered for all 4 categories
// Items come from controller based on selected preset or user kitchen
// If no items → section header still shows, body is empty
// ─────────────────────────────────────────────────────
class _CollapsibleSection extends StatelessWidget {
  final KitchenEquipmentController controller;
  final String categoryName;

  const _CollapsibleSection({
    required this.controller,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool expanded = controller.isExpanded(categoryName);
      final List<KitchenDetailItem> items =
      controller.itemsForCategory(categoryName);

      return Column(
        children: [
          // ── Section header — always shown, always toggleable ──
          GestureDetector(
            onTap: () => controller.toggleCategory(categoryName),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
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
                    ]),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_up_rounded,
                        size: 22.sp, color: AppColors.black),
                  ),
                ],
              ),
            ),
          ),

          // ── Items — only rendered when expanded ──
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: items.isEmpty
                ? Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: const CommonText(
                text: 'No items',
                fontSize: 13,
                color: Color(0xFFAAAAAA),
                textAlign: TextAlign.start,
              ),
            )
                : Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      child: Row(
                        children: [
                          // Checkbox style — filled = available
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22.w,
                            height: 22.w,
                            decoration: BoxDecoration(
                              color: item.availability
                                  ? AppColors.black
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: item.availability
                                    ? AppColors.black
                                    : const Color(0xFFCCCCCC),
                                width: 1.5,
                              ),
                            ),
                            child: item.availability
                                ? Icon(Icons.check_rounded,
                                size: 14.sp, color: AppColors.white)
                                : null,
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: CommonText(
                              text: item.name,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          // Quantity badge
                          /*if (item.quantity > 0)
                            Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CommonText(
                                  text: '${item.quantity}',
                                  fontSize: 11,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),*/
                        ],
                      ),
                    ),
                    if (i < items.length - 1)
                      const Divider(
                          height: 1,
                          color: Color(0xFFF0F0F0)),
                  ],
                );
              }),
            ),
            secondChild: const SizedBox.shrink(),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────
// Ready for Cooking card — original design
// ─────────────────────────────────────────────────────
class _ReadyForCookingCard extends StatelessWidget {
  final KitchenEquipmentController controller;
  const _ReadyForCookingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double percent = controller.matchPercent;
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
              fontSize: 14,
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

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
                text: message,
                fontSize: 13,
                color: const Color(0xFF888888),
                maxLines: 3),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: onRetry,
              child: const CommonText(
                  text: 'Tap to retry',
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}