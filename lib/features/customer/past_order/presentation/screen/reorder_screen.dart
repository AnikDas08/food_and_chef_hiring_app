import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/features/customer/past_order/presentation/widgets/terms.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:new_untitled/utils/helpers/other_helper.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../cart/presentation/widgets/order_summary.dart';

class ReorderScreen extends StatelessWidget {
  ReorderScreen({super.key});

  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: "Book Chef Again",
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

            12.height,
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(8),
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
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),

            24.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: AppString.orderDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                CommonText(
                  text: "2 items",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                ),
              ],
            ),
            16.height,
            Container(
              height: 64.h,
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Row(
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
                          bottom: 2,
                          left: 3,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xffFD713F),
                            ),
                            CommonText(
                              text: "4.5  (482 Reviews)",
                              fontSize: 12,
                              left: 2,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                      color: Color(0xff4E4E4E),
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
                  text: "\$45.00",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
            12.height,
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
                      color: Color(0xff4E4E4E),
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
                  text: "\$45.00",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
            32.height,
            orderSummary(),
            28.height,

            CommonText(
              text: AppString.paymentMethod,
              bottom: 8,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),

            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CommonImage(imageSrc: AppIcons.master, size: 24),
                  8.width,
                  CommonText(
                    text: "Mastercard",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff272727),
                  ),
                  CommonText(
                    text: "**** 4356",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    left: 8,
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Color(0xff777777),
                  ),
                ],
              ),
            ),

            32.height,
            Terms(),
          ],
        ),
      ),
      persistentFooterButtons: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: CommonButton(
              titleText: AppString.checkoutNow,
              onTap: Get.back,
            ),
          ),
        ),
      ],
    );
  }
}
