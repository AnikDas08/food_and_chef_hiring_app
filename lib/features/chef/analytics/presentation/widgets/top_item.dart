import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import 'menu_top_item.dart';

Widget topItem() {
  return Container(
    margin: EdgeInsets.only(top: 48),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: AppString.topItems,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CommonText(
                    text: "Most Picked",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff272727),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 8,
          itemBuilder: (context, index) {
            return MenuTopItem(value: index + 1);
          },
        ),
      ],
    ),
  );
}
