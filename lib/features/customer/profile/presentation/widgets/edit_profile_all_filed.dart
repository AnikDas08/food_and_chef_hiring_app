import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_phone_number_text_filed.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../controller/profile_controller.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';

class EditProfileAllFiled extends StatelessWidget {
  const EditProfileAllFiled({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Full Name ─────────────────────────────────────────────────────
        const CommonText(
          text: AppString.fullName,
          fontWeight: FontWeight.w600,
          bottom: 14,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.nameController,
          validator: OtherHelper.validator,
          hintText: AppString.fullName,
        ),

        // ── Phone Number ──────────────────────────────────────────────────
        const CommonText(
          text: AppString.phoneNumber,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
        ),
        // In EditProfileAllFiled, replace the phone field section:
        Obx(() => CommonPhoneNumberTextFiled(
          controller: controller.numberController,
          initialCountryCode: controller.savedCountryIsoCode.value,
          onChanged: (phone) => controller.onPhoneChanged(phone),
          countryChange: (country) => controller.onCountryChanged(country), // ✅
        )),

        // ── Linked Accounts ───────────────────────────────────────────────
        /*CommonText(
          text: "Link Account".toUpperCase(),
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: const Color(0xff777777),
          top: 28,
          bottom: 8,
        ),
        12.height,

        // Reactive linked accounts list
        Obx(() {
          if (controller.linkAccounts.isEmpty) {
            return const CommonText(
              text: "No linked accounts found",
              fontSize: 12,
              color: Colors.grey,
            );
          }
          return Column(
            children: controller.linkAccounts.map((account) {
              String type = account['type'] ?? "social";
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xffF9F9F9),
                        shape: BoxShape.circle,
                      ),
                      child: CommonImage(
                        imageSrc: type == 'google'
                            ? AppIcons.google
                            : AppIcons.google,
                        width: 24.sp,
                        height: 24.sp,
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text:
                            "${type[0].toUpperCase()}${type.substring(1).toLowerCase()}",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff272727),
                          ),
                          CommonText(
                            text: account['email'] ?? "",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff777777),
                            top: 2,
                          ),
                        ],
                      ),
                    ),
                    // Disconnect button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xffF2F2F2),
                      ),
                      child: const CommonText(
                        text: "Disconnect",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),*/

        // ── Account Action ────────────────────────────────────────────────
        const CommonText(
          text: 'ACCOUNT ACTION',
          fontSize: 12,
          color: Color(0xff777777),
          top: 28,
          bottom: 16,
        ),

        // Delete Account row — calls showDeleteAccountPopup()
        InkWell(
          onTap: controller.showDeleteAccountPopup,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            height: 60.h,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.trash,
                    color: Color(0xffFF3C3C)),
                const CommonText(
                  text: AppString.deleteAccount,
                  color: Color(0xffFF3C3C),
                  fontWeight: FontWeight.w600,
                  left: 4,
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_outlined, size: 16.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}