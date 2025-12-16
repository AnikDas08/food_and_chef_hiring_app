import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/bottom_nav_bar/chef_bottom_bar.dart';
import 'package:new_untitled/component/bottom_nav_bar/common_bottom_bar.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/chef_booking_controller.dart';
import '../widgets/chef_booking_item.dart';

class ChefBookingScreen extends StatelessWidget {
  const ChefBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CommonText(
          text: AppString.upcomingBookings,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              shape: BoxShape.circle,
            ),
            child: CommonImage(imageSrc: AppIcons.basket),
          ),
        ],
      ),
      body: GetBuilder<ChefBookingController>(
        builder:
            (controller) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    spacing: 8.w,
                    children: List.generate(3, (index) {
                      String value = controller.bookingHistoryList[index];
                      return InkWell(
                        onTap: () {
                          controller.onChangeBookingHistory(value);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                controller.selectedBookingHistory == value
                                    ? Color(0xff272727)
                                    : Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: CommonText(
                            text: value,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                controller.selectedBookingHistory == value
                                    ? Colors.white
                                    : Color(0xff272727),
                          ),
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return chefBookingItem();
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
      bottomNavigationBar: ChefBottomBar(currentIndex: 2),
    );
  }
}
