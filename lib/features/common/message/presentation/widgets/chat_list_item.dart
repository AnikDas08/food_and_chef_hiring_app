import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../../utils/extensions/extension.dart';

Widget chatListItem({required ChatModel item}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
    margin: EdgeInsets.only(bottom: 10),
    decoration: const BoxDecoration(
      color: Color(0xffF2F2F2),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Row(
      children: [
        /// participant image here
        CircleAvatar(
          radius: 22.sp,
          child: ClipOval(
            child: CommonImage(
              imageSrc: item.participant.image,
              size: 44,
              fill: BoxFit.fill,
            ),
          ),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// participant Name here
              CommonText(
                text: item.participant.fullName,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff272727),
              ),

              /// participant Last Message here
              CommonText(
                text: item.latestMessage.displayMessage,  // ← was .message
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xff777777),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CommonText(
              text: item.latestMessage.createdAt.time,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff272727),
              bottom: 8,
            ),
            Container(
              width: 8.sp,
              height: 8.sp,
              decoration: BoxDecoration(
                color: Color(0xffFD713F),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
