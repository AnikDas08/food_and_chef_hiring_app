import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';

class SetAvailabilityPicker extends StatefulWidget {
  final TimeOfDay initialFromTime;
  final TimeOfDay initialToTime;
  final Function(TimeOfDay from, TimeOfDay to) onApply;

  const SetAvailabilityPicker({
    super.key,
    required this.initialFromTime,
    required this.initialToTime,
    required this.onApply,
  });

  static Future<void> show(
      BuildContext context, {
        required TimeOfDay initialFromTime,
        required TimeOfDay initialToTime,
        required Function(TimeOfDay from, TimeOfDay to) onApply,
      }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SetAvailabilityPicker(
        initialFromTime: initialFromTime,
        initialToTime: initialToTime,
        onApply: onApply,
      ),
    );
  }

  @override
  State<SetAvailabilityPicker> createState() => _SetAvailabilityPickerState();
}

class _SetAvailabilityPickerState extends State<SetAvailabilityPicker> {
  static const double _itemHeight = 80.0;
  static const int _intervalMinutes = 15;

  late List<TimeOfDay> _timeSlots;
  late int _fromIndex;
  late int _toIndex;
  late FixedExtentScrollController _fromController;
  late FixedExtentScrollController _toController;

  List<TimeOfDay> _generateTimeSlots() {
    final slots = <TimeOfDay>[];
    for (int h = 1; h <= 12; h++) {
      for (int m = 0; m < 60; m += _intervalMinutes) {
        slots.add(TimeOfDay(hour: h, minute: m));
      }
    }
    return slots;
  }

  int _findClosestIndex(TimeOfDay time) {
    final hourOfPeriod = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final roundedMinute =
        ((time.minute / _intervalMinutes).round() * _intervalMinutes) % 60;
    for (int i = 0; i < _timeSlots.length; i++) {
      if (_timeSlots[i].hourOfPeriod == hourOfPeriod &&
          _timeSlots[i].minute == roundedMinute) {
        return i;
      }
    }
    return 0;
  }

  String _formatTimeLine1(TimeOfDay time) {
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final m = time.minute.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m';
  }

  String _formatTimeLine2(TimeOfDay time) {
    return time.period == DayPeriod.am ? 'AM' : 'PM';
  }

  String _formatTimeSingleLine(TimeOfDay time) {
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h.toString().padLeft(2, '0')}:$m $period';
  }

  @override
  void initState() {
    super.initState();
    _timeSlots = _generateTimeSlots();
    _fromIndex = _findClosestIndex(widget.initialFromTime);
    _toIndex = _findClosestIndex(widget.initialToTime);
    _fromController = FixedExtentScrollController(initialItem: _fromIndex);
    _toController = FixedExtentScrollController(initialItem: _toIndex);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int selectedIndex,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      height: _itemHeight * 5,
      width: 140.w,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemHeight,
        diameterRatio: 2.8,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: _timeSlots.length,
          builder: (context, index) {
            final diff = (index - selectedIndex).abs();
            final isSelected = diff == 0;

            Color color;
            if (isSelected) {
              color = const Color(0xFF1C1C1E);
            } else if (diff == 1) {
              color = const Color(0xFF8E8E93);
            } else if (diff == 2) {
              color = const Color(0xFFAEAEB2);
            } else {
              color = const Color(0xFFC7C7CC);
            }

            if (isSelected) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      text: _formatTimeLine1(_timeSlots[index]),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    CommonText(
                      text: _formatTimeLine2(_timeSlots[index]),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: CommonText(
                text: _formatTimeSingleLine(_timeSlots[index]),
                fontSize: diff == 1 ? 17 : 15,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          18.verticalSpace,

          // Title
          const CommonText(
            text: 'Set Availability',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1E),
            textAlign: TextAlign.start,
          ),

          // Scroll Wheels
          SizedBox(
            height: _itemHeight * 5,
            child: Stack(
              alignment: Alignment.center,
              children: [

                Positioned(
                  top: _itemHeight * 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: _itemHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWheel(
                      controller: _fromController,
                      selectedIndex: _fromIndex,
                      onChanged: (i) => setState(() => _fromIndex = i),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: const CommonText(
                        text: 'to',
                        fontSize: 16,
                        color: Color(0xFF3C3C43),
                      ),
                    ),
                    _buildWheel(
                      controller: _toController,
                      selectedIndex: _toIndex,
                      onChanged: (i) => setState(() => _toIndex = i),
                    ),
                  ],
                ),
              ],
            ),
          ),

          20.verticalSpace,

          CommonButton(
            titleText: 'Apply',
            onTap: () {
              widget.onApply(
                _timeSlots[_fromIndex],
                _timeSlots[_toIndex],
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}