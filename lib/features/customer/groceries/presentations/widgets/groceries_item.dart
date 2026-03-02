import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../component/text/common_text.dart';

class GroceryItemTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const GroceryItemTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/205'), // Use data image if available
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(text: data['name'], fontWeight: FontWeight.w600, fontSize: 16),
                SizedBox(height: 4.h),
                CommonText(text: "${data['items']} items", color: Colors.grey, fontSize: 13),
                SizedBox(height: 4.h),
                CommonText(text: "\$${data['price'].toStringAsFixed(2)}", fontWeight: FontWeight.bold),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Icon(
              data['isSelected'] ? Icons.check_circle : Icons.circle_outlined,
              color: data['isSelected'] ? Colors.black : Colors.grey[300],
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}