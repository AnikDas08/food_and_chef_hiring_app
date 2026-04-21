import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../image/common_image.dart';
import '../text/common_text.dart';

class Item extends StatelessWidget {
  const Item({
    super.key,
    this.icon,
    required this.title,
    this.image = '',
    this.disableDivider = false,
    this.onTap,
    this.color = const Color(0xff272727),
    this.vertical = 14,
    this.horizontal = 0,
    this.disableIcon = false,
    this.imageSize,
    this.imgColor = const Color(0xff272727),
  });

  final IconData? icon;
  final String title;
  final String image;
  final bool disableDivider;
  final bool disableIcon;
  final VoidCallback? onTap;
  final Color color;
  final Color imgColor;
  final double vertical;
  final double horizontal;
  final double? imageSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal.w,
          vertical: vertical.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                icon != null
                    ? Icon(icon, color: color)
                    : CommonImage(
                      imageSrc: image,
                      size: imageSize,
                      imageColor: imgColor,
                    ),
                CommonText(
                  text: title,
                  color: color,
                  left: 16,
                ),
                const Spacer(),
                disableIcon
                    ? const SizedBox()
                    : Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16.sp,
                      color: const Color(0xff777777),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
