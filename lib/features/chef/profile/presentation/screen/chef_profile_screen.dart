import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
import '../../../../../utils/log/app_log.dart';
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
        flexibleSpace: appBarOpacity(),
        title: const CommonText(
          text: AppString.myProfile,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Color(0xff272727),
        ),
      ),

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
                    color: const Color(0xffF2F2F2),
                    border: Border.all(color: const Color(0xffF1F1F1)),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        final profile =
                            Get.find<ChefHomeController>().chefProfile.value;
                        return Row(
                          children: [
                            CommonImage(
                              imageSrc:
                              (profile?.image.isNotEmpty ?? false)
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
                                    color: const Color(0xff272727),
                                  ),
                                  CommonText(
                                    text: profile?.email ?? '',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  margin: const EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.customers,
                        imageSize: 23,
                        title: AppString.seePublicProfile,
                        onTap:
                            () => {
                          appLog('id: ${LocalStorage.userId}'),
                          Get.toNamed(
                            AppRoutes.chefDetails,
                            arguments: LocalStorage.userId,
                          ),
                        },
                      ),
                    ],
                  ),
                ),

                const CommonText(
                  text: AppString.account,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 12,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
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
                          final profile =
                              Get.find<ChefHomeController>().chefProfile.value;
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
                        onTap: () {
                          Get.to(() => const ChefDocFlow());
                        },
                      ),

                      Item(
                        image: AppIcons.addressIcon,
                        title: AppString.updateChefLocation,
                        onTap: () {
                          Get.to(const ChefUpdateLocationScreen());
                        },
                      ),

                      Obx(
                            () => Row(
                          children: [

                            CommonImage(
                              imageSrc: AppIcons.notification,
                              size: 22,
                              imageColor: const Color(0xff272727),
                            ),

                            const CommonText(
                              text: AppString.notifications,
                              left: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff272727),
                            ),

                            const Spacer(),

                            Transform.scale(
                              scale: 0.75,
                              alignment: Alignment.centerRight,
                              child: switchButton(
                                value: controller.isNotification.value,
                                onTap: () => controller.notification(),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 14.h),
                      ),
                    ],
                  ),
                ),

                const CommonText(
                  text: AppString.other,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 12,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        icon: CupertinoIcons.question_circle,
                        title: AppString.contactSupport,
                        onTap: () {
                          Get.to(const HelpSupportScreen());
                        },
                      ),

                      Item(
                        icon: CupertinoIcons.info,
                        title: AppString.appVersion,
                        onTap: () {
                          Get.to(const AppInformationScreen());
                        },
                      ),

                    ],
                  ),
                ),

                const Item(
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
