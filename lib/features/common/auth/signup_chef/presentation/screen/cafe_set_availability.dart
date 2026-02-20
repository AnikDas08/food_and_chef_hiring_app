import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/sign_up_chef_controller.dart';
import 'Cafe_Enable_AutoAccept_Screen.dart';

class TimeSlot {
  TimeOfDay from;
  TimeOfDay to;
  TimeSlot({required this.from, required this.to});
}

class DaySchedule {
  final String name;
  bool isEnabled;
  List<TimeSlot> slots;

  DaySchedule({
    required this.name,
    this.isEnabled = false,
    List<TimeSlot>? slots,
  }) : slots = slots ??
      [TimeSlot(from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 0))];
}

class CafeSetAvailabilityScreen extends StatefulWidget {
  const CafeSetAvailabilityScreen({super.key});

  @override
  State<CafeSetAvailabilityScreen> createState() =>
      _CafeSetAvailabilityScreenState();
}

class _CafeSetAvailabilityScreenState
    extends State<CafeSetAvailabilityScreen> {

  final List<DaySchedule> _days = [
    DaySchedule(
      name: "Monday",
      isEnabled: true,
      slots: [
        TimeSlot(
            from: const TimeOfDay(hour: 9, minute: 0),
            to: const TimeOfDay(hour: 17, minute: 30)),
      ],
    ),
    DaySchedule(
      name: "Tuesday",
      isEnabled: true,
      slots: [
        TimeSlot(
            from: const TimeOfDay(hour: 9, minute: 0),
            to: const TimeOfDay(hour: 14, minute: 30)),
        TimeSlot(
            from: const TimeOfDay(hour: 17, minute: 0),
            to: const TimeOfDay(hour: 22, minute: 30)),
      ],
    ),
    DaySchedule(
      name: "Wednesday",
      isEnabled: true,
      slots: [
        TimeSlot(
            from: const TimeOfDay(hour: 9, minute: 0),
            to: const TimeOfDay(hour: 17, minute: 30)),
      ],
    ),
    DaySchedule(name: "Thursday"),
    DaySchedule(name: "Friday"),
    DaySchedule(name: "Saturday"),
    DaySchedule(name: "Sunday"),
  ];

  int _minHours = 12;
  String _minUnit = "Hours";
  int _maxDays = 14;
  String _maxUnit = "Days";
  bool _isSubmitting = false;

  Future<void> _pickTime(
      DaySchedule day, int slotIndex, bool isFrom) async {
    final slot = day.slots[slotIndex];
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? slot.from : slot.to,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1C1C1C)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          slot.from = picked;
        } else {
          slot.to = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "${h.toString().padLeft(2, '0')}:$m $p";
  }

  void _showUnitPopup({
    required BuildContext context,
    required Offset offset,
    required String selected,
    required Function(String) onSelect,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // dismiss tap
          Positioned.fill(
            child: GestureDetector(
              onTap: () => entry.remove(),
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 120.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ["Hours", "Days"].map((unit) {
                    final isSelected = unit == selected;
                    return InkWell(
                      onTap: () {
                        onSelect(unit);
                        entry.remove();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              unit,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: const Color(0xFF272727),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF6B35),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Back Button ──
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: const Color(0xFF272727),
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set Your Availability",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF272727),
                        letterSpacing: -0.5,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      "Set up your availability to let customers know when you're available to cook. This helps you get booked at the right times.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                        height: 1.5,
                      ),
                    ),
                    20.verticalSpace,

                    ..._days.map((day) => _buildDayItem(day)),
                    20.verticalSpace,

                    Text(
                      "Booking Preferences",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF777777),
                      ),
                    ),
                    10.verticalSpace,

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Customers can place orders at least ",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                              height: 1.6,
                            ),
                          ),
                          // Min value
                          WidgetSpan(
                            child: _buildValueChip(
                              value: _minHours.toString(),
                              unit: _minUnit,
                              onValueTap: () {

                                setState(() {
                                  _minHours =
                                  _minHours < 24 ? _minHours + 1 : 1;
                                });
                              },
                              onUnitTap: (offset) {
                                _showUnitPopup(
                                  context: context,
                                  offset: offset,
                                  selected: _minUnit,
                                  onSelect: (v) =>
                                      setState(() => _minUnit = v),
                                );
                              },
                            ),
                          ),
                          TextSpan(
                            text: " in advance and a maximum of ",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                              height: 1.6,
                            ),
                          ),
                          // Max value
                          WidgetSpan(
                            child: _buildValueChip(
                              value: _maxDays.toString(),
                              unit: _maxUnit,
                              onValueTap: () {
                                setState(() {
                                  _maxDays =
                                  _maxDays < 30 ? _maxDays + 1 : 1;
                                });
                              },
                              onUnitTap: (offset) {
                                _showUnitPopup(
                                  context: context,
                                  offset: offset,
                                  selected: _maxUnit,
                                  onSelect: (v) =>
                                      setState(() => _maxUnit = v),
                                );
                              },
                            ),
                          ),
                          TextSpan(
                            text: " in advance",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    32.verticalSpace,
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                    setState(() => _isSubmitting = true);
                    try {
                      final controller = SignUpChefController.instance;
                      await controller.setupChefAvailability(days: _days);
                    } finally {
                      if (mounted) setState(() => _isSubmitting = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                      10.horizontalSpace,
                      Text(
                        "Loading...",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                      : Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDayItem(DaySchedule day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header row
        Row(
          children: [
            Text(
              day.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
              ),
            ),
            const Spacer(),
            Switch.adaptive(
              value: day.isEnabled,
              onChanged: (val) => setState(() => day.isEnabled = val),
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF1C1C1C),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFCCCCCC),
            ),
          ],
        ),

        // Slots (only when enabled)
        if (day.isEnabled) ...[
          ...day.slots.asMap().entries.map((entry) {
            final i = entry.key;
            final slot = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                    child: Text(
                      "And",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Text("From",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF777777))),
                      10.horizontalSpace,
                      GestureDetector(
                        onTap: () => _pickTime(day, i, true),
                        child: Text(
                          _formatTime(slot.from),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF272727),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text("To",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF777777))),
                      10.horizontalSpace,
                      GestureDetector(
                        onTap: () => _pickTime(day, i, false),
                        child: Text(
                          _formatTime(slot.to),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF272727),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                6.verticalSpace,
              ],
            );
          }),

          // + Add Additional Time
          GestureDetector(
            onTap: () {
              setState(() {
                day.slots.add(
                  TimeSlot(
                    from: const TimeOfDay(hour: 9, minute: 0),
                    to: const TimeOfDay(hour: 17, minute: 0),
                  ),
                );
              });
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
              child: Row(
                children: [
                  Icon(Icons.add,
                      size: 16.sp, color: const Color(0xFF272727)),
                  6.horizontalSpace,
                  Text(
                    "Add Additional Time",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF272727),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        Divider(color: Colors.grey.shade200, height: 20.h),
      ],
    );
  }

  Widget _buildValueChip({
    required String value,
    required String unit,
    required VoidCallback onValueTap,
    required Function(Offset) onUnitTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EB),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onValueTap,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
          4.horizontalSpace,
          GestureDetector(
            onTapDown: (details) => onUnitTap(details.globalPosition),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    size: 14.sp, color: const Color(0xFFFF6B35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}