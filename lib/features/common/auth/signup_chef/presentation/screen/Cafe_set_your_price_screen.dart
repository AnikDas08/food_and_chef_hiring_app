import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../chef/profile/presentation/widgets/custom_TimePicker.dart';
import '../controller/sign_up_chef_controller.dart';

class CafeSetYourPriceScreen extends StatefulWidget {
  const CafeSetYourPriceScreen({super.key});

  @override
  State<CafeSetYourPriceScreen> createState() =>
      _CafeSetYourPriceScreenState();
}

class _CafeSetYourPriceScreenState extends State<CafeSetYourPriceScreen> {
  final TextEditingController _baseRateController =
  TextEditingController(text: "");
  final TextEditingController _discountRateController =
  TextEditingController(text: "");
  final TextEditingController _weekendRateController =
  TextEditingController(text: "");
  final TextEditingController _minDurationController =
  TextEditingController(text: "");

  bool _offerDiscount = true;
  bool _weekendRate = false;

  TimeOfDay _fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _toTime = const TimeOfDay(hour: 15, minute: 0);
  bool _isSubmitting = false;

  // validation error message
  String? _durationError;

  Future<void> _pickTime(bool isFrom) async {
    await SetAvailabilityPicker.show(
      context,
      initialFromTime: _fromTime,
      initialToTime: _toTime,
      onApply: (from, to) {
        setState(() {
          _fromTime = from;
          _toTime = to;
        });
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  /// null = valid, string = error
  String? _validateDuration(String value) {
    if (value.trim().isEmpty) return null;
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return "Please enter a valid number";
    if (parsed < 0.5) {
      return "Minimum booking duration is 30 minutes (0.5h)";
    }
    return null;
  }

  @override
  void dispose() {
    _baseRateController.dispose();
    _discountRateController.dispose();
    _weekendRateController.dispose();
    _minDurationController.dispose();
    super.dispose();
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

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set Your Price",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF272727),
                        letterSpacing: -0.5,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      "Set your hourly rate that customers will pay you to cook for them! No pressure though--you can change this any time.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                        height: 1.5,
                      ),
                    ),
                    24.verticalSpace,

                    Text(
                      "PRICING",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF777777),
                        letterSpacing: 1.2,
                      ),
                    ),
                    12.verticalSpace,

                    Text(
                      "Set Amount",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF272727),
                      ),
                    ),
                    8.verticalSpace,
                    _buildPriceField(_baseRateController),
                    20.verticalSpace,

                    // ── Discount Toggle Card ──
                    _buildToggleCard(
                      title:
                      "Offer discounted rate during specific\nhours on weekdays",
                      value: _offerDiscount,
                      onChanged: (val) =>
                          setState(() => _offerDiscount = val),
                      child: _offerDiscount
                          ? Column(
                        children: [
                          12.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: _buildTimeField(
                                  label: "From",
                                  time: _fromTime,
                                  onTap: () => _pickTime(true),
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: _buildTimeField(
                                  label: "To",
                                  time: _toTime,
                                  onTap: () => _pickTime(false),
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          _buildPriceField(_discountRateController),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),
                    12.verticalSpace,

                    // ── Weekend Rate Toggle Card ──
                    _buildToggleCard(
                      title: "Ask for higher rate on weekends",
                      value: _weekendRate,
                      onChanged: (val) =>
                          setState(() => _weekendRate = val),
                      child: _weekendRate
                          ? Column(
                        children: [
                          12.verticalSpace,
                          _buildPriceField(_weekendRateController),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),
                    24.verticalSpace,

                    // ── MINIMUM BOOKING DURATION ──
                    Text(
                      "MINIMUM BOOKING DURATION",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF777777),
                        letterSpacing: 1.2,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      "Set shortest session length you accept",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF272727),
                      ),
                    ),
                    8.verticalSpace,

                    // ── Duration Input Field ──
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12.r),
                        border: _durationError != null
                            ? Border.all(
                          color: const Color(0xFFE53935),
                          width: 1.2,
                        )
                            : null,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 4.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minDurationController,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*')),
                              ],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF272727),
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter Your Amount",
                                hintStyle: TextStyle(
                                  color: const Color(0xFFAAAAAA),
                                  fontSize: 13.sp,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _durationError = _validateDuration(val);
                                });
                              },
                            ),
                          ),
                          Text(
                            "h",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Error or hint below field ──
                    4.verticalSpace,
                    if (_durationError != null)
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 13.sp,
                            color: const Color(0xFFE53935),
                          ),
                          4.horizontalSpace,
                          Expanded(
                            child: Text(
                              _durationError!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFFE53935),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        "Minimum is 30 minutes (0.5h). e.g. 0.5, 1, 1.5, 2",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF999999),
                        ),
                      ),

                    32.verticalSpace,
                  ],
                ),
              ),
            ),

            // ── Continue Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                    if (_baseRateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("Please enter base rate")),
                      );
                      return;
                    }

                    // block if duration is invalid
                    final durErr = _validateDuration(
                        _minDurationController.text);
                    if (durErr != null) {
                      setState(() => _durationError = durErr);
                      return;
                    }

                    setState(() => _isSubmitting = true);
                    try {
                      final controller =
                          SignUpChefController.instance;

                      final Map<String, dynamic> weekDaysDiscount =
                      _offerDiscount
                          ? {
                        "from": _formatTime(_fromTime),
                        "to": _formatTime(_toTime),
                        "amount": _discountRateController
                            .text
                            .trim(),
                      }
                          : {};

                      await controller.setupChefPrice(
                        pricing: _baseRateController.text.trim(),
                        weekDaysDiscountHas: _offerDiscount,
                        weekDaysDiscount: weekDaysDiscount,
                        weekendDiscountHas: _weekendRate,
                        weekendDiscountAmount:
                        _weekendRateController.text.trim().isEmpty
                            ? "0"
                            : _weekendRateController.text.trim(),
                        minimumShortOrderHours:
                        _minDurationController.text.trim().isEmpty
                            ? "1"
                            : _minDurationController.text.trim(),
                      );
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    "Continue",
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
      ),
    );
  }

  Widget _buildPriceField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Text(
            "\$",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF272727),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF272727),
              ),
              decoration: const InputDecoration(
                hintText: "Enter Your Amount",
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            "/h",
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF272727),
                    height: 1.4,
                  ),
                ),
              ),
              12.horizontalSpace,
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF1C1C1C),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCCCCCC),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF777777),
              ),
            ),
            const Spacer(),
            Text(
              _formatTime(time),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
              ),
            ),
          ],
        ),
      ),
    );
  }
}