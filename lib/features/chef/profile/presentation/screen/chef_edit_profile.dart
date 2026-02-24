import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../controller/chef_profile_controller.dart';
import '../widgets/chef_profile_all_filed.dart';

class ChefEditProfile extends StatelessWidget {
  const ChefEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 20, color: Color(0xff272727)),
              onPressed: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: controller.formKey,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Edit Profile',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      bottom: 28,
                    ),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 34.sp,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: controller.image != null
                                ? Image.file(
                              File(controller.image!),
                              width: 68.sp,
                              height: 68.sp,
                              fit: BoxFit.fill,
                            )
                                : const CommonImage(
                              imageSrc: AppImages.image3,
                              height: 68,
                              width: 68,
                              fill: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 40,
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
                              child: Icon(
                                Icons.mode_edit_outline_outlined,
                                size: 16.sp,
                                color: const Color(0xff272727),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const CommonText(
                      text: 'PERSONAL DETAILS',
                      bottom: 12,
                      top: 28,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff777777),
                    ),

                    ChefProfileAllFiled(controller: controller),

                    CommonButton(
                      titleText: 'Save Changes',
                      isLoading: controller.isLoading,
                      onTap: controller.editProfileRepo,
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}