import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../controller/chef_booking_controller.dart';

void requestChangePopUp({String? orderId}) {
  final TextEditingController noteController = TextEditingController();

  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<ChefBookingController>(
        builder: (controller) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16).copyWith(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      CommonText(
                        text: "Request Change",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: "Choose your new preferred time",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),

                      TableCalendar(
                        daysOfWeekVisible: false,
                        weekNumbersVisible: false,
                        rowHeight: 40,
                        headerStyle: const HeaderStyle(formatButtonVisible: false),
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 60)),
                        focusedDay: controller.selectedDate,
                        selectedDayPredicate: (day) =>
                            isSameDay(day, controller.selectedDate),
                        onDaySelected: (selectedDay, focusedDay) {
                          controller.selectDate(selectedDay);
                        },
                      ),

                      const SizedBox(height: 20),

                      const CommonText(
                        text: "Select start time",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.timeSlots.map((time) {
                          final isSelected = controller.selectedTime.contains(time);
                          return GestureDetector(
                            onTap: () => controller.selectTime(time),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xff272727)
                                    : const Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CommonText(
                                text: time,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      CommonText(
                        text: "Note",
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                        top: 16,
                        bottom: 8,
                      ),

                      CommonTextField(
                        controller: noteController,
                        hintText: "Enter your reason here",
                        maxLines: 5,
                        borderRadius: 12,
                      ),

                      24.height,

                      Obx(() => CommonButton(
                        titleText: controller.isRequestingChange.value
                            ? "Sending..."
                            : "Send Request",
                        onTap: controller.isRequestingChange.value
                            ? null
                            : () async {

                          if (controller.selectedTime.isEmpty) {
                            Get.snackbar("Error", "Please select a time");
                            return;
                          }
                          if (orderId == null || orderId.isEmpty) {
                            Get.snackbar("Error", "Order ID missing");
                            return;
                          }

                          controller.isRequestingChange.value = true;

                          try {

                            final date = controller.selectedDate;
                            final dateStr =
                                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            final timeStr = controller.selectedTime;

                            final response = await ApiService.post(
                              '${ApiEndPoint.changeSchedule}$orderId',
                              body: {
                                "requested_date": dateStr,
                                "requested_time": timeStr,
                                "note": noteController.text.trim(),
                              },
                            );

                            if (response.statusCode == 200 &&
                                response.data?['success'] == true) {
                              Get.back();
                              Get.snackbar(
                                "Success",
                                "Change request sent successfully",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                response.data?['message']?.toString() ??
                                    "Something went wrong",
                              );
                            }
                          } catch (e) {
                            Get.snackbar("Error", "Failed to send request");
                          } finally {
                            controller.isRequestingChange.value = false;
                          }
                        },
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}