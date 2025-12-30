import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/chef_booking_controller.dart';

void requestChangePopUp() {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    constraints: BoxConstraints(maxHeight: Get.height - 100),
    builder: (context) {
      return GetBuilder<ChefBookingController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    rowHeight: 30,
                    headerStyle: HeaderStyle(formatButtonVisible: false),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontSize: 8),
                      weekendStyle: TextStyle(fontSize: 8),

                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    focusedDay: controller.selectedDate,
                    selectedDayPredicate:
                        (day) => isSameDay(day, controller.selectedDate),
                    onDaySelected: (selectedDay, focusedDay) {
                      controller.selectDate(selectedDay);
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Time Slots
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
                    children:
                        controller.timeSlots.map((time) {
                          final isSelected = controller.selectedTime.contains(
                            time,
                          );

                          return GestureDetector(
                            onTap: () => controller.selectTime(time),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xff272727)
                                        : Color(0xffF2F2F2),
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
                    hintText: "Enter your reason here",
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    borderRadius: 12,
                  ),
                  24.height,
                  CommonButton(
                    titleText: "Send Request",
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
