import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/customer/home/presentation/controller/home_controller.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../config/route/app_routes.dart';
import '../../../../common/notifications/presentation/controller/notifications_controller.dart';

AppBar homeAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    actionsPadding: EdgeInsets.zero,
    title: Row(
      children: [
        Expanded(
          child: GetBuilder<HomeController>(
            builder: (controller) => GestureDetector(
              onTap: () async {
                await Get.toNamed(
                  AppRoutes.addressScreen,
                  arguments: {
                    'isLoading': true,
                  },
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.yourLocation,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    bottom: 2,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xffA7A7A7),
                        size: 20,
                      ),

                      // ✅ Show loader while fetching, address once ready
                      /*if (controller.isLoadingLocation)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xffFD713F),
                            ),
                          ),
                        )
                      else*/
                        Flexible(
                          child: Obx(
                            ()=> CommonText(
                              text: controller.defaultAddress.value.isEmpty
                                  ? "Fetching location..."
                                  : controller.defaultAddress.value,
                              color: Color(0xff272727),
                              fontWeight: FontWeight.w500,
                              left: 4,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      GetBuilder<NotificationsController>(
        // Ensure the controller is initialized so the badge shows immediately
        init: NotificationsController(),
        builder: (controller) {
          return InkWell(
            onTap: ()async{
              //controller.readAllNotification();
              Get.toNamed(AppRoutes.notifications);
            },
            child: Badge(
              // Use the unreadCount from the controller
              label: Obx(
                    () => Text(
                  controller.unreadCount.value > 99
                      ? "99+"
                      : "${controller.unreadCount.value}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              // Only show badge if count is greater than 0
              isLabelVisible: controller.unreadCount.value > 0,
              backgroundColor: Colors.red,
              child: Container(
                padding: EdgeInsets.all(8.sp),
                decoration: const BoxDecoration(
                  color: Color(0xffF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: CommonImage(imageSrc: AppIcons.notification),
              ),
            ),
          );
        },
      ),
      12.width,
      GestureDetector(
        onTap: (){
          Get.toNamed(AppRoutes.cart,arguments: "cart");
        },
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            shape: BoxShape.circle,
          ),
          child: CommonImage(imageSrc: AppIcons.basket),
        ),
      ),
      12.width,
    ],
  );
}
