import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../services/api/api_service.dart';

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

    // Pulse animation for the orange circle
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
          Navigator.pop(context);
          _timer?.cancel();
          widget.onDone?.call(_elapsed);
          Get.back();
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
            // ── Back button ──
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: Color(0xFF1A1A1A)),
              ),
            ),

            // ── Title ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cooking stop watch',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Set a stop watch to measure the amount of time spent\ncooking, and then stop the timer when you are done.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 36.h),

            // ── Timer Circle ──
            Center(
              child: ScaleTransition(
                scale: _isRunning ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
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
                      Text(
                        'Cooking time',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w400,
                        ),
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
                        ),
                      ),
                      if (!_isRunning) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            'Paused',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 36.h),

            // ── Order Details ──
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
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.orderItems.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 16.h,
                          color: Colors.grey[300],
                        ),
                        itemBuilder: (_, i) {
                          final item = widget.orderItems[i];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      item.description,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[500],
                                      ),
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
                                    color: Colors.grey[200], // loading এর সময় background
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.network(
                                      item.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 24.r,
                                        );
                                      },
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) return child;
                                        return Center(
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

            // ── Pause / Stop Buttons ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20.w, 0, 20.w, MediaQuery.of(context).padding.bottom + 16.h),
              child: Row(
                children: [
                  // Pause
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
                              color: const Color(0xFF1A1A1A),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              _isRunning ? 'Pause' : 'Resume',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Stop
                  Expanded(
                    child: GestureDetector(
                      onTap: _onStopPressed,
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
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
                            Text(
                              'Stop',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
  final String orderId; // ← যোগ করো
  final VoidCallback onConfirm;
  final VoidCallback onCheckAgain;

  const _StopConfirmationDialog({
    required this.totalTime,
    required this.orderId, // ← যোগ করো
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
            Container(
              width: 56.r,
              height: 56.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5A623),
              ),
              child: Icon(Icons.priority_high_rounded,
                  color: Colors.white, size: 28.r),
            ),
            SizedBox(height: 16.h),
            Text(
              "Are you sure you're done ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Are you sure that all recipes have been prepared and the kitchen is cleaned up?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Total cooking time: ${_formatShort(totalTime)}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                try {
                  final timeString = _formatShort(totalTime);
                  final response = await ApiService.post(
                    "order/clearence/$orderId",
                    body: {"time": timeString},
                  );
                  if (response.statusCode == 200 || response.statusCode == 201) {
                    onConfirm();
                    Get.snackbar("Message", "Successfully submitted cooking time",backgroundColor: Colors.green);
                  } else {
                    Get.snackbar("Error", "Failed to submit cooking time");
                  }
                } catch (e) {
                  Get.snackbar("Error", e.toString());
                }
              },
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text("I'm sure",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.white),
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
                  child: Text('Check again',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
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