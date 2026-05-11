import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../component/text/common_text.dart';

class GroceryItemTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final bool isLast;

  const GroceryItemTile({
    super.key,
    required this.data,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
      child: Row(
        children: [
          // ICON CONTAINER instead of NetworkImage
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              // Light orange/grey background to match your theme
              color: const Color(0xffFFF2EE),
            ),
            child: Center(
              child: Icon(
                Icons.shopping_basket_outlined, // You can also use data['icon'] if available
                color: const Color(0xffFD713F), // Theme color
                size: 28.sp,
              ),
            ),
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                    text: data['name'] ?? '',
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                ),
                SizedBox(height: 4.h),
                // Showing Quantity and Unit (e.g., 2 kg)
                CommonText(
                    text: "${data['items']} ${data['unit'] ?? ''}",
                    color: Color(0xff777777),
                    fontSize: 12
                ),
              ],
            ),
          ),

          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Icon(
                data['isSelected'] ? Icons.check_circle : Icons.circle_outlined,
                color: data['isSelected'] ? Color(0xff272727) : Color(0xff777777),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}