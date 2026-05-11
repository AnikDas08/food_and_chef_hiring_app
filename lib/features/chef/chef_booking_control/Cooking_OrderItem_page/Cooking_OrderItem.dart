import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import '../../../../component/text/common_text.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/constants/app_colors.dart';

class CookingOrderItem {

  final String name;
  final String description;
  final String? image;

  const CookingOrderItem({
    required this.name,
    required this.description,
    this.image,
  });

}

class CookingStopwatchScreen extends StatefulWidget {

  final List<CookingOrderItem> orderItems;
  final String orderId;
  final void Function(Duration totalTime)? onDone;

  const CookingStopwatchScreen({
    super.key,
    required this.orderItems,
    required this.orderId,
    this.onDone,
  });

  @override
  State<CookingStopwatchScreen> createState() => _CookingStopwatchScreenState();

}

class _CookingStopwatchScreenState extends State<CookingStopwatchScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startTimer();

  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isRunning && mounted) {
        setState(() => _elapsed += const Duration(seconds: 1));
      }
    });
  }

  void _togglePause() {
    setState(() => _isRunning = !_isRunning);
  }

  void _onStopPressed() {
    setState(() => _isRunning = false);
    _showStopConfirmation();
  }

  void _showStopConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _StopConfirmationDialog(
        totalTime: _elapsed,
        orderId: widget.orderId,
        onConfirm: () {
          _timer?.cancel();
          widget.onDone?.call(_elapsed);
        },

        onCheckAgain: () {
          Navigator.pop(context);
          setState(() => _isRunning = true);
        },
      ),
    );
  }

  String _formatShort(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Back button + Title একই row এ ──
            Padding(
              padding: EdgeInsets.only(left: 4.w, right: 20.w, top: 8.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  CommonText(
                    text: 'Cooking stop watch',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 4.h),
              child: CommonText(
                text: 'Set a stop watch to measure the amount of time spent cooking, and then stop the timer when you are done.',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF777777),
                textAlign: TextAlign.start,
                maxLines: 3,
                height: 1.5,
              ),
            ),

            SizedBox(height: 36.h),

            // ── Timer Circle ──
            Center(
              child: ScaleTransition(
                scale: _isRunning
                    ? _pulseAnim
                    : const AlwaysStoppedAnimation(1.0),
                child: Container(
                  width: 220.r,
                  height: 220.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF07B3F),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF07B3F).withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: 'Cooking time',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.85),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _formatShort(_elapsed),
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          height: 1.3,
                        ),
                      ),
                      if (!_isRunning) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: CommonText(
                            text: 'Paused',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 36.h),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: 'Order Details',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.orderItems.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 16.h,
                          color: const Color(0xFFDDDDDD),
                        ),
                        itemBuilder: (_, i) {
                          final item = widget.orderItems[i];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: item.name,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 3.h),
                                    CommonText(
                                      text: item.description,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF777777),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              if (item.image != null)
                                Container(
                                  width: 52.r,
                                  height: 52.r,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: const Color(0xFFE0E0E0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.network(
                                      item.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.broken_image,
                                          color: const Color(0xFF9E9E9E),
                                          size: 24.r,
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFFF07B3F),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            Padding(

              padding: EdgeInsets.fromLTRB(
                20.w,
                0,
                20.w,
                MediaQuery.of(context).padding.bottom + 16.h,
              ),

              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _togglePause,
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 20.r,
                              color: AppColors.black,
                            ),
                            SizedBox(width: 6.w),
                            CommonText(
                              text: _isRunning ? 'Pause' : 'Resume',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: GestureDetector(
                      onTap: _onStopPressed,
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.stop_circle_outlined,
                              size: 20.r,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            CommonText(
                              text: 'Stop',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StopConfirmationDialog extends StatelessWidget {

  final Duration totalTime;
  final String orderId;
  final VoidCallback onConfirm;
  final VoidCallback onCheckAgain;

  const _StopConfirmationDialog({
    required this.totalTime,
    required this.orderId,
    required this.onConfirm,
    required this.onCheckAgain,
  });

  String _formatShort(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Warning icon ──
            Container(
              width: 56.r,
              height: 56.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5A623),
              ),
              child: Icon(
                Icons.priority_high_rounded,
                color: Colors.white,
                size: 28.r,
              ),
            ),

            SizedBox(height: 16.h),

            CommonText(
              text: "Are you sure you're done ?",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),

            SizedBox(height: 10.h),

            CommonText(
              text: 'Are you sure that all recipes have been prepared and the kitchen is cleaned up?',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF777777),
              textAlign: TextAlign.center,
              maxLines: 3,
              height: 1.5,
            ),

            SizedBox(height: 14.h),

            CommonText(
              text: 'Total cooking time: ${_formatShort(totalTime)}',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.h),

            GestureDetector(
              onTap: () async {
                try {
                  final timeString = _formatShort(totalTime);

                  final response = await ApiService.post(
                    'order/clearence/$orderId',
                    body: {'time': timeString},
                  );

                  if (response.statusCode == 200 || response.statusCode == 201) {

                    onConfirm();

                    final extraPrice = response.data?['data']?['extraPrice'] ?? 0;

                    final earning = (extraPrice as num).toStringAsFixed(2);

                    Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.celebration,
                                color: Colors.green,
                                size: 50,
                              ),

                              const SizedBox(height: 12),

                              CommonText(
                                text: "Congratulations 🎉",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),

                              const SizedBox(height: 10),

                              CommonText(
                                text: "You just earned $earning USD",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              CommonButton(
                                titleText: "Continue",
                                onTap: () {
                                  Get.back();
                                  Get.offAllNamed(
                                    AppRoutes.chefHomeScreen,
                                    arguments: {'index': 2, 'tab': 'Completed'},
                                  );
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                      barrierDismissible: false,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to submit cooking time',
                      backgroundColor: Colors.red,
                    );
                  }
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },

              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: CommonText(
                    text: "I'm sure",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            GestureDetector(
              onTap: onCheckAgain,
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: CommonText(
                    text: 'Check again',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}