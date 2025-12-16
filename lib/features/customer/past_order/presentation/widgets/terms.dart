import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Terms: ",
            style: GoogleFonts.inter(
              color: Color(0xff222222),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Sign Up Button here
          TextSpan(
            text: "All prices incl. VAT. For your order the ",
            style: GoogleFonts.plusJakartaSans(
              color: Color(0xff636363),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: "Privae Chef Terms & conditions apply",
            style: GoogleFonts.plusJakartaSans(
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
