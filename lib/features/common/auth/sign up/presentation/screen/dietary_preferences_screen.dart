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
                    fontWeight: FontWeight.w600,
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
                    hintText: AppString.search,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Icon(CupertinoIcons.search),
                    ),
                    paddingHorizontal: 10,
                    controller: controller.dietarySearchController,
                    onChanged: (value) {
                      controller.onSearchDietary(value);
                    },
                  ),
                  20.height,

                  /// Loading state
                  if (controller.isLoadingDietary)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.filteredDietaryOption.length,
                        itemBuilder: (context, index) {
                          String value =
                          controller.filteredDietaryOption[index];
                          return InkWell(
                            onTap: () {
                              controller.onChangeDietary(value);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 15.sp,
                                    height: 15.sp,
                                    decoration: BoxDecoration(
                                      color: controller.selectDietary
                                          .contains(value)
                                          ? Color(0xff272727)
                                          : Color(0xffF1F1F1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: !controller.selectDietary
                                        .contains(value)
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
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonButton(
                titleText: AppString.continueString,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Get.toNamed(AppRoutes.reviewDetail);
                  }
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => Get.find<SignUpController>().completeProfile(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff272727),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}