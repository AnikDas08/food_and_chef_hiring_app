import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../config/route/app_routes.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/app_string.dart';

class DoNotHaveAccount extends StatelessWidget {
  const DoNotHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppString.doNotHaveAccount,
            style: TextStyle(
              color: const Color(0xff818181),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Sign Up Button here
          TextSpan(
            text: AppString.register,
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(AppRoutes.signUp);
                  },
            style: TextStyle(
              color: const Color(0xff272727),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
