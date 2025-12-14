import 'package:flutter/cupertino.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';

List<String> _list = [
  "Chinese",
  "American",
  "Italian",
  "Indian",
  "Japanese",
  "Chinese",
];

Widget category() {
  return ListView.builder(
    itemCount: _list.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      String value = _list[index];
      return Container(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            CommonImage(imageSrc: AppImages.image2, size: 60),
            CommonText(
              text: value,
              fontSize: 12,
              color: Color(0xff272727),
              top: 8,
            ),
          ],
        ),
      );
    },
  );
}
