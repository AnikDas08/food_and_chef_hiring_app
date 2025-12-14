import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_string.dart';

class ResendOtp extends StatelessWidget {
  const ResendOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          /// Already Have Account
          TextSpan(
            text: AppString.didNotReceiveTheCode,
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Sign In Button Here
          TextSpan(
            text: AppString.signIn,
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    // Get.toNamed(AppRoutes.signIn);
                  },
            style: GoogleFonts.inter(
              color: Color(0xffFD713F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
