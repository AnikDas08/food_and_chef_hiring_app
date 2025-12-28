import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/cart_controller.dart';
import '../widgets/booking_date_time_pop_up.dart';
import '../widgets/confirm_checking_popup.dart';
import '../widgets/order_summary.dart';
import '../widgets/tax_popup.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: AppString.checkout,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: AppString.bookingDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                  bottom: 8,
                ),
                CommonTextField(
                  controller: dateController,
                  keyboardType: TextInputType.none,
                  borderRadius: 20,
                  hintText: "1 January 2026, 5:20PM",
                  onTap: () => bookingDateTimePopup(context),
                  suffixIcon: InkWell(
                    onTap: () => bookingDateTimePopup(context),
                    child: Icon(Icons.calendar_today, color: Color(0xffFD713F)),
                  ),
                ),

                20.height,
                Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Color(0xffF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: AppIcons.mapIcon,
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
                              text:
                                  "4140 Parker Rd. Allentown, New Mexico 31134",
                              fontSize: 12,
                              top: 2,
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
                            text: "2 Items",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: controller.onChangeExpanded,
                      child: Icon(
                        !controller.isExpanded
                            ? Icons.keyboard_arrow_down_outlined
                            : Icons.keyboard_arrow_up,
                        size: 24,
                        color: Color(0xff777777),
                      ),
                    ),
                  ],
                ),

                if (controller.isExpanded) ...[
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
                ],
                28.height,
                orderSummary(),
                42.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: "Add promo code",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff272727),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 16,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                24.height,
                InkWell(
                  onTap: taxPopup,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 15.sp,
                        width: 15.sp,
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonText(
                              text: "Request an invoice",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text: "Add tax details",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff818181),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 16,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                ),

                CommonText(
                  text: AppString.paymentMethod,
                  bottom: 8,
                  fontSize: 16,
                  top: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),

                Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Color(0xffF0F0F0),
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

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Terms: ",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff222222),
                      top: 36,
                    ),
                    CommonText(
                      text: "All prices excl. VAT. For your order the",
                      fontSize: 14,

                      fontWeight: FontWeight.w400,
                      color: Color(0xff636363),
                      top: 36,
                    ),
                  ],
                ),
                CommonText(
                  text: "Privae Chef Terms & Conditions apply",
                  fontSize: 14,
                  left: 2,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffFD713F),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: SafeArea(
          child: CommonButton(
            titleText: AppString.checkoutNow,
            onTap: confirmCheckingPopup,
          ),
        ),
      ),
    );
  }
}
