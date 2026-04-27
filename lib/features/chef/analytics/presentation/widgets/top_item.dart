import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import '../controller/analytics_controller.dart';
import 'menu_top_item.dart';

Widget topItem() {
  final AnalyticsController controller = Get.find();
  return Obx(() {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                text: AppString.topItems,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    CommonText(
                      text: 'Most Picked',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff272727),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined),
                  ],
                ),
              ),
            ],
          ),
          controller.topMenuLoading.value
              ? const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xffFD713F)),
            ),
          )
              : controller.topMenuList.isEmpty
              ? const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(
              child: CommonText(
                text: 'No items found',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey, // grey text here
              ),
            ),
          )
              : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.topMenuList.length,
            itemBuilder: (context, index) {
              return MenuTopItem(
                value: index + 1,
                item: controller.topMenuList[index],
              );
            },
          ),
        ],
      ),
    );
  });
}
