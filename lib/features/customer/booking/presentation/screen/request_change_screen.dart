import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../../../address/data/address_model.dart';
import '../../../cart/presentation/controller/cart_controller.dart';
import '../../../cart/presentation/widgets/booking_date_time_pop_up.dart';
import '../controller/booking_history_controller.dart';

class RequestChangeScreen extends StatelessWidget {
  RequestChangeScreen({super.key});

  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String orderId = Get.arguments;
    final controller = Get.find<BookingHistoryController>();

    // FIX: Execute the fetch AFTER the build is done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetails(orderId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: AppString.requestChange,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<BookingHistoryController>(
        builder: (historyCtrl) {
          // Show loader while fetching details
          if (historyCtrl.isDetailLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffFD713F)));
          }

          final order = historyCtrl.selectedOrderDetail;
          if (order == null) return const Center(child: Text("Order not found"));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  text: AppString.reservationDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                  bottom: 8,
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return CommonTextField(
                      controller: dateController,
                      keyboardType: TextInputType.none,
                      borderRadius: 20,
                      hintText: "1 January 2026, 5:20PM",
                      onTap: () => bookingDateTimePopup(),
                      suffixIcon: InkWell(
                        onTap: () => bookingDateTimePopup(),
                        child: const Icon(
                          CupertinoIcons.calendar,
                          color: Color(0xffFD713F),
                        ),
                      ),
                    );
                  }
                ),
                20.height,

                // --- Address Selection (Uses CartController) ---
                GetBuilder<CartController>(
                  builder: (cartCtrl) {
                    return InkWell(
                      onTap: () async {
                        final result = await Get.toNamed(
                          AppRoutes.addressScreen,
                          arguments: {
                            'fromCheckout': true,
                            'selectedAddressId': cartCtrl.selectedAddress?.id,
                          },
                        );
                        if (result != null && result is AddressModel) {
                          cartCtrl.onAddressSelected(result);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xffF0F0F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            CommonImage(imageSrc: AppIcons.mapIcon, imageColor: const Color(0xffFD713F), size: 24),
                            8.width,
                            Expanded(
                              child: cartCtrl.selectedAddress != null
                                  ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(text: cartCtrl.selectedAddress!.label, fontSize: 12, fontWeight: FontWeight.w600),
                                  CommonText(text: cartCtrl.selectedAddress!.detailsAddress, fontSize: 12, color: const Color(0xff777777)),
                                ],
                              )
                                  : const CommonText(text: "Select delivery address", fontSize: 12, color: Color(0xff777777)),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                40.height,

                // --- Dynamic Order Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CommonText(text: AppString.orderDetails, fontSize: 16, fontWeight: FontWeight.w600),
                    CommonText(text: "${order.staticItems.length} Items", fontSize: 12, color: const Color(0xff777777)),
                  ],
                ),
                20.height,
                Row(
                  children: [
                    CommonImage(imageSrc: order.chef.image, size: 40, borderRadius: 50, fill: BoxFit.fill),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: order.chef.name, fontSize: 12, fontWeight: FontWeight.w600),
                          CommonText(text: "Booking ID: ${order.orderId}", fontSize: 12, color: const Color(0xff777777)),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),

                32.height,

                // --- Dynamic Menu Items ---
                ...order.staticItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: item.menuName, fontSize: 14, fontWeight: FontWeight.w600),
                          CommonText(text: "${item.quantity} Items", fontSize: 12, color: const Color(0xff777777)),
                        ],
                      ),
                      CommonText(text: "\$${item.totalPrice.toStringAsFixed(2)}", fontSize: 14),
                    ],
                  ),
                )).toList(),

                28.height,
                const CommonText(text: AppString.notesToPrivaeChef, fontSize: 14, fontWeight: FontWeight.w600, bottom: 8),
                CommonTextField(controller: noteController, hintText: "Reason for change..."),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomButton(orderId),
    );
  }

  Widget _buildBottomButton(String orderId) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 20),
      child: SafeArea(
        child: CommonButton(
          titleText: AppString.request,
          onTap: () {
            final cartCtrl = Get.find<CartController>();
            final historyCtrl = Get.find<BookingHistoryController>();

            // Format the date to YYYY-MM-DD
            String formattedDate = "${cartCtrl.selectedDate.year}-${cartCtrl.selectedDate.month.toString().padLeft(2, '0')}-${cartCtrl.selectedDate.day.toString().padLeft(2, '0')}";

            historyCtrl.submitChangeRequest(
              orderId: orderId,
              date: formattedDate,
              time: cartCtrl.selectedTime, // Takes "05:00 PM" from CartController
              addressId: cartCtrl.selectedAddress?.id ?? "",
              note: noteController.text.trim(),
            );
          },
        ),
      ),
    );
  }
}