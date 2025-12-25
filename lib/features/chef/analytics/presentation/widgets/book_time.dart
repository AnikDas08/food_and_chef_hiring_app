import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/text/common_text.dart';

import 'chart.dart';

class BookTime extends StatelessWidget {
  const BookTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 243.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: "Most Booked Times",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CommonText(
                      text: "Mondays",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff272727),
                      right: 4,
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined),
                  ],
                ),
              ),
            ],
          ),
          Expanded(child: BarChartSample3()),
        ],
      ),
    );
  }
}
