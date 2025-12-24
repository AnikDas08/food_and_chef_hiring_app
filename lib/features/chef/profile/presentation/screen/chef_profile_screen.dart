import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/bottom_nav_bar/chef_bottom_bar.dart';
import 'package:new_untitled/component/button/switch_button.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/item.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../../../../customer/profile/presentation/widgets/profile_list.dart';
import '../controller/chef_profile_controller.dart';

class ChefProfileScreen extends StatelessWidget {
  const ChefProfileScreen({super.key});

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
      ),

      /// Body Section Starts here
      body: GetBuilder<ChefProfileController>(
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

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  margin: EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.customers,
                        title: AppString.seePublicProfile,
                        onTap: () => Get.toNamed(AppRoutes.chefPublicProfile),
                      ),
                    ],
                  ),
                ),

                /// Edit Profile item here
                CommonText(
                  text: AppString.account,
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
                        image: AppIcons.chefIcon,
                        title: AppString.profileSettings,
                        imageSize: 24,
                        onTap: () => Get.toNamed(AppRoutes.chefEditProfile),
                      ),

                      /// Setting item here
                      Item(
                        image: AppIcons.date,
                        title: AppString.availability,
                        imageSize: 24,
                        onTap: () => Get.toNamed(AppRoutes.availability),
                      ),
                      // Item(
                      //   image: AppIcons.card,
                      //   title: AppString.paymentMethods,
                      //   onTap: () => Get.toNamed(AppRoutes.paymentMethod),
                      // ),
                      Item(
                        image: AppIcons.kitchen,
                        title: AppString.menuItems,
                        onTap: () => Get.toNamed(AppRoutes.menu),
                      ),

                      Item(
                        image: AppIcons.user,
                        title: AppString.accountSettings,
                        onTap: () => Get.toNamed(AppRoutes.accountSetting),
                      ),
                      14.height,
                      Row(
                        children: [
                          CommonImage(imageSrc: AppIcons.notification),
                          CommonText(
                            text: AppString.notifications,
                            left: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                          Spacer(),

                          switchButton(
                            value: controller.isNotification,
                            onTap: controller.notification,
                          ),
                        ],
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
                        title: AppString.contactSupport,
                      ),

                      Item(image: AppIcons.about, title: AppString.appVersion),

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
      bottomNavigationBar: const ChefBottomBar(currentIndex: 4),
    );
  }
}
