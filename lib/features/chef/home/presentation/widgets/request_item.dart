import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../utils/constants/app_icons.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../customer/booking/presentation/widgets/details_popup.dart';
import '../../../chef_booking/presentation/widgets/decline_pop_up.dart';
import '../../../chef_booking/presentation/widgets/upcoming_pop_up.dart';
import '../Model/Request_0edBooking_Model.dart';

Widget requestItem(BuildContext context, RequestedBookingModel booking) {
  return InkWell(
    onTap: () {
      bookingDetails(context);
    },
    child: Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonImage(
                imageSrc: booking.customerImage.isNotEmpty
                    ? '${ApiEndPoint.baseUrl}${booking.customerImage}'
                    : AppImages.img8,
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
                      text: booking.customerName.isNotEmpty
                          ? booking.customerName
                          : 'Unknown',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: '#${booking.id.length > 7 ? booking.id.substring(booking.id.length - 7) : booking.id}',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  color: Color(0xffF5EDDD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CommonText(
                  text: booking.status,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xffE39400),
                ),
              ),

              PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                color: Colors.white,
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    upcomingPopUp();
                  } else if (value == 2) {
                    declineBookingPopUp();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 20, color: Colors.black),
                        SizedBox(width: 10),
                        CommonText(text: "Request a Change", fontSize: 14),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(Icons.close, size: 20, color: Colors.red),
                        SizedBox(width: 10),
                        CommonText(
                          text: "Cancel Booking",
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          16.height,
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              border: Border.all(color: Color(0xffF1F1F1)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.date,
                      size: 16,
                      imageColor: Color(0xffF5865F),
                    ),
                    CommonText(
                      text: booking.scheduledAt,
                      fontSize: 12,
                      left: 4,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.ingredients,
                      size: 16,
                      imageColor: Color(0xffF5865F),
                    ),
                    CommonText(
                      text: '${booking.totalItems} item${booking.totalItems > 1 ? 's' : ''}',
                      fontSize: 12,
                      left: 4,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff272727),
                    ),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.location,
                      size: 16,
                      imageColor: Color(0xffF5865F),
                    ),
                    Expanded(
                      child: CommonText(
                        text: booking.address.isNotEmpty
                            ? booking.address
                            : 'No address',
                        fontSize: 12,
                        left: 4,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff272727),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          20.height,

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.total,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: '\$${booking.total.toStringAsFixed(2)}',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 2,
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: upcomingPopUp,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.sp),
                    border: Border.all(color: Color(0xffF1F1F1)),
                  ),
                  child: CommonText(
                    text: "Request Change",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    right: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}