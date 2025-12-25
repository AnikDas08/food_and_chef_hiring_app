import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import '../../../config/route/app_routes.dart';
import '../../../utils/log/app_log.dart';

List _list = [
  AppIcons.home,
  AppIcons.analytics,
  AppIcons.basket,
  AppIcons.chats,
  AppIcons.profile,
];

List _string = [
  AppString.home,
  AppString.analytics,
  AppString.bookings,
  AppString.chats,
  AppString.profile,
];

class ChefBottomBar extends StatelessWidget {
  final int currentIndex;

  const ChefBottomBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_list.length, (index) {
          return InkWell(
            onTap: () => onTap(index),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonImage(
                    imageSrc: _list[index],
                    size: 24,
                    imageColor:
                        index == currentIndex
                            ? Colors.black
                            : const Color(0xff777777),
                  ),
                  CommonText(
                    text: _string[index],
                    fontSize: 12,
                    top: 4,
                    fontWeight: FontWeight.w400,
                    color:
                        index == currentIndex
                            ? const Color(0xff272727)
                            : const Color(0xff777777),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void onTap(int index) async {
    appLog(currentIndex, source: "common bottombar");

    if (index == 0) {
      if (!(currentIndex == 0)) {
        Get.toNamed(AppRoutes.chefHome);
      }
    } else if (index == 1) {
      if (!(currentIndex == 1)) {
        if (LocalStorage.isChef) {
          Get.toNamed(AppRoutes.analytics);
        } else {
          Get.toNamed(AppRoutes.bookingHistory);
        }
      }
    } else if (index == 2) {
      if (!(currentIndex == 2)) {
        Get.toNamed(AppRoutes.chefBooking);
      }
    } else if (index == 3) {
      if (!(currentIndex == 3)) {
        Get.toNamed(AppRoutes.chat);
      }
    } else if (index == 4) {
      if (!(currentIndex == 4)) {
        Get.toNamed(AppRoutes.chefProfile);
      }
    }
  }
}
