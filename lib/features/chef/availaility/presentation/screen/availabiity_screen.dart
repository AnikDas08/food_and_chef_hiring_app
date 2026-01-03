import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../../../chef_booking/presentation/widgets/pop_up.dart';
import '../controller/availiability_controller.dart';
import '../widgets/availability_item.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AvailabilityController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.availability,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 20,
                  ),

                  ListView.builder(
                    itemCount: controller.days.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AvailabilityItem(day: controller.days[index]);
                    },
                  ),

                  CommonText(
                    text: "Booking Preferences",
                    bottom: 16,
                    top: 16,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        /// Already Have Account
                        TextSpan(
                          text: "Customers can place orders at least ",
                          style: TextStyle(
                            color: Color(0xff777777),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        /// Sign In Button Here
                        TextSpan(
                          text: "12 Hours ",
                          recognizer:
                              TapGestureRecognizer()
                                ..onTapDown = (TapDownDetails details) {
                                  PopupController().showAdd(
                                    context,
                                    bottom: 100.h,
                                    right: 40.w,
                                    list: ["Hours", "Days"],
                                    selectItem: "Hours",
                                    onTap: (v) {},
                                  );
                                },
                          style: TextStyle(
                            color: Color(0xffFD713F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "in advance and a maximum of ",
                          style: TextStyle(
                            color: Color(0xff777777),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: "14 Days ",
                          recognizer:
                          TapGestureRecognizer()
                            ..onTapDown = (TapDownDetails details) {
                              PopupController().showAdd(
                                context,
                                bottom: 100.h,
                                right: 40.w,
                                list: ["Hours", "Days"],
                                selectItem: "Hours",
                                onTap: (v) {},
                              );
                            },
                          style: TextStyle(
                            color: Color(0xffFD713F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "in advance",
                          style: TextStyle(
                            color: Color(0xff777777),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
