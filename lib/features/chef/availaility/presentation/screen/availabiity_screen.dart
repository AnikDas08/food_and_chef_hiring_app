import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/auth/signup_chef/presentation/controller/sign_up_chef_controller.dart';
import '../controller/availiability_controller.dart';
import '../widgets/availability_item.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

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

  Widget _buildValueChip({
    required BuildContext context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.w),
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
      body: GetBuilder<AvailabilityController>(
        init: AvailabilityController(),
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // ── Scrollable Content ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
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
                          "Set up your availability to let customers know when you're available to cook.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF777777),
                            height: 1.5,
                          ),
                        ),
                        20.verticalSpace,

                        // ── Day Items ──
                        ...controller.days.map(
                              (day) => AvailabilityItem(day: day),
                        ),
                        20.verticalSpace,

                        // ── Booking Preferences ──
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
                              WidgetSpan(
                                child: _buildValueChip(
                                  context: context,
                                  value: controller.minHours.toString(),
                                  unit: controller.minUnit,
                                  onValueTap: controller.incrementMin,
                                  onUnitTap: (offset) => _showUnitPopup(
                                    context: context,
                                    offset: offset,
                                    selected: controller.minUnit,
                                    onSelect: controller.setMinUnit,
                                  ),
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
                              WidgetSpan(
                                child: _buildValueChip(
                                  context: context,
                                  value: controller.maxDays.toString(),
                                  unit: controller.maxUnit,
                                  onValueTap: controller.incrementMax,
                                  onUnitTap: (offset) => _showUnitPopup(
                                    context: context,
                                    offset: offset,
                                    selected: controller.maxUnit,
                                    onSelect: controller.setMaxUnit,
                                  ),
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

                // ── Save Changes Button ──
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : controller.saveAvailability,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1C),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        const Color(0xFF1C1C1C).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading
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
                            "Saving...",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                          : Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}