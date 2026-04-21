import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/chef_detail_controller.dart';

void availabilityPopup(BuildContext context, String chefId) {
  // Trigger initial fetch for today's date
  final controller = Get.find<ChefDetailsController>();
  controller.fetchAvailableSlots();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<ChefDetailsController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    focusedDay: controller.selectedDate,
                    selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate),
                    onDaySelected: (selectedDay, focusedDay) {
                      controller.selectDate(selectedDay, chefId); // Pass chefId here
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Colors.black,        // 🔥 selected date circle color
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.grey.shade300, // optional: today color
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  20.height,
                  const CommonText(text: 'Select start time', fontWeight: FontWeight.w600),
                  12.height,

                  // Show loader or slots
                  if (controller.isSlotLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (controller.timeSlots.isEmpty)
                    const Center(child: CommonText(text: 'No slots available for this date', fontSize: 12))
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.timeSlots.map((time) {
                        final isSelected = controller.selectedTime == time;
                        return GestureDetector(
                          onTap: () {
                            // 1. Update selected time
                            controller.selectTime(time);

                            // 2. Close bottom sheet and return selected date & time
                            Navigator.pop(context, {
                              'date': controller.selectedDate,
                              'time': controller.selectedTime,
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xff272727) : const Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CommonText(
                              text: time,
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  24.height,
                  CommonButton(
                      titleText: 'Done',
                      onTap: () {
                        // You can return the data back to the screen
                        Navigator.pop(context, {
                          'date': controller.selectedDate,
                          'time': controller.selectedTime,
                        });
                      }
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
