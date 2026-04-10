import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/auth/signup_chef/presentation/controller/sign_up_chef_controller.dart';
import '../../../../common/auth/signup_chef/presentation/screen/cafe_set_availability.dart';
import '../../../profile/presentation/widgets/custom_TimePicker.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../config/api/api_end_point.dart';

class AvailabiityScreen extends StatefulWidget {
  const AvailabiityScreen({super.key});

  @override
  State<AvailabiityScreen> createState() => _CafeSetAvailabilityScreenState();
}

class _CafeSetAvailabilityScreenState extends State<AvailabiityScreen> {
  bool _isLoadingData = true;

  final List<DaySchedule> _days = [
    DaySchedule(name: "Monday"),
    DaySchedule(name: "Tuesday"),
    DaySchedule(name: "Wednesday"),
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
  bool _editingMin = false;
  bool _editingMax = false;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingAvailability();
  }

  Future<void> _loadExistingAvailability() async {
    try {
      final response = await ApiService.get(ApiEndPoint.chefProfile);
      if (response.statusCode == 200) {
        final List existingAvailability =
            response.data['data']['availability'] ?? [];

        if (existingAvailability.isEmpty) {
          setState(() => _isLoadingData = false);
          return;
        }

        setState(() {
          for (var item in existingAvailability) {
            final index = _days.indexWhere(
                  (d) => d.name.toLowerCase() == item['day']?.toString().toLowerCase(),
            );
            if (index != -1) {
              final dynamic rawEnabled = item['is_available'] ??
                  item['availableity'] ??
                  item['availability'] ??
                  false;
              final isEnabled =
                  rawEnabled == true || rawEnabled.toString() == 'true';

              _days[index].isEnabled = isEnabled;

              final times = item['availability_times'] as List?;
              if (isEnabled && times != null && times.isNotEmpty) {
                _days[index].slots = times
                    .map<TimeSlot>((t) => TimeSlot(
                  from: _parseTime(t['start_time'] ?? '09:00 AM'),
                  to: _parseTime(t['end_time'] ?? '05:00 PM'),
                ))
                    .toList();
              } else if (isEnabled && _days[index].slots.isEmpty) {
                _days[index].slots.add(TimeSlot(
                  from: const TimeOfDay(hour: 9, minute: 0),
                  to: const TimeOfDay(hour: 17, minute: 0),
                ));
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading availability: $e");
    } finally {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

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
                width: 160.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ["Hours", "Days"].map((unit) {
                    final isSelected = unit == selected;
                    return InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        onSelect(unit);
                        entry.remove();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              unit,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF272727),
                              ),
                            ),
                            isSelected
                                ? Container(
                              width: 22.w,
                              height: 22.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF272727),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check,
                                  size: 13.sp, color: Colors.white),
                            )
                                : Container(
                              width: 36.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDDDDD),
                                borderRadius:
                                BorderRadius.circular(100.r),
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.all(2.w),
                                  width: 18.w,
                                  height: 18.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
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
            // Back Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
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

            // Loading
            if (_isLoadingData)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1C1C1C)),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set Availability",
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

                      // Booking Preferences
                      Text(
                        "Booking Preferences",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF272727),
                        ),
                      ),
                      10.verticalSpace,

                      // Summary text
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                            height: 1.6,
                          ),
                          children: [
                            const TextSpan(
                                text: "Customers can place orders at least "),
                            TextSpan(
                              text: "$_minHours $_minUnit",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF272727),
                                fontSize: 13.sp,
                              ),
                            ),
                            const TextSpan(text: " in advance and a maximum of "),
                            TextSpan(
                              text: "$_maxDays $_maxUnit",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF272727),
                                fontSize: 13.sp,
                              ),
                            ),
                            const TextSpan(text: " in advance"),
                          ],
                        ),
                      ),
                      14.verticalSpace,

                      // Min booking row
                      _buildBookingInputRow(
                        value: _minHours,
                        unit: _minUnit,
                        isEditing: _editingMin,
                        controller: _minController,
                        onEditStart: () {
                          _minController.text = _minHours.toString();
                          setState(() => _editingMin = true);
                        },
                        onEditDone: () {
                          final val = int.tryParse(_minController.text);
                          setState(() {
                            if (val != null && val >= 1 && val <= 24)
                              _minHours = val;
                            _editingMin = false;
                          });
                        },
                        onUnitTap: (offset) => _showUnitPopup(
                          context: context,
                          offset: offset,
                          selected: _minUnit,
                          onSelect: (v) => setState(() => _minUnit = v),
                        ),
                      ),
                      12.verticalSpace,

                      // Max booking row
                      _buildBookingInputRow(
                        value: _maxDays,
                        unit: _maxUnit,
                        isEditing: _editingMax,
                        controller: _maxController,
                        onEditStart: () {
                          _maxController.text = _maxDays.toString();
                          setState(() => _editingMax = true);
                        },
                        onEditDone: () {
                          final val = int.tryParse(_maxController.text);
                          setState(() {
                            if (val != null && val >= 1 && val <= 30)
                              _maxDays = val;
                            _editingMax = false;
                          });
                        },
                        onUnitTap: (offset) => _showUnitPopup(
                          context: context,
                          offset: offset,
                          selected: _maxUnit,
                          onSelect: (v) => setState(() => _maxUnit = v),
                        ),
                      ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),

            // Save Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: (_isSubmitting || _isLoadingData)
                      ? null
                      : () async {
                    setState(() => _isSubmitting = true);
                    try {
                      final controller = SignUpChefController.instance;
                      await controller
                          .setupChefAvailability2(days: _days);
                    } finally {
                      if (mounted)
                        setState(() => _isSubmitting = false);
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                      : Text(
                    "Save Changes",
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
              onChanged: (val) => setState(() {
                day.isEnabled = val;
                if (val && day.slots.isEmpty) {
                  day.slots.add(TimeSlot(
                    from: const TimeOfDay(hour: 9, minute: 0),
                    to: const TimeOfDay(hour: 17, minute: 0),
                  ));
                }
              }),
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF1C1C1C),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFCCCCCC),
            ),
          ],
        ),
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
                  padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                  Icon(Icons.add, size: 16.sp, color: const Color(0xFF272727)),
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

  Widget _buildBookingInputRow({
    required int value,
    required String unit,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onEditStart,
    required VoidCallback onEditDone,
    required Function(Offset) onUnitTap,
  }) {
    final boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Number box
        GestureDetector(
          onTap: onEditStart,
          child: Container(
            width: 70.w,
            height: 48.h,
            decoration: boxDecoration,
            alignment: Alignment.center,
            child: isEditing
                ? TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF272727)),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero),
              onSubmitted: (_) => onEditDone(),
            )
                : Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF272727)),
            ),
          ),
        ),
        8.horizontalSpace,
        // Unit dropdown box
        GestureDetector(
          onTapDown: (details) => onUnitTap(details.globalPosition),
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: boxDecoration,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  unit,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF272727)),
                ),
                4.horizontalSpace,
                Icon(Icons.keyboard_arrow_down,
                    size: 18.sp, color: const Color(0xFF272727)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}