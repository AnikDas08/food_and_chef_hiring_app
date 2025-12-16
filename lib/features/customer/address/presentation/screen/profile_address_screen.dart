import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../../../../../config/route/app_routes.dart';
import '../controller/address_controller.dart';
import '../widgets/address_item.dart';

class ProfileAddressScreen extends StatelessWidget {
  const ProfileAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GetBuilder<AddressController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.address,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  CommonText(
                    text: "ACTIVE ADDRESS",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff777777),
                    top: 24,
                    bottom: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return addressItem();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
          child: CommonButton(
            titleText: AppString.addNewAddress,
            buttonRadius: 30,
            buttonHeight: 48,
            titleSize: 14,
            titleWeight: FontWeight.w600,
            onTap: () {
              Get.toNamed(AppRoutes.addAddress);
            },
          ),
        ),
      ),
    );
  }
}
