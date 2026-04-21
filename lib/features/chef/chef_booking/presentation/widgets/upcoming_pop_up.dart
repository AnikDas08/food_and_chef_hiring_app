import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/chef/chef_booking/presentation/widgets/request_change_pop_up.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/chef_booking_controller.dart';

upcomingPopUp({Map<String, dynamic>? orderData}) {
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

          final userData     = orderData?['user']  as Map<String, dynamic>?;
          final customerName = userData?['name']   ?? 'Unknown';
          final customerImg  = userData?['image']  ?? '';
          final orderId      = orderData?['order_id']          ?? '';
          final address      = orderData?['formatted_address'] ?? 'No address';
          final strTime      = orderData?['strTime']           ?? '';
          final items        = (orderData?['static_items'] as List?) ?? [];
          final breakdown    = orderData?['price_breakdown'] as Map<String, dynamic>?;
          final duration     = orderData?['duration'] ?? '';


          final String imageUrl = customerImg.isNotEmpty
              ? '${ApiEndPoint.imageUrl}$customerImg'
              : '';

          final scheduledDate = _formatDate(orderData?['formatted_date']);

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Row(
                      children: [
                        CommonImage(
                          imageSrc: imageUrl.isNotEmpty ? imageUrl : AppImages.img8,
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
                                text: customerName,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff272727),
                              ),
                              CommonText(
                                text: orderId,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5EDDD),
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                          child: CommonText(
                            text: "Upcoming",                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffE39400),
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
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: CommonImage(
                          imageSrc: AppIcons.location,
                          imageColor: const Color(0xffFD713F),
                          size: 20,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: customerName,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            CommonText(
                              text: address,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
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
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                        child: CommonImage(
                          imageSrc: AppIcons.date,
                          imageColor: const Color(0xffFD713F),
                          size: 20,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: scheduledDate,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            CommonText(
                              text: strTime,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
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
                    color: const Color(0xff272727),
                    top: 20,
                    bottom: 16,
                  ),


                  if (items.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        "No items found",
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    )
                  else
                    ...items.map((item) {
                      final menu        = item['menu'] as Map<String, dynamic>?;
                      final menuName    = menu?['name'] ?? 'Item';
                      final qty         = item['quantity'] ?? 1;
                      final customs     = (item['customizations'] as List?)
                          ?.map((e) => e.toString())
                          .join(', ') ?? '';
                      final price       = (item['total_price'] ?? 0).toDouble();

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: menuName,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff4E4E4E),
                                  ),
                                  CommonText(
                                    text: customs.isNotEmpty
                                        ? '$qty item(s) · $customs'
                                        : '$qty item(s)',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                            CommonText(
                              text: '\$${price.toStringAsFixed(2)}',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff272727),
                            ),
                          ],
                        ),
                      );
                    }),

                  const Divider(height: 24),


                  CommonText(
                    text: "Order Summary",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                    bottom: 12,
                  ),

                  // Cooking duration
                  if (duration.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Estimated cooking time:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                        ),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
                      child: const Text(
                        "For scheduling only: Billing reflects time worked.",
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff777777),
                        ),
                      ),
                    ),
                  ],

                  // Price rows from breakdown
                  if (breakdown != null) ...[
                    _summaryRow(
                      "Subtotal",
                      (breakdown['subtotal'] ?? 0).toDouble(),
                    ),
                    _summaryRow(
                      "Estimated taxes",
                      (breakdown['taxs'] ?? 0).toDouble(),
                    ),
                    _summaryRow(
                      "Service fee",
                      (breakdown['service_fee'] ?? 0).toDouble(),
                    ),
                    const Divider(height: 20),
                    _summaryRow(
                      "Total",
                      (breakdown['total'] ?? 0).toDouble(),
                      isBold: true,
                      fontSize: 15,
                    ),
                  ],

                  const Divider(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          titleText: AppString.requestChange,
                          buttonColor: const Color(0xffF2F2F2),
                          borderColor: Colors.transparent,
                          titleColor: const Color(0xff272727),
                          titleSize: 14,
                          buttonHeight: 48,
                          buttonRadius: 16,
                          onTap: () async {
                            Navigator.pop(Get.context!);
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            requestChangePopUp(orderId: orderData?['_id']?.toString());
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
                          onTap: () async {
                            try {

                              final userId = orderData?['user']?['_id']?.toString() ?? "";
                              if (userId.isEmpty) return;

                              final response = await ApiService.post("chat/$userId", body: {});

                              if (response.statusCode == 200 || response.statusCode == 201) {
                                final chatData = response.data['data'];
                                final chatId = chatData['_id']?.toString() ?? "";

                                Navigator.pop(Get.context!);Get.toNamed(AppRoutes.message, parameters: {
                                  'chatId': chatId,
                                  'name': orderData?['user']?['name'] ?? "User",
                                  'image': orderData?['user']?['image'] ?? "",
                                });
                              } else {
                                Utils.errorSnackBar("Error", "Failed to open chat");
                              }
                            } catch (e) {
                              Utils.errorSnackBar("Error", e.toString());
                            }
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



String _formatDate(dynamic rawDate) {
  if (rawDate == null) return 'N/A';
  try {
    final dt = DateTime.parse(rawDate.toString()).toLocal();
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  } catch (_) {
    return rawDate.toString();
  }
}

Widget _summaryRow(String label, double amount,
    {bool isBold = false, double fontSize = 13}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold ? const Color(0xff272727) : const Color(0xff777777),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xff272727),
          ),
        ),
      ],
    ),
  );
}