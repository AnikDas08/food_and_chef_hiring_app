import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/booking_history_controller.dart';

void requestChange(BuildContext context,dynamic order) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<BookingHistoryController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          titleText: AppString.cancelBooking,
                          buttonHeight: 48,
                          buttonRadius: 16,
                          titleSize: 12,
                          titleWeight: FontWeight.w500,
                          borderColor: Colors.transparent,
                          titleColor: Color(0xffFF3C3C),
                          buttonColor: Color(0xffF2F2F2),
                          onTap: (){
                            Get.back();
                            final TextEditingController reasonController = TextEditingController();

                            Get.dialog(
                              AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                                title: const CommonText(text: "Cancel Booking", fontWeight: FontWeight.bold),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CommonText(text: "Please provide a reason for cancelling this booking:",maxLines:  4, fontSize: 13,textAlign: TextAlign.start, bottom: 12),
                                    TextField(
                                      controller: reasonController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "Enter reason here...",
                                        hintStyle: const TextStyle(fontSize: 12),
                                        fillColor: const Color(0xffF5F5F5),
                                        filled: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                                    onPressed: () {
                                      if (reasonController.text.trim().isEmpty) {
                                        Get.snackbar("Reason Required", "Please enter a reason before cancelling.");
                                      } else {
                                        Get.back(); // Close dialog
                                        Get.find<BookingHistoryController>().cancelBooking(order.id, reasonController.text.trim());
                                      }
                                    },
                                    child: const Text("Confirm Cancel", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      12.width,
                      if (order.status == "Confirm") ...[
                        12.width,
                        Expanded(
                          child: CommonButton(
                            titleText: AppString.requestChange,
                            buttonHeight: 48,
                            buttonRadius: 16,
                            titleSize: 12,
                            titleWeight: FontWeight.w500,
                            onTap: () {
                              Get.toNamed(AppRoutes.requestChange, arguments: order);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          titleText: AppString.orderGroceries,
                          buttonHeight: 48,
                          buttonRadius: 16,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: EdgeInsets.all(14.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CommonImage(imageSrc: AppIcons.chats, size: 20),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: EdgeInsets.all(14.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CommonImage(imageSrc: AppIcons.edit, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}
