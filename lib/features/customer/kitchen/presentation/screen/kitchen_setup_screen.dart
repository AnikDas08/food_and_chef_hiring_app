import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
//import '../../widgets/buttons/common_button.dart';
//import '../../widgets/text/common_text.dart';
import '../controller/kitchen_setup_controller.dart';
import 'cooking_applience_screen.dart';
//import 'kitchen_setup_controller.dart';
//import 'cooking_appliances_screen.dart';

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
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                  color: AppColors.black,
                ),
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
                text:
                'This helps us to find dishes that matches your kitchen, so the chef can prepare a perfect dish, every time.',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 24.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Which kitchen best describes yours? ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              // Pass controller + index into the card so it reads
              // selectedKitchenType.value directly inside its own Obx
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.kitchenTypes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final item = controller.kitchenTypes[index];
                    return _KitchenTypeCard(
                      controller: controller,
                      index: index,
                      emoji: item['emoji'],
                      title: item['title'],
                      subtitle: item['subtitle'],
                    );
                  },
                ),
              ),
              CommonText(
                text: 'You can update your setup anytime before a booking',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.h),
              CommonButton(
                titleText: 'Skip For Now',
                buttonColor: const Color(0xFFF2F2F2),
                titleColor: AppColors.black,
                onTap: () => Get.to(() => const CookingAppliancesScreen()),
              ),
              SizedBox(height: 10.h),
              Obx(
                    () => CommonButton(
                  titleText: 'Continue',
                  buttonColor: controller.selectedKitchenType.value == -1
                      ? const Color(0xFFAAAAAA)
                      : AppColors.black,
                  titleColor: AppColors.white,
                  onTap: controller.selectedKitchenType.value == -1
                      ? null
                      : () => Get.to(() => const CookingAppliancesScreen()),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Kitchen Type Card
// Reads selectedKitchenType.value directly inside Obx
// so it always reacts when the selection changes
// ─────────────────────────────────────────────────────
class _KitchenTypeCard extends StatelessWidget {
  final KitchenSetupController controller;
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
      // Reading .value here — inside the Obx builder — is what makes
      // this card re-render whenever selectedKitchenType changes
      final bool isSelected = controller.selectedKitchenType.value == index;

      return GestureDetector(
        onTap: () => controller.selectKitchenType(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 22.sp)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.black,
                      textAlign: TextAlign.start,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      CommonText(
                        text: subtitle,
                        fontSize: 12,
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
// Progress Bar
// ─────────────────────────────────────────────────────
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
              color: index < currentStep
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