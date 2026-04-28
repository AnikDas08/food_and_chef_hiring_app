import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import '../controller/analytics_controller.dart';
import 'earning_chart.dart';

Widget earning() {
  final AnalyticsController controller = Get.put(AnalyticsController());

  return Obx(() {
    return Container(
      height: 320.h,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: controller.isLoading.value
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xffFD713F)),
      )
          : controller.errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: controller.fetchTotalEarning,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFD713F),
              ),
              child: const Text('Retry',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.totalEarning,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text:
                    '\$${controller.totalEarning.value.toStringAsFixed(0)}',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),
                  Row(
                    children: [
                      Icon(
                        controller.isUp.value
                            ? Icons.north_east
                            : Icons.south_east,
                        color: controller.isUp.value
                            ? const Color(0xff2F8328)
                            : Colors.red,
                        size: 14.sp,
                      ),
                      CommonText(
                        text: '${controller.lastMonthPercentage.value.toStringAsFixed(2)}%',
                        fontSize: 12,
                        left: 4,
                        right: 4,
                        fontWeight: FontWeight.w400,
                        color: controller.isUp.value
                            ? const Color(0xff2F8328)
                            : Colors.red,
                      ),
                      CommonText(
                        text: '${controller.isUp.value ? 'higher' : 'lower'} than last ${controller.selectedFilter.value == 'Weekly' ? 'week' : 'month'}',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff272727),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    barrierColor: Colors.black.withOpacity(0.1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20)),
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
                                  borderRadius:
                                  BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...controller.filters.map((filter) {
                                final bool isSelected =
                                    controller.selectedFilter.value ==
                                        filter;
                                return ListTile(
                                  onTap: () {
                                    controller.changeFilter(filter);
                                    Navigator.pop(Get.context!);
                                  },
                                  title: CommonText(
                                    text: filter,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? const Color(0xffFD713F)
                                        : const Color(0xff272727),
                                    textAlign: TextAlign.start,
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check,
                                      color: Color(0xffFD713F))
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CommonText(
                        text: controller.selectedFilter.value,
                        fontSize: 12,
                        color: const Color(0xff272727),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: controller.formatArray.isEmpty
                ? const Center(child: Text('No data available'))
                : LineChartSample2(
              chartData: controller.formatArray,
            ),
          ),
        ],
      ),
    );
  });
}
