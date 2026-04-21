import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

Widget orderSummary() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommonText(
        text: 'Order Summary',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xff272727),
        bottom: 19,
      ),
      _item('Subtotal', '\$58.32'),
      11.height,
      _item('Fees', '\$16'),
      11.height,
      _item('Estimated Taxes', '\$13'),
      11.height,
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: 'Total',
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
          CommonText(
            text: '\$268.05',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
        ],
      ),




    ],
  );
}

Widget _item(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CommonText(
        text: title,
        fontWeight: FontWeight.w400,
        color: const Color(0xff777777),
      ),
      CommonText(
        text: value,
        fontWeight: FontWeight.w400,
        color: const Color(0xff272727),
      ),
    ],
  );
}
