import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:new_untitled/features/chef/profile/presentation/controller/chef_profile_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../widgets/delete_pop_up.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});
  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChefProfileController>().loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefProfileController>(
      builder: (controller) {
        return Scaffold(
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
                  child: CommonImage(
                    imageSrc: AppIcons.backIcon,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: AppString.accountSettings,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      bottom: 28,
                    ),
                    CommonText(
                      text: "ACCOUNT DETAILS",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff777777),
                      bottom: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Email ──
                        const CommonText(
                          text: "Email",
                          fontWeight: FontWeight.w600,
                          top: 20,
                          bottom: 8,
                        ),
                        CommonTextField(
                          controller: controller.emailController,
                          hintText: "Enter email",
                          keyboardType: TextInputType.emailAddress,
                        ),

                        // ── Phone ──
                        const CommonText(
                          text: AppString.phoneNumber,
                          fontWeight: FontWeight.w600,
                          top: 20,
                          bottom: 8,
                        ),
                        IntlPhoneField(
                          controller: controller.phoneController,
                          initialCountryCode: 'US',
                          decoration: InputDecoration(
                            hintText: "Enter phone number",
                            filled: true,
                            fillColor: const Color(0xFFF7F7F7),
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
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF272727)),
                          dropdownTextStyle: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF272727)),
                          flagsButtonPadding: EdgeInsets.only(left: 12.w),
                          onChanged: (phone) {
                            controller.phoneController.text = phone.number;
                            controller.selectedCountryCode = phone.countryCode;
                          },
                        ),

                        // ── Account Action ──
                        CommonText(
                          text: "ACCOUNT ACTION",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff777777),
                          top: 28,
                          bottom: 16,
                        ),
                        InkWell(
                          onTap: deletePopUp,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.delete,
                                  color: Color(0xff343330),
                                ),
                                CommonText(
                                  text: AppString.deleteAccount,
                                  color: Color(0xff343330),
                                  fontWeight: FontWeight.w600,
                                  left: 4,
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    60.height,
                    CommonButton(
                      titleText: AppString.saveChanges,
                      isLoading: controller.isLoadingUpdate,
                      onTap: () {
                        controller.updateContactInfo();
                      },
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