import 'dart:io';
import 'package:flutter/material.dart';
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
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          /// App Bar Sections Starts here
          appBar: AppBar(),

          /// Body Sections Starts here
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
                      color: Color(0xff272727),
                      bottom: 28,
                    ),

                    /// User Profile image here
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 34.sp,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child:
                                controller.image != null
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

                        /// image change icon here
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
                                  color: Color(0xffF1F1F1),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.mode_edit_outline_outlined,
                                size: 16.sp,
                                color: Color(0xff272727),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    CommonText(
                      text: AppString.personalDetails.toUpperCase(),
                      bottom: 12,
                      top: 28,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff777777),
                    ),

                    /// user all information filed here
                    EditProfileAllFiled(controller: controller),
                    30.height,

                    /// Submit Button here
                    CommonButton(
                      titleText: AppString.saveChanges,
                      isLoading: controller.isLoading,
                      onTap: controller.editProfileRepo,
                    ),
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
