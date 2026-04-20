import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/button/switch_button.dart';
import 'package:new_untitled/features/chef/home/presentation/screen/App_Information_Screen.dart';
import 'package:new_untitled/features/chef/profile/presentation/screen/chef_Update_Location_Screen.dart';
import 'package:new_untitled/features/chef/profile/presentation/screen/help_and_Support_Screen.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/other_widgets/item.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../../../../common/auth/signup_chef/presentation/Widget/ChefDocFlowState.dart';
import '../../../../common/auth/signup_chef/presentation/screen/BankManagementPage.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';
import '../controller/chef_profile_controller.dart';

class ChefProfileScreen extends StatelessWidget {
  const ChefProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ), // ← এই bracket টা missing ছিল
        title: const CommonText(
          text: AppString.myProfile,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Color(0xff272727),
        ),
      ),
      /// Body Section Starts here
      body: GetBuilder<ChefProfileController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView(
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
                      Obx(() {
                        final profile = Get.find<ChefHomeController>().chefProfile.value;
                        return Row(
                          children: [
                            CommonImage(
                              imageSrc: (profile?.image.isNotEmpty ?? false)
                                  ? profile!.image
                                  : AppImages.image3,
                              height: 52,
                              width: 52,
                              fill: BoxFit.cover,
                              borderRadius: 50,
                            ),
                            12.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: profile?.originalName ?? 'Unknown',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                  CommonText(
                                    text: profile?.email ?? '',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      //16.height,
                      // CommonTextField(
                      //   keyboardType: TextInputType.none,
                      //   borderColor: Color(0xffF1F1F1),
                      //   borderRadius: 8,
                      //   fillColor: Color(0xffFDFDFD),
                      //   paddingVertical: 14,
                      //   prefixIcon: Padding(
                      //     padding: const EdgeInsets.only(left: 8.0),
                      //     child: CommonImage(
                      //       imageSrc: controller.selectedProfile['image'],
                      //       size: 30,
                      //     ),
                      //   ),
                      //   hintText: controller.selectedProfile['name'],
                      //   hintTextColor: Color(0xff272727),
                      //   suffixIcon: ProfileList(
                      //     items: controller.profileOptions,
                      //     selectedItem: controller.selectedProfile,
                      //     onTap: controller.onChangeProfile,
                      //   ),
                      // ),
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
                        imageSize: 23,
                        title: AppString.seePublicProfile,
                        onTap: () => {
                          print("id: 😊😊😊😊😊😊😊${LocalStorage.userId}"),
                          Get.toNamed(AppRoutes.chefDetails, arguments: LocalStorage.userId)
                        },
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
                      Item(
                        image: AppIcons.card,
                        icon: CupertinoIcons.creditcard,
                        title: AppString.paymentMethods,
                        onTap: () => Get.toNamed(AppRoutes.chefPayment),
                      ),

                      Item(
                        image: AppIcons.card,
                        icon: CupertinoIcons.arrow_swap,
                        title: AppString.bankManagement,
                        onTap: () {
                          final profile = Get.find<ChefHomeController>().chefProfile.value;
                          final stripeUrl = profile?.stripeLoginLink;

                          if (stripeUrl != null && stripeUrl.isNotEmpty) {
                            Get.to(() => StripeWebViewPage(url: stripeUrl));
                          } else {
                            Get.to(() => const BankManagementPage());
                          }
                        },
                      ),


                      Item(
                        image: AppIcons.kitchen,
                        title: AppString.menuItems,
                        onTap: () => Get.toNamed(AppRoutes.menu),
                      ),

                      Item(
                        icon: CupertinoIcons.person,
                        title: AppString.accountSettings,
                        onTap: () => Get.toNamed(AppRoutes.accountSetting),
                      ),

                      Item(
                        image: AppIcons.about,
                        title: AppString.uploadyourrequireddocuments,
                        onTap: (){

                          Get.to(() => const ChefDocFlow());


                        },

                      ),


                      Item(
                        image: AppIcons.addressIcon,
                        title: AppString.updateChefLocation,
                        onTap: (){

                          Get.to(ChefUpdateLocationScreen());

                        },

                      ),

                      14.height,
                      Obx(
                            () => Row(
                          children: [
                            Icon(CupertinoIcons.bell),
                            CommonText(
                              text: AppString.notifications,
                              left: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            Spacer(),
                            switchButton(
                              value: controller.isNotification.value,
                              onTap: () => controller.notification(),
                            ),
                          ],
                        ),
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
                      InkWell(
                        child: Item(
                          icon: CupertinoIcons.question_circle,
                          title: AppString.contactSupport,
                          onTap: (){

                            Get.to(HelpSupportScreen());

                          },
                        ),
                      ),

                      Item(
                        icon: CupertinoIcons.info,
                        title: AppString.appVersion,
                        onTap: (){

                          Get.to(AppInformationScreen());

                        },
                      ),
                    ],
                  ),
                ),

                Item(
                  image: AppIcons.logout,
                  color: Color(0xffFF0000),
                  imgColor: Color(0xffFF0000),
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
    );
  }
}
