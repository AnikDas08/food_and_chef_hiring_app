import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_colors.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    super.key,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.color = AppColors.black,
    required this.text,
    this.height,
    this.overflow = TextOverflow.ellipsis,
  });

  final double left;
  final double right;
  final double? height;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left.w,
        right: right.w,
        top: top.h,
        bottom: bottom.h,
      ),

      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          height: height ?? getLetterHeight(fontSize, fontWeight),
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: getLetterSpacing(fontSize, fontWeight),
        ),
      ),
    );
  }
}

double getLetterSpacing(double fontSize, FontWeight fontWeight) {
  switch (fontSize) {
    case 24:
      switch (fontWeight) {
        case FontWeight.w600:
          return -0.60;
        case FontWeight.w500:
          return -0.45;
        case FontWeight.w400:
          return -0.30;
        default:
          return -0.30;
      }

    case 16:
      switch (fontWeight) {
        case FontWeight.w600:
          return -0.35;
        case FontWeight.w500:
          return -0.25;
        case FontWeight.w400:
          return -0.15;
        default:
          return -0.15;
      }

    case 14:
      switch (fontWeight) {
        case FontWeight.w600:
          return -0.28;
        case FontWeight.w500:
          return -0.20;
        case FontWeight.w400:
          return -0.10;
        default:
          return -0.10;
      }

    case 12:
      switch (fontWeight) {
        case FontWeight.w600:
          return -0.20;
        case FontWeight.w500:
          return -0.12;
        case FontWeight.w400:
          return -0.05;
        default:
          return -0.05;
      }

    case 10:
      switch (fontWeight) {
        case FontWeight.w600:
          return -0.15;
        case FontWeight.w500:
          return -0.08;
        case FontWeight.w400:
          return -0.02;
        default:
          return -0.02;
      }

    default:
      return 0;
  }
}

double getLetterHeight(double fontSize, FontWeight fontWeight) {
  if (fontSize < 12) {
    return 1.6;
  } else {
    return 1.3;
  }
}
