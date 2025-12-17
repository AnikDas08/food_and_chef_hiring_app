import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../../../../../utils/constants/app_colors.dart';
import '../widgets/availability_item.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: AppString.availability,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 20,
              ),

              ListView.builder(
                itemCount: 7,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AvailabilityItem();
                },
              ),

              CommonText(
                text: "Booking Preferences",
                bottom: 16,
                top: 16,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff777777),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    /// Already Have Account
                    TextSpan(
                      text: "Customers can place orders at least ",
                      style: GoogleFonts.inter(
                        color: Color(0xff777777),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    /// Sign In Button Here
                    TextSpan(
                      text: "12 Hours",
                      style: GoogleFonts.inter(
                        color: Color(0xffFD713F),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "in advance and a maximum of ",
                      style: GoogleFonts.inter(
                        color: Color(0xff777777),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "14 Days",
                      style: GoogleFonts.inter(
                        color: Color(0xffFD713F),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "in advance",
                      style: GoogleFonts.inter(
                        color: Color(0xff777777),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
