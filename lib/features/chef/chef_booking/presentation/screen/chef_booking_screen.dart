import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/bottom_nav_bar/chef_bottom_bar.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
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
      ),
      body: GetBuilder<ChefBookingController>(
        builder:
            (controller) => Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.bookingHistoryList.length,
                      itemBuilder: (context, index) {
                        String value = controller.bookingHistoryList[index];
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            controller.onChangeBookingHistory(value);
                          },
                          child:
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  color:
                                      controller.selectedBookingHistory == value
                                          ? Color(0xff272727)
                                          : Color(0xffF2F2F2),
                                  borderRadius: BorderRadius.circular(10.sp),
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
                              ).center,
                        );
                      },
                    ),
                  ),
                  8.height,
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
