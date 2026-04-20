import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controller/sign_up_chef_controller.dart';
import 'Cafe_set_cookin_garea_screen.dart';

class CafeSetupProfileScreen extends StatefulWidget {
  const CafeSetupProfileScreen({super.key});

  @override
  State<CafeSetupProfileScreen> createState() => _CafeSetupProfileScreenState();
}

class _CafeSetupProfileScreenState extends State<CafeSetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  File? _profileImage;

  Future<void> _pickImage() async {

    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }

  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _experienceController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: const Color(0xFF272727),
                    ),
                  ),
                ),
              ),
            ),

            // ── Scrollable Body ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Setup Profile",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF272727),
                          letterSpacing: -0.5,
                        ),
                      ),
                      8.verticalSpace,

                      // Subtitle
                      Text(
                        "Set up your profile by adding your name, experience, and about yourself. This helps us personalize your experience!",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF777777),
                          height: 1.5,
                        ),
                      ),
                      24.verticalSpace,

                      // ── Profile Image ──
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8E8E8),
                                image: _profileImage != null
                                    ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: _profileImage == null
                                  ? Icon(
                                Icons.person,
                                size: 40.sp,
                                color: const Color(0xFFAAAAAA),
                              )
                                  : null,
                            ),

                            // Edit Icon
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 26.w,
                                height: 26.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 14.sp,
                                  color: const Color(0xFF272727),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      28.verticalSpace,

                      Text(
                        "PERSONAL DETAILS",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                          letterSpacing: 1.2,
                        ),
                      ),


                      16.verticalSpace,

                      // // Full Name
                      // _buildLabel("Full Name"),
                      // 8.verticalSpace,
                      // _buildTextField(
                      //   controller: _fullNameController,
                      //   hint: "Enter your full name",
                      //   validator: (val) =>
                      //   val == null || val.isEmpty ? "Required" : null,
                      // ),
                      20.verticalSpace,
                      _buildLabel("Experience"),
                      8.verticalSpace,
                      _buildTextField(
                        controller: _experienceController,
                        hint: "Years",
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                      ),
                      20.verticalSpace,

                      // About
                      _buildLabel("About"),
                      8.verticalSpace,
                      _buildTextField(
                        controller: _aboutController,
                        hint: "Write something about yourself...",
                        maxLines: 5,
                        validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                      ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final controller = SignUpChefController.instance;
                      controller.tempAbout = _aboutController.text.trim();
                      controller.tempExperience = _experienceController.text.trim();
                      controller.tempImagePath = _profileImage?.path;

                      Get.to(() => const CafeSetCookingAreaScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF272727),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF272727),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFFBBBBBB),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Color(0xFF1C1C1C),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}