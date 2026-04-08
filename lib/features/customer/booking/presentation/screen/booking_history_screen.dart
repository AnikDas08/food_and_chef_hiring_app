// lib/features/booking_history/view/booking_history_screen.dart

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
      init: BookingHistoryController(),
      builder: (controller) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          flexibleSpace: appBarOpacity(),
          title: const CommonText(
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
                    final isSelected =
                        controller.selectedBookingHistory == value;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => controller.onChangeBookingHistory(value),
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
                                color: isSelected
                                    ? const Color(0xff272727)
                                    : Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(30.sp),
                              ),
                              child: CommonText(
                                text: value,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xff272727),
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
        body: SafeArea(child: _buildBody(controller)),
      ),
    );
  }

  Widget _buildBody(BookingHistoryController controller) {
    if (controller.isLoading) {
      return const CommonLoader();
    }

    if (controller.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            CommonText(
              text: controller.errorMessage,
              fontSize: 14,
              color: const Color(0xff777777),
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.fetchOrders(isRefresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff272727),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const CommonText(
                text: "Retry",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (controller.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            CommonText(
              text: "No bookings found",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
            const SizedBox(height: 8),
            CommonText(
              text: "You don't have any ${controller.selectedBookingHistory.toLowerCase()} bookings.",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xff777777),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 100 &&
            !controller.isPaginationLoading) {
          controller.loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => controller.fetchOrders(isRefresh: true),
        color: const Color(0xff272727),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
          itemCount: controller.orders.length +
              (controller.isPaginationLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.orders.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return bookingItem(controller.orders[index]);
          },
        ),
      ),
    );
  }
}