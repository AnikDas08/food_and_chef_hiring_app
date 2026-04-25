// import 'package:cupertino_native/cupertino_native.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:new_untitled/component/text/common_text.dart';
// import 'package:new_untitled/features/customer/home/presentation/controller/home_controller.dart';
// import 'package:new_untitled/utils/constants/app_icons.dart';
// import 'package:new_untitled/utils/constants/app_string.dart';
// import 'package:new_untitled/utils/extensions/extension.dart';
//
// import '../../../../../config/route/app_routes.dart';
// import '../../../../common/notifications/presentation/controller/notifications_controller.dart';

//
// AppBar homeAppbar() {
//   return AppBar(
//     systemOverlayStyle: SystemUiOverlayStyle.dark,
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     automaticallyImplyLeading: false,
//     actionsPadding: EdgeInsets.zero,
//     flexibleSpace: LiquidGlassLayer(
//       child: LiquidGlass(
//         shape: LiquidRoundedSuperellipse(borderRadius: 0),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.white.withOpacity(0.2),
//                 Colors.white.withOpacity(0.05),
//               ],
//             ),
//             border: Border(
//               bottom: BorderSide(
//                 color: Colors.black.withOpacity(0.05),
//                 width: 0.5,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//     title: Row(
//       children: [
//         Expanded(
//           child: GetBuilder<HomeController>(
//             builder:
//                 (controller) => GestureDetector(
//                   onTap: () async {
//                     await Get.toNamed(
//                       AppRoutes.addressScreen,
//                       arguments: {'isLoading': true},
//                     );
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonText(
//                         text: AppString.yourLocation,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xff777777),
//                         bottom: 2,
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_rounded,
//                             color: Color(0xffA7A7A7),
//                             size: 20,
//                           ),
//
//                           // ✅ Show loader while fetching, address once ready
//                           /*if (controller.isLoadingLocation)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 4),
//                           child: SizedBox(
//                             width: 14,
//                             height: 14,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Color(0xffFD713F),
//                             ),
//                           ),
//                         )
//                       else*/
//                           Flexible(
//                             child: Obx(
//                               () => CommonText(
//                                 text:
//                                     controller.defaultAddress.value.isEmpty
//                                         ? "Fetching location..."
//                                         : controller.defaultAddress.value,
//                                 color: Color(0xff272727),
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14.sp,
//                                 left: 4,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//           ),
//         ),
//       ],
//     ),
//     actions: [
//       GetBuilder<NotificationsController>(
//         // Ensure the controller is initialized so the badge shows immediately
//         init: NotificationsController(),
//         builder: (controller) {
//           return InkWell(
//             onTap: () async {
//               //controller.readAllNotification();
//               Get.toNamed(AppRoutes.notifications);
//             },
//             child: Badge(
//               // Use the unreadCount from the controller
//               label: Obx(
//                 () => Text(
//                   controller.unreadCount.value > 99
//                       ? "99+"
//                       : "${controller.unreadCount.value}",
//                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                 ),
//               ),
//               // Only show badge if count is greater than 0
//               isLabelVisible: controller.unreadCount.value > 0,
//               backgroundColor: Colors.red,
//               child: Container(
//                 padding: EdgeInsets.all(8.sp),
//                 decoration: const BoxDecoration(
//                   color: Color(0xffF2F2F2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: SvgPicture.asset(AppIcons.notification),
//               ),
//             ),
//           );
//         },
//       ),
//       12.width,
//       Container(
//         height: 40.r,
//         width: 40.r,
//         decoration: const BoxDecoration(
//           color: Color(0xffF2F2F2),
//           shape: BoxShape.circle,
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             CNIcon(
//               symbol: CNSymbol(
//                 "basket",
//                 color: const Color(0xff272727),
//               ),
//               size: 24,
//             ),
//             Positioned.fill(
//               child: GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: () {
//                   Get.toNamed(AppRoutes.cart, arguments: "cart");
//                 },
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.transparent,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       12.width,
//     ],
//   );
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/other_widgets/app_bar_opacity.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';
import '../controller/home_controller.dart';

AppBar homeAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    shadowColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,

    title: GetBuilder<HomeController>(
      builder: (controller) {
        return GestureDetector(
          onTap:
              () => Get.toNamed(
                AppRoutes.addressScreen,
                arguments: {'isLoading': true},
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonText(
                text: AppString.yourLocation,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                bottom: 2,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xff272727),
                    size: 20,
                  ),

                  Flexible(
                    child: Obx(
                      () => CommonText(
                        text:
                            controller.defaultAddress.value.isEmpty
                                ? 'Fetching location...'
                                : controller.defaultAddress.value,
                        color: const Color(0xff272727),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        left: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
    flexibleSpace: appBarOpacity(),
    actions: [
      LiquidGlassLayer(
        child: LiquidGlass(
          shape: const LiquidRoundedSuperellipse(borderRadius: 30),
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            child: Container(
              width: 40.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
              ),
              child:
                  const Icon(
                    CupertinoIcons.bell,
                    color: Colors.black,
                    size: 24,
                  ).center,
            ),
          ),
        ),
      ),
      12.width,
      LiquidGlassLayer(
        child: LiquidGlass(
          shape: const LiquidRoundedSuperellipse(borderRadius: 30),
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.cart, arguments: 'cart'),
            child: Container(
              width: 40.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
              ),
              child:
                  const CommonImage(
                    imageSrc: AppIcons.basketSvg,
                    imageColor: Colors.black,
                  ).center,
            ),
          ),
        ),
      ),
      16.width,
    ],
  );
}
