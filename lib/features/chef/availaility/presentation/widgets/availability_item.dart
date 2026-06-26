import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/switch_button.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../controller/availiability_controller.dart';

class AvailabilityItem extends StatelessWidget {

  const AvailabilityItem({super.key, required this.day});

  final DayModel day;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AvailabilityController>();

    return GetBuilder<AvailabilityController>(
      builder: (_) => Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: day.name,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),
                switchButton(
                  value: day.isEnabled,
                  onTap: () => controller.toggleDay(day, !day.isEnabled),
                ),
              ],
            ),

            if (day.isEnabled) ...[
              16.height,
              ...List.generate(day.slots.length, (i) {
                final slot = day.slots[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i > 0)
                      const CommonText(
                        text: 'And',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                        bottom: 8,
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField(
                            fillColor: Colors.white,
                            prefixText: 'From: ',
                            hintText: 'From',
                            controller: slot.from,
                            paddingHorizontal: 4,
                            paddingVertical: 14,
                            fontSize: 12,
                            keyboardType: TextInputType.none,
                            borderRadius: 12,
                            onTap: () =>
                                OtherHelper.openTimePickerDialog(slot.from),
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: CommonTextField(
                            fillColor: Colors.white,
                            prefixText: 'To: ',
                            hintText: 'To',
                            paddingHorizontal: 10,
                            fontSize: 12,
                            paddingVertical: 14,
                            keyboardType: TextInputType.none,
                            controller: slot.to,
                            borderRadius: 12,
                            onTap: () =>
                                OtherHelper.openTimePickerDialog(slot.to),
                          ),
                        ),
                        // ── Remove slot ──
                        if (day.slots.length > 1) ...[
                          8.width,
                          GestureDetector(
                            onTap: () => controller.removeSlot(day, i),
                            child: const Icon(
                              CupertinoIcons.minus_circle,
                              size: 20,
                              color: Color(0xffFD713F),
                            ),
                          ),
                        ],
                      ],
                    ),
                    16.height,
                  ],
                );
              }),

              // ── Add Additional Time ──
              GestureDetector(
                onTap: () => controller.addSlot(day),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.add, size: 16),
                    CommonText(
                      text: AppString.addAdditionalTime,
                      fontSize: 12,
                      color: Color(0xff272727),
                      left: 4,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}