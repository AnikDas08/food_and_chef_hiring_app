import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:get/get.dart';
import '../../../../../../component/button/common_button.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../component/text_field/common_text_field.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';

class DietaryPreferencesScreen extends StatelessWidget {
  DietaryPreferencesScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section Starts Here
      appBar: AppBar(),

      /// Body Section Starts Here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: AppString.dietaryPreferences,
                    fontSize: 24,
                    color: Color(0xff272727),
                    top: 10,
                  ),

                  const CommonText(
                    text: AppString.vegetarianKosherHalalFoodAllergies,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    maxLines: 2,
                    top: 8,
                    textAlign: TextAlign.start,
                    bottom: 28,
                  ),

                  CommonTextField(
                    hintText: AppString.dietaryPreferences,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(CupertinoIcons.search),
                    ),
                    paddingHorizontal: 10,
                  ),
                  20.height,

                  CommonText(
                    text: AppString.suggestedAddress,
                    color: Color(0xff777777),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    bottom: 6,
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.dietaryOption.length,
                      itemBuilder: (context, index) {
                        String value = controller.dietaryOption[index];
                        return InkWell(
                          onTap: () {
                            controller.onChangeDietary(value);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 15.sp,
                                  height: 15.sp,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.selectDietary.contains(value)
                                            ? Colors.black
                                            : Color(0xffF1F1F1),
                                    shape: BoxShape.circle,
                                  ),
                                  child:
                                      !controller.selectDietary.contains(value)
                                          ? null
                                          : Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                ),
                                CommonText(
                                  text: value,
                                  fontSize: 12,
                                  left: 8,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff272727),
                                ),
                              ],
                            ),
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
              Get.toNamed(AppRoutes.reviewDetail);
            }
          },
        ),
      ),
    );
  }
}
