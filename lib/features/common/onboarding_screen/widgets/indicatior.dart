import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget indicator({required int currentIndex}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8.sp,
        width: 8.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == currentIndex ? const Color(0xff272727) : const Color(0xffF1F1F1),
        ),
      ),
    ),
  );
}
