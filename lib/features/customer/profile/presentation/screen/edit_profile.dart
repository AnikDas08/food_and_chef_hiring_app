import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import '../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/profile_controller.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../widgets/edit_profile_all_filed.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: controller.formKey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: AppString.editProfile,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                  bottom: 28,
                ),

                // ── Profile Image — reactive Obx ──────────────────────────
                Center(
                  child: Obx(() {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 100.sp,
                          width: 100.sp,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffF1F1F1),
                          ),
                          child: ClipOval(
                            child: controller.imagePath.value.isNotEmpty
                                ? Image.file(
                              File(controller.imagePath.value),
                              fit: BoxFit.cover,
                            )
                                : CommonImage(
                              imageSrc: controller.profileImage.value
                                  .isNotEmpty
                                  ? ApiEndPoint.imageUrl +
                                  controller.profileImage.value
                                  : AppImages.image3,
                              height: 100,
                              width: 100,
                              fill: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Camera button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: controller.getProfileImage,
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xffF1F1F1),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                CommonText(
                  text: AppString.personalDetails.toUpperCase(),
                  bottom: 12,
                  top: 28,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff777777),
                ),

                // ── All fields ────────────────────────────────────────────
                EditProfileAllFiled(controller: controller),
                30.height,

                // ── Save button — reactive loading ────────────────────────
                Obx(() => CommonButton(
                  titleText: AppString.saveChanges,
                  buttonRadius: 20,
                  isLoading: controller.isLoading.value,
                  onTap: () => controller.editProfileRepo(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}