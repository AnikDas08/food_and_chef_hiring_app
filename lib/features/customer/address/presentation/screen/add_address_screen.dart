import 'package:flutter/material.dart';

import '../../../../../component/text/common_text.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CommonText(
                text: "Add New Address",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
                bottom: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
