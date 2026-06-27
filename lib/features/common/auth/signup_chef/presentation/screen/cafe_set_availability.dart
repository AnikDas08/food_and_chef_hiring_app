import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../component/text/common_text.dart';

import '../../../../../../component/image/common_image.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../../../../../chef/profile/presentation/widgets/custom_TimePicker.dart';
import '../controller/sign_up_chef_controller.dart';

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

class _CafeSetAvailabilityScreenState extends State<CafeSetAvailabilityScreen> {

  final List<DaySchedule> _days = [
    DaySchedule(name: 'Monday', isEnabled: true, slots: [TimeSlot(from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 30))]),
    DaySchedule(name: 'Tuesday', isEnabled: true, slots: [
      TimeSlot(from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 14, minute: 30)),
      TimeSlot(from: const TimeOfDay(hour: 17, minute: 0), to: const TimeOfDay(hour: 22, minute: 30)),
    ]),
    DaySchedule(name: 'Wednesday', isEnabled: true, slots: [TimeSlot(from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 30))]),
    DaySchedule(name: 'Thursday', isEnabled: true, slots: [TimeSlot(from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 30))]),
    DaySchedule(name: 'Friday', isEnabled: true, slots: [TimeSlot(from: const TimeOfDay(hour: 9, minute: 0), to: const TimeOfDay(hour: 17, minute: 30))]),
    DaySchedule(name: 'Saturday'),
    DaySchedule(name: 'Sunday'),
  ];

  int _minHours = 12;
  String _minUnit = 'Hours';
  int _maxDays = 14;
  String _maxUnit = 'Days';
  bool _isSubmitting = false;

  Future<void> _pickTime(DaySchedule day, int slotIndex, bool isFrom) async {
    final slot = day.slots[slotIndex];
    await SetAvailabilityPicker.show(
      context,
      initialFromTime: slot.from,
      initialToTime: slot.to,
      onApply: (from, to) {
        setState(() {
          slot.from = from;
          slot.to = to;
        });
      },
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "${h.toString().padLeft(2, '0')}:$m $p";
  }

  void _showCombinedPopup({
    required BuildContext context,
    required Offset offset,
    required int selectedValue,
    required String selectedUnit,
    required List<int> valueOptions,
    required Function(int) onValueSelect,
    required Function(String) onUnitSelect,
  }) {
    int tempValue = selectedValue;
    String tempUnit = selectedUnit;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: ['Hours', 'Days'].map((unit) {
                        final isSelected = unit == tempUnit;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() => tempUnit = unit),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1C1C1C)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Text(
                                  unit,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF777777),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: valueOptions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (_, i) {
                        final val = valueOptions[i];
                        final isSelected = val == tempValue;
                        return GestureDetector(
                          onTap: () => setModalState(() => tempValue = val),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1C1C1C)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                val.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF272727),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          onValueSelect(tempValue);
                          onUnitSelect(tempUnit);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Set Your Availability',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.start,
                    ),
                    8.verticalSpace,
                    const CommonText(
                      text: "Set up your availability to let customers know when you're available to cook. This helps you get booked at the right times.",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777),
                      maxLines: 5,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.visible,
                    ),
                    20.verticalSpace,
                    ..._days.map((day) => _buildDayItem(day)),
                    20.verticalSpace,
                    const CommonText(
                      text: 'Booking Preferences',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.start,
                    ),
                    10.verticalSpace,
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF777777),
                          height: 1.6,
                        ),
                        children: [
                          const TextSpan(text: 'Customers can place orders at least '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTapDown: (details) => _showCombinedPopup(
                                context: context,
                                offset: details.globalPosition,
                                selectedValue: _minHours,
                                selectedUnit: _minUnit,
                                valueOptions: List.generate(24, (i) => i + 1),
                                onValueSelect: (v) => setState(() => _minHours = v),
                                onUnitSelect: (v) => setState(() => _minUnit = v),
                              ),
                              child: Text(
                                '$_minHours $_minUnit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF272727),
                                  fontSize: 13.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF272727),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' in advance and a maximum of '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTapDown: (details) => _showCombinedPopup(
                                context: context,
                                offset: details.globalPosition,
                                selectedValue: _maxDays,
                                selectedUnit: _maxUnit,
                                valueOptions: List.generate(30, (i) => i + 1),
                                onValueSelect: (v) => setState(() => _maxDays = v),
                                onUnitSelect: (v) => setState(() => _maxUnit = v),
                              ),
                              child: Text(
                                '$_maxDays $_maxUnit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF272727),
                                  fontSize: 13.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF272727),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' in advance'),
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
                        borderRadius: BorderRadius.circular(14.r)),
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
                            color: Colors.white, strokeWidth: 2.5),
                      ),
                      10.horizontalSpace,
                      const CommonText(
                        text: 'Loading...',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ],
                  )
                      : const CommonText(
                    text: 'Continue',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
        Row(
          children: [
            CommonText(
              text: day.name,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF272727),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  day.isEnabled = !day.isEnabled;
                  if (day.isEnabled && day.slots.isEmpty) {
                    day.slots.add(TimeSlot(
                      from: const TimeOfDay(hour: 9, minute: 0),
                      to: const TimeOfDay(hour: 17, minute: 0),
                    ));
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44.w,
                height: 26.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: day.isEnabled
                      ? const Color(0xFF1C1C1C)
                      : const Color(0xFFE0E0E0),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: day.isEnabled ? 20.w : 2.w,
                      top: 3.h,
                      child: Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (day.isEnabled) ...[
          SizedBox(height: 10.h),
          ...day.slots.asMap().entries.map((entry) {
            final i = entry.key;
            final slot = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                    child: const CommonText(
                      text: 'And',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777),
                      textAlign: TextAlign.start,
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _pickTime(day, i, true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              const CommonText(
                                text: 'From',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF777777),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: 8.w),
                              CommonText(
                                text: _formatTime(slot.from),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _pickTime(day, i, false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              const CommonText(
                                text: 'To',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF777777),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: 8.w),
                              CommonText(
                                text: _formatTime(slot.to),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            );
          }),
          GestureDetector(
            onTap: () {
              setState(() {
                day.slots.add(TimeSlot(
                  from: const TimeOfDay(hour: 9, minute: 0),
                  to: const TimeOfDay(hour: 17, minute: 0),
                ));
              });
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
              child: Row(
                children: [
                  Icon(Icons.add, size: 16.sp, color: const Color(0xFF272727)),
                  SizedBox(width: 6.w),
                  const CommonText(
                    text: 'Add Additional Time',
                    fontSize: 13,
                    color: Color(0xFF272727),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
        Divider(color: Colors.grey.shade200, height: 24.h),
      ],
    );
  }
}
