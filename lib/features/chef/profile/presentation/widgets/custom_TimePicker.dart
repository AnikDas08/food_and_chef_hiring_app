import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final String title;
  final Function(TimeOfDay) onConfirm;

  const CustomTimePicker({
    super.key,
    required this.initialTime,
    required this.onConfirm,
    this.title = "Select Time",
  });

  static Future<TimeOfDay?> show(
      BuildContext context, {
        required TimeOfDay initialTime,
        String title = "Select Time",
      }) async {
    TimeOfDay? result;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CustomTimePicker(
        initialTime: initialTime,
        title: title,
        onConfirm: (t) {
          result = t;
          Navigator.pop(context);
        },
      ),
    );
    return result;
  }

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _selectedHour;
  late int _selectedMinute;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  static const double _itemHeight = 52.0;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hourOfPeriod == 0
        ? 12
        : widget.initialTime.hourOfPeriod;
    _selectedMinute = widget.initialTime.minute;

    _hourController =
        FixedExtentScrollController(initialItem: _selectedHour - 1);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  Widget _buildWheel({
    required int itemCount,
    required FixedExtentScrollController controller,
    required Function(int) onChanged,
    required String Function(int) labelBuilder,
  }) {
    return SizedBox(
      height: _itemHeight * 5,
      width: 72.w,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemHeight,
        perspective: 0.003,
        diameterRatio: 2.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final isSelected =
                index == controller.selectedItem;
            return Center(
              child: Text(
                labelBuilder(index),
                style: TextStyle(
                  fontSize: isSelected ? 24.sp : 18.sp,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.25),
                ),
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          18.verticalSpace,

          // Header Row
          Row(
            children: [
              // X Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 17.sp,
                  ),
                ),
              ),

              // Title
              Expanded(
                child: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              // ✓ Button
              GestureDetector(
                onTap: () => widget.onConfirm(
                  TimeOfDay(
                    hour: _selectedHour,
                    minute: _selectedMinute,
                  ),
                ),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9500),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          24.verticalSpace,

          // Scroll Wheels with center highlight
          SizedBox(
            height: _itemHeight * 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ✅ Center highlight bar (full width, both columns)
                Positioned(
                  top: _itemHeight * 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: _itemHeight,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),

                // Wheels Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hour wheel
                    _buildWheel(
                      itemCount: 12,
                      controller: _hourController,
                      onChanged: (i) =>
                          setState(() => _selectedHour = i + 1),
                      labelBuilder: (i) =>
                          (i + 1).toString().padLeft(2, '0'),
                    ),

                    // Colon
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        ":",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Minute wheel
                    _buildWheel(
                      itemCount: 60,
                      controller: _minuteController,
                      onChanged: (i) =>
                          setState(() => _selectedMinute = i),
                      labelBuilder: (i) =>
                          i.toString().padLeft(2, '0'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          20.verticalSpace,
        ],
      ),
    );
  }
}