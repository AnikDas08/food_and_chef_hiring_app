import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Payment",
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              CommonText(
                text: "DEFAULT PAYMENT",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff777777),
                top: 28,
                bottom: 16,
              ),
              Row(
                children: [
                  Container(
                    height: 48.sp,
                    width: 48.sp,
                    decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child:
                        CommonImage(imageSrc: AppIcons.master, size: 24).center,
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: "Mastercard",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: "**** **** ****  4356",
                        fontSize: 12,
                        top: 4,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.editCard);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0xffF1F1F1)),
                      ),
                      child: CommonText(
                        text: "Edit",
                        color: Color(0xff272727),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              CommonText(
                text: "OTHER PAYMENT METHOD",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff777777),
                top: 28,
                bottom: 16,
              ),
              Row(
                children: [
                  Container(
                    height: 48.sp,
                    width: 48.sp,
                    decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child:
                        CommonImage(imageSrc: AppIcons.master, size: 24).center,
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: "Paypall",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: "Not connected",
                        fontSize: 12,
                        top: 4,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffF1F1F1)),
                    ),
                    child: CommonText(
                      text: "Add",
                      color: Color(0xff272727),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(height: 30, color: Color(0xffF1F1F1)),
              Row(
                children: [
                  Container(
                    height: 48.sp,
                    width: 48.sp,
                    decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child:
                        CommonImage(
                          imageSrc: AppIcons.shopPay,
                          size: 24,
                        ).center,
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: "Shop Pay",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: "Not connected",
                        fontSize: 12,
                        top: 4,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffF1F1F1)),
                    ),
                    child: CommonText(
                      text: "Add",
                      color: Color(0xff272727),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(height: 30, color: Color(0xffF1F1F1)),
              Row(
                children: [
                  Container(
                    height: 48.sp,
                    width: 48.sp,
                    decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child:
                        CommonImage(imageSrc: AppIcons.gpay, size: 24).center,
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: "Google Pay",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: "Not connected",
                        fontSize: 12,
                        top: 4,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xffF1F1F1)),
                    ),
                    child: CommonText(
                      text: "Add",
                      color: Color(0xff272727),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(height: 30, color: Color(0xffF1F1F1)),

              Row(
                children: [
                  Container(
                    height: 48.sp,
                    width: 48.sp,
                    decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child:
                        CommonImage(
                          imageSrc: AppIcons.creditCard,
                          size: 24,
                        ).center,
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: "Add Credit or Debit Card",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff272727),
                      ),
                      CommonText(
                        text: "Not connected",
                        fontSize: 12,
                        top: 4,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.addCard);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0xffF1F1F1)),
                      ),
                      child: CommonText(
                        text: "Add",
                        color: Color(0xff272727),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
