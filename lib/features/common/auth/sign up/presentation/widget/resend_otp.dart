import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/app_string.dart';
import '../controller/sign_up_controller.dart';

class ResendOtp extends StatelessWidget {
  const ResendOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          /// Already Have Account
          const TextSpan(
            text: AppString.didNotReceiveTheCode,
            style: TextStyle(
              color: Color(0xff818181),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),

          /// Sign In Button Here
          TextSpan(
            text: AppString.resend,
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Get.find<SignUpController>().resendOtp();
                  },
            style: const TextStyle(
              color: Color(0xff272727),
              fontWeight: FontWeight.w500,
              fontSize: 12
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
