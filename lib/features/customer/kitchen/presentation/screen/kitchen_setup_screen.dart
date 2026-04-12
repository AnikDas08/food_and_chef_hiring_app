import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../data/kitchen_model.dart';
import '../controller/kitchen_setup_controller.dart';
import 'cooking_applience_screen.dart';

class KitchenSetupScreen extends StatelessWidget {
  const KitchenSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KitchenSetupController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              _ProgressBar(totalSteps: 5, currentStep: 1),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios, size: 20.sp, color: AppColors.black),
              ),
              SizedBox(height: 24.h),
              CommonText(
                text: 'Your Kitchen Setup',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8.h),
              CommonText(
                text: 'This helps us to find dishes that matches your kitchen, so the chef can prepare a perfect dish, every time.',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 24.h),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Which kitchen best describes yours? ',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.black),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                ]),
              ),
              SizedBox(height: 12.h),

              Expanded(
                child: Obx(() {
                  if (controller.isLoadingPresets.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.black));
                  }
                  if (controller.presetsError.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(
                            text: controller.presetsError.value,
                            fontSize: 13,
                            color: const Color(0xFF888888),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: controller.fetchKitchenPresets,
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

                  final int total = controller.kitchenPresets.length + 1;
                  return ListView.separated(
                    itemCount: total,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      if (index == controller.kitchenPresets.length) {
                        return _CustomSetupCard(controller: controller);
                      }
                      return _PresetCard(
                        controller: controller,
                        index: index,
                        preset: controller.kitchenPresets[index],
                      );
                    },
                  );
                }),
              ),

              CommonText(
                text: 'You can update your setup anytime before a booking',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.h),
              SizedBox(height: 10.h),
              Obx(() {
                final selected = controller.isAnythingSelected;
                final submitting = controller.isSubmittingPreset.value;
                final loadingEquipment = controller.isLoadingEquipment.value;
                final loadingPresetItems = controller.isLoadingPresetItems.value;
                final busy = submitting || loadingEquipment || loadingPresetItems;

                return CommonButton(
                  titleText: busy ? 'Please wait...' : 'Continue',
                  buttonColor: selected ? AppColors.black : const Color(0xFFAAAAAA),
                  titleColor: AppColors.white,
                  onTap: (!selected || busy)
                      ? null
                      : () async {
                    if (controller.isCustomSetup) {
                      // Custom Setup: fetch equipment (all unselected), go to next screen
                      await controller.fetchEquipmentList();
                      Get.to(() => const CookingAppliancesScreen());
                    } else {
                      // Preset: fetch preset items first (to know which to pre-select),
                      // then fetch full equipment list (applyPresetSelections is called
                      // inside fetchEquipmentList after build), then navigate
                      final preset = controller
                          .kitchenPresets[controller.selectedKitchenIndex.value];
                      await controller.fetchPresetItems(preset.kitchen);
                      await controller.fetchEquipmentList();
                      Get.to(() => const CookingAppliancesScreen());
                    }
                  },
                );
              }),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Preset Card ───
class _PresetCard extends StatelessWidget {
  final KitchenSetupController controller;
  final int index;
  final KitchenPresetModel preset;

  const _PresetCard({
    required this.controller,
    required this.index,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedKitchenIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectPreset(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              _PresetImage(imageUrl: preset.image, isSelected: isSelected),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: preset.name,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.black,
                      textAlign: TextAlign.start,
                    ),
                    if (preset.items.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      CommonText(
                        text: preset.items,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? const Color(0xFFCCCCCC) : const Color(0xFF888888),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

class _PresetImage extends StatelessWidget {
  final String? imageUrl;
  final bool isSelected;
  const _PresetImage({this.imageUrl, required this.isSelected});
  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (_hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: ApiEndPoint.imageUrl + imageUrl!,
          width: 44.w, height: 44.w, fit: BoxFit.cover,
          placeholder: (_, __) => _defaultBox(),
          errorWidget: (_, __, ___) => _defaultBox(),
        ),
      );
    }
    return _defaultBox();
  }

  Widget _defaultBox() => Container(
    width: 44.w, height: 44.w,
    decoration: BoxDecoration(
      color: isSelected ? Colors.white.withOpacity(0.15) : const Color(0xFFEEEEEE),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Icon(Icons.kitchen_outlined, size: 24.sp,
        color: isSelected ? Colors.white70 : const Color(0xFF888888)),
  );
}

class _CustomSetupCard extends StatelessWidget {
  final KitchenSetupController controller;
  const _CustomSetupCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedKitchenIndex.value == 9999;
      return GestureDetector(
        onTap: controller.selectCustomSetup,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w, height: 44.w,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.15) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(child: Text('🔨', style: TextStyle(fontSize: 22.sp))),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CommonText(
                  text: 'Custom Setup',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.black,
                  textAlign: TextAlign.start,
                ),
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