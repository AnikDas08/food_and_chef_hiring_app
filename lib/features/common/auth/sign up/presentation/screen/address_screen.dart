
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: const CommonImage(
                imageSrc: AppIcons.backIcon,
                size: 24,
              ),
            ),
          ),
        ),
      ),

      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.enterYourAddress,
                    fontSize: 24,
                    color: Color(0xff272727),
                    fontWeight: FontWeight.w600,
                    top: 10,
                  ),

                  const CommonText(
                    text: AppString.weveSentAnEmailToDarrenmonarchGmailCom,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    maxLines: 2,
                    top: 8,
                    textAlign: TextAlign.start,
                    bottom: 28,
                  ),

                  CommonTextField(
                    controller: controller.addressController,
                    hintText: AppString.enterYourAddress,
                    validator: OtherHelper.validator,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(CupertinoIcons.search),
                    ),
                    paddingHorizontal: 10,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: CommonImage(imageSrc: AppIcons.map, size: 24),
                    ),
                  ),
                  20.height,

                  const CommonText(
                    text: AppString.suggestedAddress,
                    color: Color(0xff777777),
                    fontSize: 12,
                    bottom: 6,
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              const CommonImage(imageSrc: AppIcons.address),
                              12.width,
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: 'New Mexico',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                  CommonText(
                                    text:
                                        '4140 Parker Rd. Allentown, New Mexico 31134',
                                    fontSize: 12,
                                    top: 2,
                                    color: Color(0xff777777),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// Submit Button Here
                ],
              ),
            ),
          );
        },
      ),

      /// Bottom Section Starts Here
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 16, left: 16),
        child: CommonButton(
          titleText: AppString.continueString,
          onTap: () {
            if (_formKey.currentState!.validate()) {
              Get.toNamed(AppRoutes.dietaryPreferences);
            }
          },
        ),
      ),
    );
  }
}
