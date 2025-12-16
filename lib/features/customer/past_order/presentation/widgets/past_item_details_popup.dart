import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../cart/presentation/widgets/order_summary.dart';
import '../controller/past_order_controller.dart';

void pastItemDetailsPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<PastOrderController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.sp),
                    border: Border.all(color: Color(0xffE5E5E5)),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Javier A.",
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
                          color: Color(0xffDBEBD9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0xffC2E2BE),
                            width: 1,
                          ),
                        ),
                        child: CommonText(
                          text: "Completed",
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2F8328),
                        ),
                      ),
                    ],
                  ),
                ),
                34.height,
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.sp),
                    border: Border.all(color: Color(0xffF1F1F1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                              color: Color(0xffF8F4F1),
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

                      Divider(height: 30, color: Color(0xffF1F1F1)),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                              color: Color(0xffF8F4F1),
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
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 32.h, bottom: 32.h),
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xffF8F4F1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: AppString.orderDetails,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      Divider(
                        color: Color(0xffF8F4F1),
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
                      16.height,
                      orderSummary(),
                    ],
                  ),
                ),
                Divider(),

                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        titleText: AppString.orderGroceries,
                        buttonHeight: 48,
                        buttonRadius: 16,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8.sp),
                      padding: EdgeInsets.all(14.sp),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CommonImage(imageSrc: AppIcons.chats, size: 20),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: EdgeInsets.all(14.sp),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CommonImage(imageSrc: AppIcons.edit, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}
