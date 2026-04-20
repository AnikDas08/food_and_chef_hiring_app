import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/other_widgets/common_loader.dart';

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
      builder:
          (controller) => Scaffold(
            // This MUST be true for the glass effect to see content behind it
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              flexibleSpace: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.05),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: const CommonText(
                text: AppString.upcomingBookings,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50.h),
                child: _buildCategoryTabs(controller),
              ),
            ),
            body: _buildBody(controller),
          ),
    );
  }

  Widget _buildCategoryTabs(BookingHistoryController controller) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.only(bottom: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.bookingHistoryList.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          String value = controller.bookingHistoryList[index];
          final isSelected = controller.selectedBookingHistory == value;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InkWell(
              onTap: () => controller.onChangeBookingHistory(value),
              child: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 30.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 8.h,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xff272727)
                              : Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: CommonText(
                      text: value,
                      fontSize: 12.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.white : const Color(0xff272727),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BookingHistoryController controller) {
    if (controller.isLoading) return const CommonLoader();

    return RefreshIndicator(
      onRefresh: () => controller.fetchOrders(isRefresh: true),
      // Displacement pushes the spinner down so it's not hidden by the AppBar
      displacement: 100.h,
      child: ListView.builder(
        // Padding top must be enough to clear the AppBar height (approx 140)
        padding: EdgeInsets.fromLTRB(16.w, 140.h, 16.w, 100.h),
        itemCount:
            controller.orders.length + (controller.isPaginationLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.orders.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return bookingItem(controller.orders[index]);
        },
      ),
    );
  }
}
