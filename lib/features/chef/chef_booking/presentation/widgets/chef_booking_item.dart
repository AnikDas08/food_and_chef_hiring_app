import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../home/presentation/widgets/request_item.dart';
import '../controller/chef_booking_controller.dart';
import 'booking_details_popup.dart';
import 'confirmation_booking_pop_up.dart';
import 'decline_pop_up.dart';
import 'upcoming_pop_up.dart';

Widget chefBookingItem({required Map order}) {


  final controller = Get.find<ChefBookingController>();

  String orderId = order['order_id'] ?? "";
  String userName = order['user']?['name'] ?? "";
  String userImageRaw = order['user']?['image'] ?? "";
  String userImage = userImageRaw.startsWith('http')
      ? userImageRaw
      : "http://10.10.7.9:5014$userImageRaw";  String status = order['status'] ?? "";
  String address = order['formatted_address'] ?? "";
  String strTime = order['strTime'] ?? "";
  double totalPrice = (order['user_paid'] ?? 0).toDouble();
  double rating = (order['rating'] ?? 0).toDouble();
  String review = order['review'] ?? "";
  String deadline = order['deadline'] ?? "";
  String cookingTime = order['duration'] ?? "";

  List staticItems = order['static_items'] ?? [];
  String itemsText = staticItems.map((item) {
    String name = item['menu']?['name'] ?? "";
    int qty = item['quantity'] ?? 1;
    return "$qty× $name";
  }).join(", ");
  String itemsLabel = "${staticItems.length} item${staticItems.length > 1 ? 's' : ''} ($itemsText)";

  String formattedDate = _formatDate(order['formatted_date']);
  String dateLabel = "$formattedDate at $strTime";
  String timeLeft = _timeLeft(deadline);

  return InkWell(
    onTap: () {
      bookingDetailsPopup(
        Get.context!,
        order: order,
        selectedTab: controller.selectedBookingHistory,
      );
    },
    child: Container(
      padding: EdgeInsets.all(12.sp).copyWith(right: 0),
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
                imageSrc: userImage.isNotEmpty ? userImage : AppImages.image3,
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
                      text: userName,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                    ),
                    CommonText(
                      text: orderId,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
              ),
              _statusBadge(controller.selectedBookingHistory),


              PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                color: Colors.white,
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) async {
                  if (value == 1) {
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      final c = Get.find<ChefBookingController>();
                      final orderData = await c.fetchSingleOrder(order['_id'] ?? "");

                      Get.back();

                      if (orderData != null) {
                        upcomingPopUp(orderData: orderData);
                      } else {
                        Get.snackbar("Error", "Could not load order details");
                      }
                    } catch (e) {
                      Get.back();
                      Get.snackbar("Error", "Something went wrong");
                    }
                  }

                  if (value == 2) {
                    cancelBookingPopUp(
                      orderId: order['_id']?.toString() ?? "",
                      onSuccess: () {
                        controller.fetchOrders();
                        Get.snackbar("Success", "Booking cancelled");
                      },
                    );
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

          24.height,

          Row(
            children: [
              CommonImage(
                imageSrc: AppIcons.date,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              Expanded(
                child: CommonText(
                  text: dateLabel,
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          15.height,

          Row(
            children: [
              CommonImage(
                imageSrc: AppIcons.ingredients,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              Expanded(
                child: CommonText(
                  text: itemsLabel,
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                  textAlign: TextAlign.start, // ✅ add
                ),
              ),
            ],
          ),
          8.height,


          Row(
            children: [
              CommonImage(
                imageSrc: AppIcons.location,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              Expanded(
                child: CommonText(
                  text: address,
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                  textAlign: TextAlign.start, // ✅ add
                ),
              ),
            ],
          ),
          8.height,

          if (cookingTime.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.time,
                    size: 16,
                    color: Color(0xff777777),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: CommonText(
                      text: "Estimated cooking time: $cookingTime",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff272727),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          8.height,

          if (controller.selectedBookingHistory != "Completed")
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  Icon(CupertinoIcons.info, color: Color(0xffFD713F), size: 16),
                  CommonText(
                    text: timeLeft.isNotEmpty
                        ? "You have $timeLeft left to confirm the order"
                        : "Deadline passed",
                    fontSize: 12,
                    left: 4,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFD713F),
                  ),
                ],
              ),
            ),

          if (controller.selectedBookingHistory == "Completed" && review.isNotEmpty)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Review",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonText(
                    text: review,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff272727),
                    maxLines: 3,
                    textAlign: TextAlign.start,
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
                    text: "Hourly rate",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: "\$${totalPrice.toStringAsFixed(2)}",
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 2,
                  ),
                ],
              ),
              Spacer(),

              // ✅ Unconfirmed: Decline + Accept
              if (controller.selectedBookingHistory == "Unconfirmed") ...[
                InkWell(
                  onTap: () {
                    declineBookingPopUp(
                      orderId: order['_id'] ?? "",
                      onSuccess: () {
                        controller.fetchOrders();
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: CommonText(
                      text: AppString.decline,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFF3C3C),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    confirmBookingPopUp(orderMongoId: order['_id']?.toString() ?? "");                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    margin: EdgeInsets.only(left: 8.sp),
                    decoration: BoxDecoration(
                      color: Color(0xff272727),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: CommonText(
                      text: AppString.accept,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                12.width,
              ],

              // ✅ Upcoming: Chat button
              if (controller.selectedBookingHistory == "Upcoming") ...[
                Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: AppIcons.chat,
                        size: 16,
                        imageColor: Color(0xff272727),
                      ),
                      CommonText(
                        text: AppString.chatWithCustomer,
                        fontSize: 12,
                        left: 6,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                    ],
                  ),
                ),
              ],

              // ✅ Completed: Rating
              if (controller.selectedBookingHistory == "Completed") ...[
                Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Row(
                    children: [
                      CommonText(
                        text: "${AppString.rating} ${rating > 0 ? rating.toStringAsFixed(1) : 'N/A'}",
                        fontSize: 12,
                        right: 6,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      if (rating > 0)
                        Icon(
                          Icons.star_rate_rounded,
                          size: 12,
                          color: Color(0xffFD713F),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _statusBadge(String selectedTab) {
  switch (selectedTab) {
    case "Unconfirmed":
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: Color(0xffF5EDDD),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CommonText(
          text: "Requested",
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xffE39400),
        ),
      );
    case "Upcoming":
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: Color(0xffE3ECFD),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: CommonText(
          text: "Upcoming",
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xff4285F4),
        ),
      );
    default:
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: Color(0xffDFF5E0),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: CommonText(
          text: "Completed",
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xff2F8328),
        ),
      );
  }
}

String _formatDate(String? isoDate) {
  if (isoDate == null) return "";
  try {
    DateTime dt = DateTime.parse(isoDate);
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return "${dt.day} ${months[dt.month]}, ${dt.year}";
  } catch (_) {
    return isoDate;
  }
}

String _timeLeft(String? deadlineIso) {
  if (deadlineIso == null || deadlineIso.isEmpty) return "";
  try {
    DateTime deadline = DateTime.parse(deadlineIso);
    Duration diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return "";
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    if (hours > 0) return "${hours}h${minutes}m";
    return "${minutes}m";
  } catch (_) {
    return "";
  }
}