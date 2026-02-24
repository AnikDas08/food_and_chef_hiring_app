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
      margin: EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: AppString.topItems,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CommonText(
                      text: "Most Picked",
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
              ? Center(child: CircularProgressIndicator(color: Color(0xffFD713F)))
              : controller.topMenuList.isEmpty
              ? Center(child: Text("No items found"))
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