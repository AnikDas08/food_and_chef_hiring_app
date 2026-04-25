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
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonText(
                  text: 'Most Booked Times',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) {
                        return SafeArea(
                          child: Obx(() => SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 12),
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...controller.days.map((day) {
                                  final bool isSelected = controller.selectedDay.value == day;
                                  return ListTile(
                                    onTap: () {
                                      controller.changeDay(day);
                                      Navigator.pop(Get.context!);
                                    },
                                    title: Text(
                                      day,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        color: isSelected ? const Color(0xffFD713F) : const Color(0xff272727),
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(Icons.check, color: Color(0xffFD713F))
                                        : null,
                                  );
                                }),
                                const SizedBox(height: 16),
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
                          color: const Color(0xff272727),
                          right: 4,
                        ),
                        const Icon(Icons.keyboard_arrow_down_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 160.h,
              child: controller.bookingLoading.value
                  ? const Center(child: CircularProgressIndicator(color: Color(0xffFD713F)))
                  : controller.mappedData.isEmpty
                  ? const Center(child: Text('DATA EMPTY')) // debug
                  : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: BarChartSample3(
                  key: ValueKey(controller.selectedDay.value),
                  chartData: controller.mappedData.toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}