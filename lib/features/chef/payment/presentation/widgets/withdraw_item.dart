import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

Color _status(String status) {
  if (status.toLowerCase() == "completed") return Color(0xff2F8328);
  if (status.toLowerCase() == "pending") return Color(0xffE39400);
  if (status.toLowerCase() == "failed") return Color(0xffFF3C3C);
  return Color(0xff2F8328);
}

Widget withdrawItem({required Map item}) {
  return Container(
    margin: EdgeInsets.only(bottom: 32.h),
    child: Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Color(0xffF9F9F9),
            shape: BoxShape.circle,
          ),
          child:
              CommonImage(
                imageSrc: AppIcons.download,
                imageColor: Color(0xffFD713F),
              ).center,
        ),
        12.width,
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  CommonText(
                    text: item['title'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonText(
                    text: item['status'],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _status(item['status']),
                    left: 8,
                  ),
                  Spacer(),
                  CommonText(
                    text:
                        "${item['isWithdraw'] ? "-" : "+"} \$${item['amount']}",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        item['isWithdraw']
                            ? Color(0xff272727)
                            : Color(0xff2F8328),
                  ),
                ],
              ),
              2.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: item['subTitle'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: item['date'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
