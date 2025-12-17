import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

Widget switchButton({required bool value, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: 20,
      width: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: !value ? Colors.black.withOpacity(0.20) : Color(0xff272727),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(2),
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: value ? Colors.white : AppColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}
