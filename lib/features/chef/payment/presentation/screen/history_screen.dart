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
        title: CommonText(
          text: "History",
          fontSize: 14,
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
                  hintText: "Search",
                  hintTextColor: Color(0xff272727),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(Icons.search),
                  ),
                ),

                12.height,
                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.bookingHistoryList.length,
                    itemBuilder: (context, index) {
                      String value = controller.bookingHistoryList[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          controller.onChangeBookingHistory(value);
                        },
                        child:
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color:
                                    controller.selectedBookingHistory == value
                                        ? Color(0xff222222)
                                        : Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(12.sp),
                              ),
                              child: CommonText(
                                text: value,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color:
                                    controller.selectedBookingHistory == value
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
                    ? CommonLoader()
                    : ListView.builder(
                      itemCount: controller.history.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map value = controller.history[index];
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
