import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/switch_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/home_controller.dart';

filterPanel() {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: Get.context!,
    barrierColor: Colors.grey,
    isScrollControlled: true,
    builder: (context) {
      return const Filter();
    },
  );
}

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder:
          (controller) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: Get.size.height - 150.h,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: AppString.filters,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                          InkWell(
                            onTap: Get.back,
                            child: CommonText(
                              text: AppString.clearFilters,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffFD713F),
                            ),
                          ),
                        ],
                      ),

                      Divider(color: Color(0xffF1F1F1), height: 32.h),

                      CommonText(
                        text: AppString.price,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F1F1F),
                      ),
                      CommonText(
                        text: AppString.selectARangeOfValues,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                        top: 12,
                      ),
                      RangeSlider(
                        values: controller.values,
                        min: 0,
                        max: 100,
                        activeColor: Color(0xff272727),
                        inactiveColor: Color(0xffEFEFEF),
                        labels: RangeLabels(
                          controller.values.start.round().toString(),
                          controller.values.end.round().toString(),
                        ),
                        onChanged: controller.onChangeValue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "\$0/hr",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff777777),
                          ),
                          CommonText(
                            text: "\$100/hr",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff777777),
                          ),
                        ],
                      ),

                      Divider(color: Color(0xffF1F1F1), height: 32.h),
                      CommonText(
                        text: AppString.timeAvailability,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F1F1F),
                        bottom: 12,
                      ),

                      SizedBox(
                        height: 30.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.timeOption.length,
                          itemBuilder: (context, index) {
                            String value = controller.timeOption[index];
                            return InkWell(
                              onTap: () => controller.onChangeTime(value),
                              child: Container(
                                margin: EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color:
                                      controller.selectTime.contains(value)
                                          ? Color(0xff272727)
                                          : Color(0xffEFEFEF),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 7.h,
                                  ),
                                  child: CommonText(
                                    text: value,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        controller.selectTime.contains(value)
                                            ? Colors.white
                                            : Color(0xff272727),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Divider(color: Color(0xffF1F1F1), height: 32.h),
                      CommonText(
                        text: AppString.chefProfessionalLevel,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F1F1F),
                        bottom: 12,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children:
                              controller.levelOption.map((value) {
                                return InkWell(
                                  onTap: () => controller.onChangeLevel(value),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:
                                          controller.selectLevel.contains(value)
                                              ? const Color(0xff272727)
                                              : const Color(0xffEFEFEF),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    child: CommonText(
                                      text: value,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          controller.selectLevel.contains(value)
                                              ? Colors.white
                                              : const Color(0xff272727),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),

                      Divider(color: Color(0xffF1F1F1), height: 32.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(text: AppString.savedChefsOnly),
                          switchButton(
                            value: controller.saved,
                            onTap: controller.onChangeSaved,
                            color: Color(0xff2F8328),
                          ),
                        ],
                      ),
                      Divider(color: Color(0xffF1F1F1), height: 32.h),
                      CommonText(
                        text: AppString.cuisine,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F1F1F),
                        bottom: 12,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children:
                              controller.cuisineOption.map((value) {
                                return InkWell(
                                  onTap:
                                      () => controller.onChangeCuisine(value),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:
                                          controller.selectCuisine.contains(
                                                value,
                                              )
                                              ? const Color(0xff272727)
                                              : const Color(0xffEFEFEF),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    child: CommonText(
                                      text: value,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          controller.selectCuisine.contains(
                                                value,
                                              )
                                              ? Colors.white
                                              : const Color(0xff272727),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),

                      Divider(color: Color(0xffF1F1F1), height: 32.h),
                      CommonText(
                        text: AppString.dietaryPreferences,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F1F1F),
                        bottom: 12,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children:
                              controller.dietaryOption.map((value) {
                                return InkWell(
                                  onTap:
                                      () => controller.onChangeDietary(value),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:
                                          controller.selectDietary.contains(
                                                value,
                                              )
                                              ? const Color(0xff272727)
                                              : const Color(0xffEFEFEF),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    child: CommonText(
                                      text: value,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          controller.selectDietary.contains(
                                                value,
                                              )
                                              ? Colors.white
                                              : const Color(0xff272727),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      24.height,
                      CommonButton(
                        titleText: AppString.apply,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
