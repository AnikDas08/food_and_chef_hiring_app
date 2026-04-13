import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/sign_up_chef_controller.dart';

class CafeEnableAutoAcceptScreen extends StatefulWidget {
  const CafeEnableAutoAcceptScreen({super.key});

  @override
  State<CafeEnableAutoAcceptScreen> createState() =>
      _CafeEnableAutoAcceptScreenState();
}

class _CafeEnableAutoAcceptScreenState
    extends State<CafeEnableAutoAcceptScreen> {
  bool _autoAccept = true;
  bool _isSubmitting = false;


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

            // ── Content ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,

                    // Title
                    Text(
                      "Enable Auto-Accept Orders",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF272727),
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    12.verticalSpace,

                    // Subtitle
                    Text(
                      "Do you want to automatically accept orders from customers from times that are in your availability? Or would you rather have the option to approve or decline orders?",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF777777),
                        height: 1.5,
                      ),
                    ),
                    24.verticalSpace,

                    // ── Toggle Card ──
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 4.h),
                      child: Row(
                        children: [
                          Text(
                            "Enable Auto-Accept",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF272727),
                            ),
                          ),
                          const Spacer(),
                          Switch.adaptive(
                            value: _autoAccept,
                            onChanged: (val) =>
                                setState(() => _autoAccept = val),
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFF1C1C1C),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFCCCCCC),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,

                    // Info text
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Chefs with auto-accept enabled earn on average ",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: "1.6x",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF272727),
                            ),
                          ),
                          TextSpan(
                            text: " more.",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    setState(() => _isSubmitting = true);
                    try {
                      final controller = SignUpChefController.instance;
                      await controller.setupAutoAccept(autoAccept: _autoAccept);
                    } finally {
                      if (mounted) setState(() => _isSubmitting = false);
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
}