import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/text/common_text.dart';

Widget withdrawItem({required Map item}) {
  final bool isDeduct = item['isDeduct'] ?? false;
  final String status = item['status'] ?? '';

  // ✅ Status color
  Color statusColor;
  if (status == 'Success' || status == 'Completed') {
    statusColor = const Color(0xff22C55E); // green
  } else if (status == 'Pending') {
    statusColor = const Color(0xffF59E0B); // orange
  } else if (status == 'Failed') {
    statusColor = const Color(0xffEF4444); // red
  } else {
    statusColor = Colors.grey;
  }

  final Color amountColor =
  isDeduct ? const Color(0xff272727) : const Color(0xff22C55E);
  final String amountPrefix = isDeduct ? '- ' : '+ ';

  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    child: Row(
      children: [
        // Icon
        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: Color(0xffFFF4ED),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.paid,
            color: const Color(0xffF97316),
            size: 20.sp,
          ),
        ),

        SizedBox(width: 12.w),

        // Title + subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CommonText(
                    text: item['title'] ?? '',
                    fontSize: 13.sp,
                    color: const Color(0xff272727),
                  ),
                  SizedBox(width: 8.w),
                  // ✅ Status দেখাবে API থেকে
                  CommonText(
                    text: status,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: statusColor,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              CommonText(
                text: item['subTitle'] ?? '',
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff9CA3AF),
              ),
            ],
          ),
        ),

        // Amount + date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            CommonText(
              text: "$amountPrefix\$${item['amount']}",
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
            SizedBox(height: 4.h),
            CommonText(
              text: item['date'] ?? '',
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff9CA3AF),
            ),
          ],
        ),
      ],
    ),
  );
}