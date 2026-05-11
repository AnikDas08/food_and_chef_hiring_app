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
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 60,
            titleSpacing: 0,
            title: const CommonText(
              text: AppString.accountSettings,
              fontSize: 24,
              fontWeight: FontWeight.w600,
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

                    const SizedBox(height: 14,),

                  const CommonText(
                      text: 'ACCOUNT DETAILS',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff999999),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          text: 'Email',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          top: 20,
                          bottom: 8,
                          color: Color(0xff272727),
                        ),
                        CommonTextField(
                          controller: controller.emailController,
                          hintText: 'Enter email',
                          keyboardType: TextInputType.emailAddress,
                          borderRadius: 12,
                        ),
                        const CommonText(
                          text: AppString.phoneNumber,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          top: 20,
                          bottom: 8,
                          color: Color(0xff272727),
                        ),
                        IntlPhoneField(
                          controller: controller.phoneController,
                          initialCountryCode: 'US',
                          decoration: InputDecoration(
                            hintText: 'Enter phone number',
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
                            ),
                            filled: true,
                            fillColor: const Color(0xffF2F2F2),
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 18.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF272727),
                          ),
                          dropdownTextStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF272727),
                          ),
                          flagsButtonPadding: EdgeInsets.only(left: 12.w),
                          onChanged: (phone) {
                            controller.phoneController.text = phone.number;
                            controller.selectedCountryCode = phone.countryCode;
                          },
                        ),
                        const CommonText(
                          text: 'ACCOUNT ACTION',
                          fontSize: 14, // ✅ Fix 1: was 12
                          fontWeight: FontWeight.w600,
                          color: Color(0xff999999),
                          top: 28,
                          bottom: 16,
                        ),
                        InkWell(
                          onTap: deletePopUp,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.delete,
                                  color: Color(0xff272727),
                                  size: 18,
                                ),
                                const CommonText(
                                  text: AppString.deleteAccount,
                                  color: Color(0xff272727),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  left: 12,
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 14.sp,
                                  color: const Color(0xff777777),
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
