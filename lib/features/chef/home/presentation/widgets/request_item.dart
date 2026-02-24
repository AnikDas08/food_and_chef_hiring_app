import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../customer/booking/presentation/widgets/details_popup.dart';
import '../../../chef_booking/presentation/widgets/decline_pop_up.dart';
import '../../../chef_booking/presentation/widgets/upcoming_pop_up.dart';
import '../Model/Request_0edBooking_Model.dart';
import '../controller/chef_home_controller.dart';

Widget requestItem(BuildContext context, RequestedBookingModel booking,
    {bool isRequested = false}) {
  return InkWell(
    onTap: () => bookingDetails(context),
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
                    ? Uri.parse(ApiEndPoint.imageUrl).resolve(booking.customerImage).toString()
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
                      text: booking.customerName.isNotEmpty ? booking.customerName : 'Unknown',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: booking.orderId,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
              ),

              // Upcoming badge only for Upcoming list
              if (!isRequested)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF5EDDD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CommonText(
                    text: "Upcoming",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffE39400),
                  ),
                ),

              if (!isRequested)
                PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  menuPadding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 1) upcomingPopUp();
                    else if (value == 2) {
                      final homeC = Get.find<ChefHomeController>();

                      declineBookingPopUp(
                        orderId: booking.id,
                        onSuccess: () {
                          homeC.requestedBookings.removeWhere((e) => e.id == booking.id);
                          homeC.fetchUpcomingBookings();
                          Get.snackbar("Success", "Booking declined");
                        },
                      );
                    }                  },
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.ingredients,
                      size: 16,
                      imageColor: Color(0xffF5865F),
                    ),
                    CommonText(
                      text: booking.itemSummary,
                      fontSize: 12,
                      left: 4,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff272727),
                    ),
                  ],
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.location,
                      size: 16,
                      imageColor: Color(0xffF5865F),
                    ),
                    CommonText(
                      text: booking.address.isNotEmpty
                          ? booking.address
                          : 'No address',
                      fontSize: 12,
                      left: 4,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff272727),
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

              if (isRequested) ...[
                InkWell(
                  onTap: () {
                    final homeC = Get.find<ChefHomeController>();

                    declineBookingPopUp(
                      orderId: booking.id,
                      onSuccess: () {
                        homeC.requestedBookings.removeWhere((e) => e.id == booking.id);

                        homeC.fetchUpcomingBookings();

                        Get.snackbar("Success", "Booking declined");
                      },
                    );
                  },                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.sp),
                      border: Border.all(color: Color(0xffFD713F)),
                    ),
                    child: CommonText(
                      text: "Decline",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFD713F),
                    ),
                  ),
                ),
                8.width,
                InkWell(
                  onTap: () async {
                    final c = Get.find<ChefHomeController>();

                    final res = await c.confirmBooking(booking.id);

                    if (res.statusCode == 200 && res.data?['success'] == true) {
                      c.requestedBookings.removeWhere((e) => e.id == booking.id);
                      c.fetchUpcomingBookings();

                      showSuccessDialog();
                    } else {
                      Get.snackbar(
                        "Message",
                        res.data?['message']?.toString() ?? "Something went wrong",
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Color(0xff272727),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: CommonText(
                      text: "Accept",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else
                InkWell(
                  onTap: upcomingPopUp,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
void showSuccessDialog() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Color(0xff1FAE4B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 14),
            const Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff111111),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "You’ve successfully confirmed the order.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.55),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  final c = Get.find<ChefHomeController>();
                  c.fetchRequestedBookings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff272727),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
