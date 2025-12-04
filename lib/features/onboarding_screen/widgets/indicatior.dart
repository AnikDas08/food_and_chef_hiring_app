import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget indicator({required int currentIndex}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
      (index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 8.sp,
        width: 8.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == currentIndex ? Color(0xffFD713F) : Colors.grey,
        ),
      ),
    ),
  );
}
