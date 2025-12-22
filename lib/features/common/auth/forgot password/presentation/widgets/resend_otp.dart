import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../../../config/route/app_routes.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/app_string.dart';

class ResendOtp extends StatelessWidget {
  const ResendOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppString.didNotReceiveTheCode,
            style: TextStyle(
              color: Color(0xff818181),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Sign Up Button here
          TextSpan(
            text: AppString.resend,
            recognizer:
            TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.signUp);
              },
            style: TextStyle(
              color: Color(0xff272727),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
