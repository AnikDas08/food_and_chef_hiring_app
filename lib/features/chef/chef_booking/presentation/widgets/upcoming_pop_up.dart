import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/chef/chef_booking/presentation/widgets/request_change_pop_up.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../customer/cart/presentation/widgets/order_summary.dart';
import '../controller/chef_booking_controller.dart';
import 'confirmation_booking_pop_up.dart';

upcomingPopUp() {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.white,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<ChefBookingController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Row(
                      children: [
                        CommonImage(
                          imageSrc: AppImages.img8,
                          size: 40,
                          borderRadius: 50,
                          fill: BoxFit.fill,
                        ),

                        12.width,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: "Tony Ferguson",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                              CommonText(
                                text: "#HC-59375959",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff777777),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                            vertical: 5.sp,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffF5EDDD),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: CommonText(
                            text: "Requested",
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffE39400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  34.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: CommonImage(
                          imageSrc: AppIcons.location,
                          imageColor: Color(0xffFD713F),
                          size: 20,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: CommonImage(
                          imageSrc: AppIcons.date,
                          imageColor: Color(0xffFD713F),
                          size: 20,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "August 30, 2024 ",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            CommonText(
                              text: "at 01:00 PM - 03:40 PM",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CommonText(
                    text: AppString.orderDetails,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 16,
                    bottom: 20,
                  ),

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
                  16.height,
                  orderSummary(),

                  Divider(),

                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          titleText: AppString.requestChange,
                          buttonColor: Color(0xffF2F2F2),
                          borderColor: Colors.transparent,
                          titleColor: Color(0xff272727),
                          titleSize: 14,
                          titleWeight: FontWeight.w600,
                          buttonHeight: 48,
                          buttonRadius: 16,
                          onTap: () {
                            requestChangePopUp(context);
                          },
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: CommonButton(
                          titleText: AppString.chatWithCustomers,
                          buttonHeight: 48,
                          buttonRadius: 16,
                          titleSize: 14,
                          titleWeight: FontWeight.w600,
                          onTap: () {
                            Get.toNamed(AppRoutes.message);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}
