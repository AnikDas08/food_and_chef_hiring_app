import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/api/api_service.dart';
import '../../../../../services/storage/storage_services.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../common/auth/signup_chef/presentation/controller/sign_up_chef_controller.dart';
import '../../../../common/auth/signup_chef/presentation/screen/Cafe_Enable_AutoAccept_Screen.dart';
import '../../../../common/auth/signup_chef/presentation/screen/cafe_set_availability.dart';

// ── Models ──
class TimeSlotModel {
  TextEditingController from;
  TextEditingController to;

  TimeSlotModel()
      : from = TextEditingController(),
        to = TextEditingController();

  void dispose() {
    from.dispose();
    to.dispose();
  }

  Map<String, String> toMap(int index) => {
    "availability_times[$index][start_time]": from.text,
    "availability_times[$index][end_time]": to.text,
  };
}

class DayModel {
  final String name;
  bool isEnabled;
  List<TimeSlotModel> slots;

  DayModel({required this.name})
      : isEnabled = false,
        slots = [TimeSlotModel()];

  void addSlot() => slots.add(TimeSlotModel());

  void removeSlot(int index) {
    if (slots.length > 1) {
      slots[index].dispose();
      slots.removeAt(index);
    }
  }

  void dispose() {
    for (final s in slots) {
      s.dispose();
    }
  }
}

// ── Controller ──
class AvailabilityController extends GetxController {
  final List<DayModel> days = [
    DayModel(name: "Monday"),
    DayModel(name: "Tuesday"),
    DayModel(name: "Wednesday"),
    DayModel(name: "Thursday"),
    DayModel(name: "Friday"),
    DayModel(name: "Saturday"),
    DayModel(name: "Sunday"),
  ];

  int minHours = 12;
  String minUnit = "Hours";
  int maxDays = 14;
  String maxUnit = "Days";
  bool isLoading = false;

  // ── Day toggle ──
  void toggleDay(DayModel day, bool val) {
    day.isEnabled = val;
    update();
  }

  // ── Slot add/remove ──
  void addSlot(DayModel day) {
    day.addSlot();
    update();
  }

  void removeSlot(DayModel day, int index) {
    day.removeSlot(index);
    update();
  }

  // ── Booking preference ──
  void incrementMin() {
    minHours = minHours < 24 ? minHours + 1 : 1;
    update();
  }

  static SignUpChefController get instance => Get.put(SignUpChefController());

  String get _onboardingEndpoint =>
      "user/onboarding/${LocalStorage.userId}";


  void incrementMax() {
    maxDays = maxDays < 30 ? maxDays + 1 : 1;
    update();
  }

  void setMinUnit(String val) {
    minUnit = val;
    update();
  }

  void setMaxUnit(String val) {
    maxUnit = val;
    update();
  }


  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "${h.toString().padLeft(2, '0')}:$m $p";
  }

  Future<void> setupChefAvailability({
    required List<DaySchedule> days,
  }) async {
    isLoading = true;
    update();
    try {
      final Map<String, dynamic> body = {};

      for (int i = 0; i < days.length; i++) {
        final day = days[i];
        body["availability[$i][day]"] = day.name.toLowerCase();
        body["availability[$i][availableity]"] = day.isEnabled.toString();

        if (day.isEnabled) {
          for (int j = 0; j < day.slots.length; j++) {
            final slot = day.slots[j];
            body["availability[$i][availability_times][$j][start_time]"] =
                _formatTime(slot.from);
            body["availability[$i][availability_times][$j][end_time]"] =
                _formatTime(slot.to);
          }
        }
      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        method: "PATCH",
        body: body,
        files: [],
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.data['message'] ?? "Availability setup successful",
            backgroundColor: Colors.black, colorText: Colors.white);
        Get.to(() => const CafeEnableAutoAcceptScreen());
      } else {
        Utils.errorSnackBar("Error", response.data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveAvailability() async {
    isLoading = true;
    update();

    try {
      final Map<String, dynamic> body = {};

      for (int i = 0; i < days.length; i++) {
        final day = days[i];
        body["availability[$i][day]"] = day.name.toLowerCase();
        body["availability[$i][availableity]"] = day.isEnabled.toString();

        if (day.isEnabled) {
          for (int j = 0; j < day.slots.length; j++) {
            final slot = day.slots[j];
            body["availability[$i][availability_times][$j][start_time]"] =
                slot.from.text;
            body["availability[$i][availability_times][$j][end_time]"] =
                slot.to.text;
          }
        }
      }

      body["min_booking_notice"] = minHours.toString();
      body["min_booking_unit"] = minUnit;
      body["max_booking_advance"] = maxDays.toString();
      body["max_booking_unit"] = maxUnit;



      debugPrint("Body to send: $body");
      Get.snackbar("Success", "Availability saved!",
          backgroundColor: const Color(0xFF1C1C1C),
          colorText: const Color(0xFFFFFFFF));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    for (final d in days) {
      d.dispose();
    }
    super.onClose();
  }
}