import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/cart/presentation/controller/cart_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../component/text/common_text.dart';

bookingDateTimePopup() {
  showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        child: GetBuilder<CartController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Calendar
                  TableCalendar(
                    rowHeight: 38,
                    daysOfWeekHeight: 20,
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    focusedDay: controller.selectedDate,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                    ),
                    selectedDayPredicate:
                        (day) => isSameDay(day, controller.selectedDate),
                    onDaySelected: (selectedDay, focusedDay) {
                      controller.selectDate(selectedDay);
                    },
                    calendarStyle: CalendarStyle(
                      cellMargin: EdgeInsets.zero,
                      selectedDecoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  const Divider(height: 24),

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
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
