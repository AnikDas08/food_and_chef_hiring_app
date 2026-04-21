import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/extensions/extension.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/help_and_Support_controller.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HelpSupportController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: const CommonImage(
                imageSrc: AppIcons.backIcon,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: 'Issue Title',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            10.height,
            _buildTextField(
              controller: ctrl.titleController,
              hintText: 'Enter Your Issue Title Here',
            ),
            20.height,
            const CommonText(
              text: 'Description',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            10.height,
            _buildTextField(
              controller: ctrl.descriptionController,
              hintText: 'Enter Your Description Here..',
              maxLines: 6,
            ),
            20.height,

            // Attach File Button
            Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFEEEEEE), width: 1.2),
              ),
              child: GestureDetector(
                onTap: () => _showPickerBottomSheet(context, ctrl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_file_rounded,
                        size: 18.r, color: AppColors.primaryColor),
                    6.width,
                    const CommonText(
                      text: 'Attach File',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),

            // Selected images
            GetBuilder<HelpSupportController>(
              builder: (c) {
                if (c.selectedFiles.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: [
                    16.height,
                    SizedBox(
                      height: 90.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: c.selectedFiles.length,
                        separatorBuilder: (_, __) => 10.width,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showFullImage(context, c.selectedFiles[index]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.file(
                                    c.selectedFiles[index],
                                    width: 80.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => c.deleteFile(index),
                                  child: Container(
                                    padding: EdgeInsets.all(2.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close,
                                        size: 12.r, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            20.height,

            // Submit Button
            GetBuilder<HelpSupportController>(
              builder: (c) {
                return SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: c.isLoading ? null : c.submitSupport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: c.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const CommonText(
                      text: 'Submit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),

            20.height,
          ],
        ),
      ),
    );
  }

  void _showPickerBottomSheet(
      BuildContext context, HelpSupportController ctrl) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            12.height,
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
              title: const CommonText(
                text: 'Pick from Gallery',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.pop(context);
                ctrl.pickImage(ImageSource.gallery);
              },
            ),
            12.height,
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(file, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontSize: 13.sp, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 13.sp, color: Colors.black38),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        ),
      ),
    );
  }
}