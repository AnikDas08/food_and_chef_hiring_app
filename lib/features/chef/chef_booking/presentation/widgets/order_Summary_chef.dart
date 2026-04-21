import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

Widget orderSummarychef({required Map order}) {
  final breakdown = order['price_breakdown'] ?? {};
  final hasDiscount = order['has_discount'] ?? false;
  final discountAmount = (order['discount_amount'] ?? 0).toDouble();

  final subtotal = (breakdown['subtotal'] ?? 0).toDouble();
  final tax = (breakdown['taxs'] ?? 0).toDouble();
  final serviceFee = (breakdown['service_fee'] ?? 0).toDouble();
  final total = (order['user_paid'] ?? breakdown['total'] ?? 0).toDouble();

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
      _item('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
      11.height,
      _item('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
      11.height,
      _item('Estimated Taxes', '\$${tax.toStringAsFixed(2)}'),
      if (hasDiscount) ...[
        11.height,
        _item('Discount', '-\$${discountAmount.toStringAsFixed(2)}', isDiscount: true),
      ],
      11.height,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CommonText(
            text: 'Total',
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
          CommonText(
            text: '\$${total.toStringAsFixed(2)}',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xff272727),
          ),
        ],
      ),
    ],
  );
}

Widget _item(String title, String value, {bool isDiscount = false}) {
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
        color: isDiscount ? const Color(0xff2F8328) : const Color(0xff272727),
      ),
    ],
  );
}