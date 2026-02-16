import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: "Withdraw",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
    );
  }
}
