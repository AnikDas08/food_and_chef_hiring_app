import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
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
          (controller) => Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
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
                      CommonText(
                        text: AppString.clearFilters,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFD713F),
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
                    top: 16,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            margin: EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color:
                                  controller.selectTime.contains(value)
                                      ? Color(0xffFD713F)
                                      : Color(0xffF8F4F1),
                            ),
                            child:
                                CommonText(
                                  text: value,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      controller.selectTime.contains(value)
                                          ? Color(0xffFFFFFF)
                                          : Color(0xffFD713F),
                                ).center,
                          ),
                        );
                      },
                    ),
                  ),

                  Divider(),
                  CommonText(
                    text: AppString.chefProfessionalLevel,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1F1F1F),
                    top: 16,
                    bottom: 12,
                  ),

                  SizedBox(
                    height: 30.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.levelOption.length,
                      itemBuilder: (context, index) {
                        String value = controller.levelOption[index];
                        return InkWell(
                          onTap: () => controller.onChangeTime(value),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            margin: EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color:
                                  controller.selectLevel.contains(value)
                                      ? Color(0xffFD713F)
                                      : Color(0xffF8F4F1),
                            ),
                            child:
                                CommonText(
                                  text: value,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      controller.levelOption.contains(value)
                                          ? Color(0xffFFFFFF)
                                          : Color(0xffFD713F),
                                ).center,
                          ),
                        );
                      },
                    ),
                  ),

                  50.height,
                ],
              ),
            ),
          ),
    );
  }
}
