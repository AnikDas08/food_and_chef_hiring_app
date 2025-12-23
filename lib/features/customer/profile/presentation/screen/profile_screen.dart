import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/item.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/profile_controller.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../widgets/profile_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts here
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        centerTitle: false,
        title: const CommonText(
          text: AppString.myProfile,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Color(0xff272727),
        ),

        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.all(8.sp),
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              shape: BoxShape.circle,
            ),
            child: CommonImage(imageSrc: AppIcons.basket),
          ),
        ],
      ),

      /// Body Section Starts here
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                12.height,
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    border: Border.all(color: Color(0xffF1F1F1)),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CommonImage(
                            imageSrc: AppImages.image3,
                            size: 52,
                            fill: BoxFit.fill,
                            borderRadius: 50,
                          ),
                          12.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text: "Darren Monarch",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff272727),
                                ),
                                CommonText(
                                  text: "darrenmonarch@gmail.com",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff777777),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      CommonTextField(
                        keyboardType: TextInputType.none,
                        borderColor: Color(0xffF1F1F1),
                        borderRadius: 8,
                        fillColor: Color(0xffFDFDFD),
                        paddingVertical: 14,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CommonImage(
                            imageSrc: controller.selectedProfile['image'],
                            size: 30,
                          ),
                        ),
                        hintText: controller.selectedProfile['name'],
                        hintTextColor: Color(0xff272727),
                        suffixIcon: ProfileList(
                          items: controller.profileOptions,
                          selectedItem: controller.selectedProfile,
                          onTap: controller.onChangeProfile,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Edit Profile item here
                CommonText(
                  text: AppString.accountInfo,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 12,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.user,
                        title: AppString.editProfile,
                        onTap: () => Get.toNamed(AppRoutes.editProfile),
                      ),

                      /// Setting item here
                      Item(
                        image: AppIcons.addressIcon,
                        title: AppString.address,
                        onTap: () => Get.toNamed(AppRoutes.addressScreen),
                      ),
                      Item(
                        image: AppIcons.card,
                        title: AppString.paymentMethods,
                        onTap: () => Get.toNamed(AppRoutes.paymentMethod),
                      ),
                      Item(
                        image: AppIcons.past,
                        title: AppString.pastOrders,
                        onTap: () => Get.toNamed(AppRoutes.pastOrder),
                      ),
                    ],
                  ),
                ),
                CommonText(
                  text: AppString.management,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 16,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.manage,
                        title: AppString.manageDietaryRestrictions,
                      ),

                      /// Setting item here
                      Item(
                        image: AppIcons.kitchen,
                        title: AppString.manageKitchenEquipment,
                      ),
                    ],
                  ),
                ),

                CommonText(
                  text: AppString.other,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 12,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.contact,
                        horizontal: 4,
                        title: AppString.contactSupport,
                      ),

                      Item(
                        image: AppIcons.about,
                        horizontal: 4,
                        title: AppString.appVersion,
                      ),

                      /// Log Out item here
                    ],
                  ),
                ),

                Item(
                  image: AppIcons.logout,
                  color: Color(0xffFF0000),
                  title: AppString.signOut,
                  onTap: logOutPopUp,
                  disableDivider: true,
                  disableIcon: true,
                ),
              ],
            ),
          );
        },
      ),

      /// Bottom Navigation Bar Section Starts here
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 4),
    );
  }
}
