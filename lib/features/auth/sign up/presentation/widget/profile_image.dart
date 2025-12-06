import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/auth/sign%20up/presentation/controller/sign_up_controller.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../utils/constants/app_images.dart';

Widget profileImage(SignUpController controller) {
  return Stack(
    children: [
      InkWell(
        onTap: controller.getProfileImage,
        child: CircleAvatar(
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
                    : const CommonImage(imageSrc: AppImages.camera, size: 68),
          ),
        ),
      ),
    ],
  );
}
