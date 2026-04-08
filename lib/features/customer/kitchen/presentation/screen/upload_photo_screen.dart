import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_untitled/features/customer/home/presentation/screen/customer_home_screen.dart';
import 'package:new_untitled/utils/app_utils.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/kitchen_setup_controller.dart';

class UploadKitchenPhotoScreen extends StatelessWidget {
  const UploadKitchenPhotoScreen({super.key});

  // ── Bottom sheet: Camera or Gallery ──
  void _showImageSourceSheet(
      BuildContext context, KitchenSetupController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20.h),
                CommonText(
                  text: 'Select Photo',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 20.h),

                // Camera option
                _SourceTile(
                  icon: Icons.camera_alt_outlined,
                  label: 'Take a Photo',
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.camera);
                  },
                ),
                Divider(height: 1, color: const Color(0xFFF0F0F0)),

                // Gallery option
                _SourceTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Choose from Gallery',
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.gallery);
                  },
                ),

                SizedBox(height: 12.h),

                // Cancel
                CommonButton(
                  titleText: 'Cancel',
                  buttonColor: const Color(0xFFF2F2F2),
                  titleColor: AppColors.black,
                  onTap: () => Get.back(),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KitchenSetupController>();

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
                maxLines: 3,
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

              // ── Image picker box ──
              Obx(() {
                final image = controller.selectedImage.value;

                return GestureDetector(
                  onTap: () => _showImageSourceSheet(context, controller),
                  child: Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: image != null
                            ? AppColors.black
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                    ),
                    child: image == null
                    // ── Empty state ──
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 38.sp,
                          color: const Color(0xFF888888),
                        ),
                        SizedBox(height: 10.h),
                        CommonText(
                          text: 'Select a picture',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF888888),
                        ),
                        SizedBox(height: 4.h),
                        CommonText(
                          text: 'Tap to open camera or gallery',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFBBBBBB),
                        ),
                      ],
                    )
                    // ── Selected image ──
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13.r),
                          child: Image.file(
                            File(image.path),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Remove button
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: controller.removeImage,
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),
                        // Change photo label at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(13.r),
                              ),
                            ),
                            child: CommonText(
                              text: 'Tap to change photo',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

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
                      text: 'We only show your photo to the chef after booking.',
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

              SizedBox(height: 10.h),
              Obx(
                    () {
                  final submitting = controller.isSubmittingCustom.value;
                  return CommonButton(
                    titleText: submitting ? 'Please wait...' : 'Continue',
                    buttonColor: submitting
                        ? const Color(0xFFAAAAAA)
                        : AppColors.black,
                    titleColor: AppColors.white,
                    onTap: submitting
                        ? null
                        : () async {
                      final success =
                      await controller.submitCustomKitchen();
                      if (success) {
                        Get.offAll(()=>CustomerHomeScreen());
                        Utils.successSnackBar("Successful", "Successfully create kitchen");
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),

              CommonButton(
                titleText: "Skip for Now",
                onTap: () {
                  controller.submitCustomKitchen();
                },
                buttonColor: Colors.transparent,
                borderColor: Colors.transparent,
                titleColor: Colors.black,
                titleSize: 14.sp,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Source tile inside bottom sheet
// ─────────────────────────────────────────────────────
class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.sp, color: AppColors.black),
            ),
            SizedBox(width: 14.w),
            CommonText(
              text: label,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
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