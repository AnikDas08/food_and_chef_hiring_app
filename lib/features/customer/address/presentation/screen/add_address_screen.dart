import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/google_map/google_map.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/address_controller.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Add New Address",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 24,
                  ),

                  SizedBox(
                    height: 324,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ShowGoogleMap(onTapLatLong: (value) {}),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: CommonButton(
                              buttonHeight: 48,
                              buttonRadius: 20,
                              titleText: AppString.useCurrentLocation,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  CommonText(
                    text: AppString.addressDetails.toUpperCase(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff777777),
                    bottom: 12,
                    top: 24,
                  ),

                  CommonText(
                    text: AppString.addressLabel,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(
                    hintText: "Enter Address Label",
                    keyboardType: TextInputType.name,
                    controller: controller.addressLabelController,
                    suffixIcon: PopUpMenu(
                      items: controller.addressTypeList,
                      selectedItem: [controller.addressLabelController.text],
                      onTap: controller.onChangeAddressType,
                    ),
                  ),

                  CommonText(
                    text: AppString.address,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: "Enter Address",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CommonImage(
                          imageSrc: AppImages.house,
                          imageColor: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  CommonText(
                    text: AppString.detailedAddress,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: "Enter Detailed Address",
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  CommonText(
                    text: AppString.additionalAddress,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: AppString.additionalAddress,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  CommonText(
                    text: AppString.owner,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(hintText: AppString.owner),

                  CommonText(
                    text: AppString.phoneNumber,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(hintText: AppString.phoneNumber),

                  Row(
                    children: [
                      Checkbox(
                        activeColor: Color(0xffFD713F),
                        value: controller.isDefault,
                        onChanged: controller.onChangeDefaultAddress,
                      ),
                      Expanded(
                        child: CommonText(
                          text: AppString.makeAsActiveAddress,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),

      persistentFooterButtons: [
        SafeArea(
          child: Column(
            children: [
              10.height,
              CommonButton(titleText: AppString.addAddress, onTap: Get.back),
            ],
          ),
        ),
      ],
    );
  }
}
