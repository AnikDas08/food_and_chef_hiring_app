import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../controller/chef_booking_controller.dart';
import 'confirmation_booking_pop_up.dart';
import 'decline_pop_up.dart';
import 'order_Summary_chef.dart';

void bookingDetailsPopup(
    BuildContext context, {
      required Map order,
      required String selectedTab,
    }) {

  String userName = order['user']?['name'] ?? "Unknown";
  String userImageRaw = order['user']?['image'] ?? "";
  String userImage = userImageRaw.startsWith('http')
      ? userImageRaw
      : "http://10.10.7.9:5014$userImageRaw";  String orderId = order['order_id'] ?? "";
  String address = order['formatted_address'] ?? "No address";
  String strTime = order['strTime'] ?? "";
  String formattedDate = _formatDatePopup(order['formatted_date']);
  double totalPrice = (order['user_paid'] ?? 0).toDouble();
  List staticItems = order['static_items'] ?? [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    enableDrag: true,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
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
                      imageSrc: userImage.isNotEmpty ? userImage : AppImages.img8,
                      size: 40,
                      borderRadius: 50,
                      fill: BoxFit.fill,
                    ),
                    12.width,
                    Expanded(
                      child: Column(
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
                    _statusBadgePopup(selectedTab),
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
                          text: userName,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                        CommonText(
                          text: address,
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
                          text: formattedDate,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                        CommonText(
                          text: "at $strTime",
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


              if (staticItems.isEmpty)
                CommonText(
                  text: "No items found",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                )
              else
                ...staticItems.map((item) {
                  String name = item['menu']?['name'] ?? "";
                  int qty = item['quantity'] ?? 1;
                  double price = (item['menu']?['price'] ?? 0).toDouble();
                  String note = item['note'] ?? "";
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: name,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff4E4E4E),
                            ),
                            CommonText(
                              text: "$qty item${qty > 1 ? 's' : ''}${note.isNotEmpty ? ' + $note' : ''}",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff777777),
                            ),
                          ],
                        ),
                        CommonText(
                          text: "\$${price.toStringAsFixed(2)}",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff272727),
                        ),
                      ],
                    ),
                  );
                }),

              16.height,
              orderSummarychef(order: order),
              Divider(),

              if (selectedTab == "Unconfirmed")
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        titleText: AppString.decline,
                        buttonColor: Color(0xffF2F2F2),
                        borderColor: Colors.transparent,
                        titleColor: Color(0xffFF3C3C),
                        buttonHeight: 48,
                        buttonRadius: 16,
                        onTap: () {
                          Get.back();
                          declineBookingPopUp(
                            orderId: order['_id'] ?? "",
                            onSuccess: () {
                              Get.find<ChefBookingController>().fetchOrders();
                            },
                          );
                        },
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: CommonButton(
                        titleText: AppString.accept,
                        buttonHeight: 48,
                        buttonRadius: 16,
                        onTap: () {
                          confirmBookingPopUp(orderMongoId: order['_id']?.toString() ?? "");                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          final userId = order['user']?['_id']?.toString() ?? "";
                          if (userId.isEmpty) return;

                          final response = await ApiService.post("chat/$userId", body: {});

                          if (response.statusCode == 200 || response.statusCode == 201) {
                            final chatData = response.data['data'];
                            final chatId = chatData['_id']?.toString() ?? "";

                            Get.back();

                            Get.toNamed(AppRoutes.message, parameters: {
                              'chatId': chatId,
                              'name': order['user']?['name'] ?? "User",
                              'image': order['user']?['image'] ?? "",
                            });

                          } else {
                            Get.snackbar("Error", "Failed to open chat");
                          }
                        } catch (e) {
                          Get.snackbar("Error", e.toString());
                        }
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        margin: EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CommonImage(imageSrc: AppIcons.chat).center,
                      ),
                    ),
                  ],
                ),
              if (selectedTab == "Upcoming")
                CommonButton(
                  titleText: AppString.chatWithCustomer,
                  buttonHeight: 48,
                  buttonRadius: 16,
                  onTap: () async {
                    try {
                      final userId = order['user']?['_id']?.toString() ?? "";
                      if (userId.isEmpty) return;

                      final response = await ApiService.post("chat/$userId", body: {});

                      if (response.statusCode == 200 || response.statusCode == 201) {
                        final chatData = response.data['data'];
                        final chatId = chatData['_id']?.toString() ?? "";

                        Get.back(); // popup বন্ধ
                        Get.toNamed(AppRoutes.message, parameters: {
                          'chatId': chatId,
                          'name': order['user']?['name'] ?? "User",
                          'image': order['user']?['image'] ?? "",
                        });
                      } else {
                        Get.snackbar("Error", "Failed to open chat");
                      }
                    } catch (e) {
                      Get.snackbar("Error", e.toString());
                    }
                  },
                ),
            ],
          ),
        ),
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}

Widget _statusBadgePopup(String selectedTab) {
  switch (selectedTab) {
    case "Unconfirmed":
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffE3ECFD),
          borderRadius: BorderRadius.circular(10),
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffDFF5E0),
          borderRadius: BorderRadius.circular(10),
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

String _formatDatePopup(String? isoDate) {
  if (isoDate == null) return "N/A";
  try {
    DateTime dt = DateTime.parse(isoDate);
    const months = [
      '', 'January', 'February', 'March', 'April', 'May',
      'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return "${dt.day} ${months[dt.month]}, ${dt.year}";
  } catch (_) {
    return isoDate;
  }
}