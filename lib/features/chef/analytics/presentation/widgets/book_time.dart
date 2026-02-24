import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import '../controller/analytics_controller.dart';
import 'chart.dart';

class BookTime extends StatelessWidget {
  const BookTime({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalyticsController controller = Get.find();
    return Obx(() {
      return Container(
        height: 243.h,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: "Most Booked Times",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) {
                        return SafeArea(
                          child: Obx(() => SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 12),
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ...controller.days.map((day) {
                                  final bool isSelected = controller.selectedDay.value == day;
                                  return ListTile(
                                    onTap: () {
                                      controller.changeDay(day);
                                      Get.back();
                                    },
                                    title: Text(
                                      day,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? Color(0xffFD713F)
                                            : Color(0xff272727),
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? Icon(Icons.check, color: Color(0xffFD713F))
                                        : null,
                                  );
                                }),
                                SizedBox(height: 16),
                              ],
                            ),
                          )),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CommonText(
                          text: controller.selectedDay.value,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff272727),
                          right: 4,
                        ),
                        Icon(Icons.keyboard_arrow_down_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: controller.bookingLoading.value
                  ? Center(child: CircularProgressIndicator(color: Color(0xffFD713F)))
                  : BarChartSample3(chartData: controller.mappedData),
            ),
          ],
        ),
      );
    });
  }
}