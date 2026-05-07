import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';

Widget switchButton({
  required bool value,
  VoidCallback? onTap,
  Color color = const Color(0xff272727),
}) {
  return InkWell(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 31,
      width: 51,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: !value ? Colors.black.withValues(alpha: 0.20) : color,
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(3),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}