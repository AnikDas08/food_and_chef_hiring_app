import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/services/storage/storage_keys.dart';
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                12.height,
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xffF1F1F1)),
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
                        paddingVertical: 14,
                        fillColor: Colors.white,
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

                Item(
                  image: AppIcons.user,
                  title: AppString.editProfile,
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                ),

                /// Setting item here
                Item(
                  image: AppIcons.addressIcon,
                  title: AppString.address,
                  onTap: () => Get.toNamed(AppRoutes.setting),
                ),
                Item(
                  image: AppIcons.card,
                  title: AppString.paymentMethods,
                  onTap: () => Get.toNamed(AppRoutes.setting),
                ),
                Item(
                  image: AppIcons.past,
                  title: AppString.paymentMethods,
                  onTap: () => Get.toNamed(AppRoutes.setting),
                ),

                /// Log Out item here
                Item(
                  icon: Icons.logout,
                  title: AppString.logOut,
                  onTap: logOutPopUp,
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
