import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/kitchen_setup_controller.dart';


class SpecialEquipmentScreen extends StatelessWidget {
  const SpecialEquipmentScreen({super.key});

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
                  _ProgressBar(totalSteps: 5, currentStep: 4),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios, size: 20.sp, color: AppColors.black),
                  ),
                  SizedBox(height: 24.h),
                  CommonText(
                    text: 'Add Special Equipment',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.h),
                  CommonText(
                    text: 'Customize your set-up to reflect your kitchen.',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 24.h),
                  _SectionHeader(label: 'Special Equipment', isRequired: true),
                  SizedBox(height: 4.h),
                ],
              ),
            ),

            // ── Scrollable list ──
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.specialEquipment.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _CheckboxRow(
                        label: controller.specialEquipment[index],
                        isCheckedFn: () => controller.specialEquipmentSelected[index],
                        onTap: () => controller.toggleSpecialEquipment(index),
                      ),
                      if (index < controller.specialEquipment.length - 1)
                        Divider(height: 1, color: const Color(0xFFF0F0F0)),
                    ],
                  );
                },
              ),
            ),

            // ── Fixed footer ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  CommonButton(
                    titleText: 'Continue',
                    buttonColor: AppColors.black,
                    titleColor: AppColors.white,
                    //onTap: () => Get.to(() => const UploadKitchenPhotoScreen()),
                  ),
                  SizedBox(height: 20.h),
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
          padding: EdgeInsets.symmetric(vertical: 14.h),
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
                    color: isChecked ? AppColors.black : const Color(0xFFCCCCCC),
                    width: 1.5,
                  ),
                ),
                child: isChecked
                    ? Icon(Icons.check_rounded, size: 14.sp, color: AppColors.white)
                    : null,
              ),
              SizedBox(width: 14.w),
              CommonText(
                text: label,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _SectionHeader({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.black),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.red),
                ),
            ],
          ),
        ),
        Icon(Icons.keyboard_arrow_up_rounded, size: 22.sp, color: AppColors.black),
      ],
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
              color: index < currentStep ? AppColors.black : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}