import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

Widget orderSummary() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: "Order Summary",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
          bottom: 19,
        ),
        _item("Subtotal", "\$58.32"),
        11.height,
        _item("Fees", "\$16"),
        11.height,
        _item("Estimated Taxes", "\$13"),
        11.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: "Totals",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),
            CommonText(
              text: "\$268.05",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),
          ],
        ),
        42.height,



      ],
    ),
  );
}

Widget _item(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CommonText(
        text: title,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xff777777),
      ),
      CommonText(
        text: value,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xff272727),
      ),
    ],
  );
}
