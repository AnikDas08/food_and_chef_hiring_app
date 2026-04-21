import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';
import '../controller/chef_profile_controller.dart';
import '../widgets/chef_profile_all_filed.dart';

class ChefEditProfile extends StatefulWidget {
  const ChefEditProfile({super.key});

  @override
  State<ChefEditProfile> createState() => _ChefEditProfileState();
}

class _ChefEditProfileState extends State<ChefEditProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChefProfileController>().loadProfileData();
      Get.find<ChefProfileController>().fetchCuisines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefProfileController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
            ),
            automaticallyImplyLeading: false,
            leadingWidth: 60,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    SizedBox(height: 24.h),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 36.sp,
                          backgroundColor: const Color(0xffF0F0F0),
                          child: ClipOval(
                            child:
                                controller.image != null
                                    ? Image.file(
                                      File(controller.image!),
                                      width: 72.sp,
                                      height: 72.sp,
                                      fit: BoxFit.cover,
                                    )
                                    : CommonImage(
                                      imageSrc: () {
                                        final profileImage =
                                            Get.find<ChefHomeController>()
                                                .chefProfile
                                                .value
                                                ?.image ??
                                            '';
                                        return profileImage.isNotEmpty
                                            ? profileImage
                                            : AppImages.image3;
                                      }(),
                                      height: 72.sp,
                                      width: 72.sp,
                                      fill: BoxFit.cover,
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          left: 48,
                          child: GestureDetector(
                            onTap: controller.getProfileImage,
                            child: Container(
                              padding: EdgeInsets.all(6.sp),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xffE0E0E0),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 14.sp,
                                color: const Color(0xff272727),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    _SectionLabel(text: 'PERSONAL DETAILS'),
                    SizedBox(height: 16.h),
                    ChefProfileAllFiled(controller: controller),
                    SizedBox(height: 8.h),
                    CommonButton(
                      titleText: 'Save Changes',
                      isLoading: controller.isLoading,
                      onTap: () => controller.editProfileRepo(_formKey),
                    ),
                    SizedBox(height: 32.h),
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

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xff999999),
        letterSpacing: 0.8,
      ),
    );
  }
}
