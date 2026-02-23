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
import '../controller/chef_home_controller.dart';


class ChefHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChefHomeAppBar({super.key});

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final name = c.chefProfile.value?.name ?? '';
                  return CommonText(
                    text: "Hello, $name 👋",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  );
                }),
                CommonText(
                  text: "Let's get cooking!",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff777777),
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
              shape: LiquidRoundedSuperellipse(borderRadius: 30),
              child: Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.07),
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.bell,
                  color: Color(0xff272727),
                ),
              ),
            ),
          ),
        ),
        12.width,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}