import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Terms: ',
            style: TextStyle(
              color: Color(0xff222222),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Sign Up Button here
          TextSpan(
            text: 'All prices incl. VAT. For your order the ',
            style: TextStyle(
              color: Color(0xff636363),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Privae Chef Terms & conditions apply',
            style: TextStyle(
              color: Color(0xff2F8328),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.start,
    );
  }
}
