import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/other_widgets/common_loader.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../controller/history_controller.dart';
import '../widgets/withdraw_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: 'History',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<HistoryController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [

                CommonTextField(
                  hintText: 'Search',
                  hintTextColor: const Color(0xff272727),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    controller.onSearch(value);
                  },
                ),

                12.height,


                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.bookingHistoryList.length,
                    itemBuilder: (context, index) {
                      final String value = controller.bookingHistoryList[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          controller.onChangeBookingHistory(value);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: controller.selectedBookingHistory == value
                                ? const Color(0xff272727)
                                : const Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(30.sp),
                          ),
                          child: CommonText(
                            text: value,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: controller.selectedBookingHistory == value
                                ? Colors.white
                                : Colors.black,
                          ),
                        ).center,
                      );
                    },
                  ),
                ),

                24.height,


                controller.isLoading
                    ? const CommonLoader()
                    : controller.history.isEmpty
                    ? Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: const CommonText(
                    text: 'No history found',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9CA3AF),
                  ),
                )
                    : ListView.builder(
                  itemCount: controller.history.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Map value = controller.history[index];
                    return withdrawItem(item: value);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
