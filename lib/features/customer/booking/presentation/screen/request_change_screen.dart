import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';

class RequestChangeScreen extends StatelessWidget {
  RequestChangeScreen({super.key});

  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: AppString.requestChange,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: AppString.reservationDetails,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
              bottom: 8,
            ),
            CommonTextField(
              controller: dateController,
              keyboardType: TextInputType.none,
              hintText: "1 January 2026, 5:20PM",
              onTap: () => OtherHelper.openDatePickerDialog(dateController),
              suffixIcon: InkWell(
                onTap: () => OtherHelper.openDatePickerDialog(dateController),
                child: Icon(Icons.calendar_today, color: Color(0xffFD713F)),
              ),
            ),

            20.height,
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CommonImage(
                    imageSrc: AppIcons.location,
                    imageColor: Color(0xffFD713F),
                    size: 24,
                  ),
                  8.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(
                          text: "Darren Monarch",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                        CommonText(
                          text: "4140 Parker Rd. Allentown, New Mexico 31134",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff777777),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xff777777),
                  ),
                ],
              ),
            ),

            40.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: AppString.orderDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                  bottom: 28,
                ),
                CommonText(
                  text: "2 Items",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                  bottom: 28,
                ),
              ],
            ),
            Row(
              children: [
                CommonImage(
                  imageSrc: AppImages.image3,
                  size: 40,
                  borderRadius: 50,
                  fill: BoxFit.fill,
                ),

                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                        text: "Javier A.",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: " \$40 per hour",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),

            32.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Chopped Burrito",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: "2 Items + Without Onions",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                CommonText(
                  text: "\$20.00",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Chopped Burrito",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: "2 Items + Without Onions",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                CommonText(
                  text: "\$20.00",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
            28.height,
            CommonText(
              text: AppString.notesToPrivaeChef,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
              bottom: 8,
            ),
            CommonTextField(hintText: "Enter here"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: SafeArea(
          child: CommonButton(
            titleText: AppString.request,
            onTap: () {
              Get.toNamed(AppRoutes.chefHomeScreen, arguments: 1);
            },
          ),
        ),
      ),
    );
  }
}
