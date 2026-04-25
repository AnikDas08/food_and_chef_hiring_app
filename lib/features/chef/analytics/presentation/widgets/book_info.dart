
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../controller/analytics_controller.dart';

Widget bookInfo() {
  final AnalyticsController controller = Get.find();
  return Obx(() {
    return Container(
      margin: EdgeInsets.only(top: 16.sp),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Avg Bookings per Week',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: '${controller.totalBooking.value}',
                    fontSize: 16,
                    top: 2,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),
                ],
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Avg Earnings per Booking',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: '\$${controller.avgPrice.value.toStringAsFixed(2)}',
                    fontSize: 16,
                    top: 2,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),
                ],
              ),
            ],
          ),
          32.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Avg Booking Length',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: '${controller.avgDuration.value}h',
                    fontSize: 16,
                    top: 2,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),
                ],
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Avg Dishes per Booking',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: '${controller.avgMenus.value}',
                    fontSize: 16,
                    top: 2,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  });
}
