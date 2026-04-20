import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/features/chef/home/presentation/screen/App_Information_Screen.dart';
import 'package:new_untitled/features/customer/kitchen/presentation/screen/kitchen_setup_screen.dart';
import 'package:new_untitled/features/customer/profile/presentation/screen/kitchen/kitchen_equipment_screen.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/item.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../chef/profile/presentation/screen/help_and_Support_Screen.dart';
import '../controller/profile_controller.dart';
import '../../../../../../utils/constants/app_string.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
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
        ),
        title: const CommonText(
          text: AppString.myProfile,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Color(0xff272727),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [

            // ── Profile Header Card ───────────────────────────────────────
            Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2),
                border: Border.all(color: const Color(0xffF1F1F1)),
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Row(
                children: [
                  // Reactive profile image
                  Obx(() {
                    final src = controller.profileImage.value.startsWith('http')
                        ? controller.profileImage.value
                        : ApiEndPoint.imageUrl + controller.profileImage.value;
                    return CommonImage(
                      imageSrc: src,
                      size: 52,
                      fill: BoxFit.cover,
                      borderRadius: 50,
                    );
                  }),
                  12.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reactive name
                        Obx(() => CommonText(
                          text: controller.name.value,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff272727),
                        )),
                        // Reactive email
                        Obx(() => CommonText(
                          text: controller.email.value,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff777777),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Account Info ──────────────────────────────────────────────
            CommonText(
              text: AppString.accountInfo,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: const Color(0xff777777),
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
                    icon: CupertinoIcons.person,
                    title: AppString.editProfile,
                    onTap: () => Get.toNamed(AppRoutes.editProfile),
                  ),
                  Item(
                    icon: CupertinoIcons.location,
                    title: AppString.address,
                    onTap: () => Get.toNamed(AppRoutes.addressScreen),
                  ),
                  Item(
                    icon: CupertinoIcons.arrow_counterclockwise,
                    title: AppString.pastOrders,
                    onTap: () => Get.toNamed(AppRoutes.pastOrder),
                  ),
                ],
              ),
            ),

            // ── Management ────────────────────────────────────────────────
            CommonText(
              text: AppString.management,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: const Color(0xff777777),
              top: 28,
              bottom: 16,
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
                    icon: CupertinoIcons.heart_circle,
                    title: AppString.manageDietaryRestrictions,
                    onTap: () => Get.toNamed(AppRoutes.dietary),
                  ),
                  // Reactive isKitchen
                  Item(
                    icon: CupertinoIcons.list_number,
                    title: AppString.manageKitchenEquipment,
                    onTap: () {
                      if (controller.isKitchen.value) {
                        Get.to(() => const KitchenEquipmentScreen());
                      } else {
                        Get.to(() => const KitchenSetupScreen());
                      }
                    },
                  )
                ],
              ),
            ),

            // ── Other ─────────────────────────────────────────────────────
            CommonText(
              text: AppString.other,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: const Color(0xff777777),
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
                    onTap: (){
                      Get.to(HelpSupportScreen());
                    },
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

            // ── Sign Out ──────────────────────────────────────────────────
            Item(
              image: AppIcons.logout,
              color: const Color(0xffFF0000),
              imgColor: const Color(0xffFF0000),
              title: AppString.signOut,
              onTap: logOutPopUp,
              disableDivider: true,
              disableIcon: true,
            ),
          ],
        ),
      ),
    );
  }
}