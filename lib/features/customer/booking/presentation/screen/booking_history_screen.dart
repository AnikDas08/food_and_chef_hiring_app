import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/other_widgets/common_loader.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/booking_history_controller.dart';
import '../widgets/booking_item.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingHistoryController>(
      builder:
          (controller) => Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,

              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              flexibleSpace: appBarOpacity(),
              title: CommonText(
                text: AppString.upcomingBookings,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(38.h),
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.bookingHistoryList.length,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (context, index) {
                        String value = controller.bookingHistoryList[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child:
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  controller.onChangeBookingHistory(value);
                                },
                                child: LiquidGlassLayer(
                                  child: LiquidGlass(
                                    shape: LiquidRoundedSuperellipse(
                                      borderRadius: 30.r,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),

                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withValues(alpha: 0.2),
                                        ),
                                        color:
                                            controller.selectedBookingHistory ==
                                                    value
                                                ? Color(0xff272727)
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          30.sp,
                                        ),
                                      ),
                                      child: CommonText(
                                        text: value,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            controller.selectedBookingHistory ==
                                                    value
                                                ? Colors.white
                                                : Color(0xff272727),
                                      ),
                                    ),
                                  ),
                                ),
                              ).center,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0, top: 6),
              child:
                  controller.isLoading
                      ? CommonLoader()
                      : ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return bookingItem();
                        },
                      ),
            ),
            // bottomNavigationBar: CommonBottomNavBar(currentIndex: 1),
          ),
    );
  }
}
