import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../common/notifications/presentation/controller/notifications_controller.dart';
import '../controller/chef_home_controller.dart';

class ChefHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const                                                                                                                             ChefHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChefHomeController>();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: false,
      flexibleSpace: appBarOpacity(),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final name = c.chefProfile.value?.originalName ?? '';
                  return CommonText(
                    text: 'Hello, $name 👋',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  );
                }),

                SizedBox(height: 4.h,),

                const CommonText(
                  text: "Let's get cooking!",
                  fontSize: 14,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                ),

                SizedBox(height: 4,)
              ],
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.notifications),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              LiquidGlassLayer(
                child: LiquidGlass(
                  shape: const LiquidRoundedSuperellipse(borderRadius: 30),
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.07),
                      ),
                    ),
                    child: const Icon(CupertinoIcons.bell, color: Color(0xff272727)),
                  ),
                ),
              ),

              Obx(() {
                if (!Get.isRegistered<NotificationsController>()) {
                  return const SizedBox.shrink();
                }
                final count =
                    Get.find<NotificationsController>().unreadCount.value;
                if (count == 0) return const SizedBox.shrink();
                return Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: EdgeInsets.all(4.sp),
                    decoration: const BoxDecoration(
                      color: Color(0xffFF3B30),
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18.w,
                      minHeight: 18.w,
                    ),
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        12.width,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

AppBar chefHomeAppBar() {
  return AppBar(
    title: const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: 'Hello, Javier 👋',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonText(
                text: "Let's get cooking!",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                left: 4,
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      InkWell(
        onTap: () => Get.toNamed(AppRoutes.notifications),
        child: LiquidGlassLayer(
          child: LiquidGlass(
            shape: const LiquidRoundedSuperellipse(borderRadius: 30),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
              ),
              child: const Icon(CupertinoIcons.bell, color: Color(0xff272727)),
            ),
          ),
        ),
      ),
      12.width,
    ],
  );
}
