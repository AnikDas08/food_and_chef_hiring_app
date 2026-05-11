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

  static const double _itemHeight = 70.0;
  static const int _intervalMinutes = 15;

  late List<TimeOfDay> _timeSlots;
  late int _fromIndex;
  late int _toIndex;
  late FixedExtentScrollController _fromController;
  late FixedExtentScrollController _toController;

  List<TimeOfDay> _generateTimeSlots() {
    final slots = <TimeOfDay>[];
    for (int h = 0; h < 24; h++) {
      for (int m = 0; m < 60; m += _intervalMinutes) {
        slots.add(TimeOfDay(hour: h, minute: m));
      }
    }
    return slots;
  }

  int _findClosestIndex(TimeOfDay time) {
    final roundedMinute =
        ((time.minute / _intervalMinutes).round() * _intervalMinutes) % 60;
    for (int i = 0; i < _timeSlots.length; i++) {
      if (_timeSlots[i].hour == time.hour &&
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
      width: 130.w,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemHeight,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: _timeSlots.length,
          builder: (context, index) {
            final diff = (index - selectedIndex).abs();
            final isSelected = diff == 0;

            Color color;
            if (isSelected) {
              color = const Color(0xFF272727);
            } else {
              color = const Color(0xFFBBBBBB);
            }

            if (isSelected) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      text: _formatTimeLine1(_timeSlots[index]),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    CommonText(
                      text: _formatTimeLine2(_timeSlots[index]),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: CommonText(
                text: _formatTimeSingleLine(_timeSlots[index]),
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          24.verticalSpace,

          const CommonText(
            text: 'Set Availability',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF272727),
          ),

          20.verticalSpace,

          Stack(
            alignment: Alignment.center,
            children: [

              Container(
                height: 80.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
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
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: CommonText(
                      text: 'to',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF777777),
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

          32.verticalSpace,

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
          10.verticalSpace,
        ],
      ),
    );
  }
}