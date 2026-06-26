import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../utils/constants/app_icons.dart';
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
  TextEditingController(text: '');
  final TextEditingController _discountRateController =
  TextEditingController(text: '');
  final TextEditingController _weekendRateController =
  TextEditingController(text: '');
  final TextEditingController _minDurationController =
  TextEditingController(text: '');

  bool _offerDiscount = true;
  bool _weekendRate = false;

  TimeOfDay _fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _toTime = const TimeOfDay(hour: 15, minute: 0);
  bool _isSubmitting = false;

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

  String? _validateDuration(String value) {
    if (value.trim().isEmpty) return null;
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Please enter a valid number';
    if (parsed < 1) return 'Minimum booking duration is 1 hour';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Set Your Price',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.left,
                    ),
                    8.verticalSpace,

                    const CommonText(
                      text:
                      'Set your hourly rate that customers will pay you to cook for them! No pressure though--you can change this any time.',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777),
                      textAlign: TextAlign.left,
                      maxLines: 4,
                    ),
                    24.verticalSpace,

                    const CommonText(
                      text: 'PRICING',
                      fontSize: 11,
                      color: Color(0xFF777777),
                      textAlign: TextAlign.left,
                    ),
                    12.verticalSpace,

                    const CommonText(
                      text: 'Set Amount',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.left,
                    ),
                    8.verticalSpace,
                    _buildPriceField(_baseRateController),
                    20.verticalSpace,

                    // ── Weekday Discount Toggle ──
                    _buildToggleCard(
                      title:
                      'Offer discounted rate during specific\nhours on weekdays',
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
                                  label: 'From',
                                  time: _fromTime,
                                  onTap: () => _pickTime(true),
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: _buildTimeField(
                                  label: 'To',
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
                      title: 'Ask for higher rate on weekends',
                      value: _weekendRate,
                      onChanged: (val) =>
                          setState(() => _weekendRate = val),
                      child: _weekendRate
                          ? Column(
                        children: [
                          _buildPriceField(_weekendRateController),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),
                    24.verticalSpace,

                    // ── MINIMUM BOOKING DURATION ──
                    const CommonText(
                      text: 'MINIMUM BOOKING DURATION',
                      fontSize: 11,
                      color: Color(0xFF777777),
                      textAlign: TextAlign.left,
                    ),
                    12.verticalSpace,

                    const CommonText(
                      text: 'Set shortest session length you accept',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.left,
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF272727),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter hours',
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
                          const CommonText(
                            text: '/h',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF777777),
                          ),
                        ],
                      ),
                    ),

                    // ── Error or Hint ──
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
                            child: CommonText(
                              text: _durationError!,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFE53935),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )
                    else
                      const CommonText(
                        text: 'Use whole hours only — for example: 1h 2h 3h.',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                        textAlign: TextAlign.left,
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
                            content: Text('Please enter base rate')),
                      );
                      return;
                    }

                    final durErr = _validateDuration(
                        _minDurationController.text);
                    if (durErr != null) {
                      setState(() => _durationError = durErr);
                      return;
                    }

                    setState(() => _isSubmitting = true);
                    try {
                      final controller = SignUpChefController.instance;

                      final Map<String, dynamic> weekDaysDiscount =
                      _offerDiscount
                          ? {
                        'from': _formatTime(_fromTime),
                        'to': _formatTime(_toTime),
                        'amount': _discountRateController.text
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
                            ? '0'
                            : _weekendRateController.text.trim(),
                        minimumShortOrderHours:
                        _minDurationController.text.trim().isEmpty
                            ? '1'
                            : _minDurationController.text.trim(),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isSubmitting = false);
                      }
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

  Widget _buildPriceField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          const CommonText(
            text: '\$',
            color: Color(0xFF272727),
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
                hintText: 'Enter Your Amount',
                border: InputBorder.none,
              ),
            ),
          ),
          const CommonText(
            text: '/h',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF777777),
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
                child: CommonText(
                  text: title,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF272727),
                  textAlign: TextAlign.left,
                  maxLines: 3,
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
            CommonText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF777777),
            ),
            const Spacer(),
            CommonText(
              text: _formatTime(time),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF272727),
            ),
          ],
        ),
      ),
    );
  }
}