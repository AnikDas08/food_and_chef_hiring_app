import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingBannerPopup {
  static OverlayEntry? _entry;

  static void show(
      BuildContext context, {
        String? image,
        required String title,
        required String subtitle,
        VoidCallback? onTap,
        Duration duration = const Duration(seconds: 5),
      }) {
    _entry?.remove();
    _entry = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _BookingBannerWidget(
        image: image,
        title: title,
        subtitle: subtitle,
        onTap: () {
          onTap?.call();
          entry.remove();
          _entry = null;
        },
        onDismiss: () {
          entry.remove();
          _entry = null;
        },
        duration: duration,
      ),
    );

    _entry = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

// ── Internal animated widget ──
class _BookingBannerWidget extends StatefulWidget {
  final String? image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final Duration duration;

  const _BookingBannerWidget({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_BookingBannerWidget> createState() => _BookingBannerWidgetState();
}

class _BookingBannerWidgetState extends State<_BookingBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    // Auto dismiss
    Future.delayed(widget.duration, () {
      if (mounted) _dismiss();
    });
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Image / Icon ──
                      Container(
                        width: 54.r,
                        height: 54.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: widget.image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            widget.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(
                          Icons.delivery_dining_rounded,
                          color: const Color(0xFFE84325),
                          size: 28.r,
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // ── Text ──
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.6),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // ── Arrow ──
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withOpacity(0.5),
                        size: 22.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}