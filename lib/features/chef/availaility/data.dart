import 'package:flutter/material.dart';

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