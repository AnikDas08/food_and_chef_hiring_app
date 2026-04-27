import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';


class NoNotification extends StatelessWidget {
  const NoNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            imageSrc: AppIcons.notification,
            height: 63.sp,
            width: 63.sp,
          ),
          const CommonText(
            text: AppString.noNotification,
            fontSize: 12,
            color: Color(0xff777777),
            top: 8,
          )
        ],
      ),
    );
  }
}
