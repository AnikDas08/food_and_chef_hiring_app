import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/kitchen_setup_controller.dart';

class UploadKitchenPhotoScreen extends StatelessWidget {
  const UploadKitchenPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller available if needed for photo state
    Get.find<KitchenSetupController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              _ProgressBar(totalSteps: 5, currentStep: 5),
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
                text: 'Upload a photo of your kitchen',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8.h),
              CommonText(
                text:
                'Provide us with a photo of your kitchen to help the chef prepare for your order.',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  // TODO: integrate image_picker
                  // final ImagePicker picker = ImagePicker();
                  // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                },
                child: Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 36.sp,
                        color: const Color(0xFF888888),
                      ),
                      SizedBox(height: 8.h),
                      CommonText(
                        text: 'Select a picture',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF888888),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16.sp,
                    color: const Color(0xFF27AE60),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: CommonText(
                      text:
                      'We only show your photo to the chef after booking.',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF27AE60),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CommonButton(
                titleText: 'Skip For Now',
                buttonColor: const Color(0xFFF2F2F2),
                titleColor: AppColors.black,
                onTap: () {
                  // Navigate to home or next main screen
                  Get.offAllNamed('/home');
                },
              ),
              SizedBox(height: 10.h),
              CommonButton(
                titleText: 'Continue',
                buttonColor: AppColors.black,
                titleColor: AppColors.white,
                onTap: () {
                  // Navigate to home or next main screen
                  Get.offAllNamed('/home');
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
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