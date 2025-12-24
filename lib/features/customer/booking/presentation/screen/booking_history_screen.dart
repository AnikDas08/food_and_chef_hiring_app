import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/booking_history_controller.dart';
import '../widgets/booking_item.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

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
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              shape: BoxShape.circle,
            ),
            child: CommonImage(imageSrc: AppIcons.basket),
          ),
        ],
      ),
      body: GetBuilder<BookingHistoryController>(
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
                      padding: EdgeInsets.zero,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return bookingItem();
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
      bottomNavigationBar: CommonBottomNavBar(currentIndex: 1),
    );
  }
}
