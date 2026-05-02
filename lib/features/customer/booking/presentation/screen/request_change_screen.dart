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
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<BookingHistoryController>(
        builder: (historyCtrl) {
          // Show loader while fetching details
          if (historyCtrl.isDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffFD713F)),
            );
          }

          final order = historyCtrl.selectedOrderDetail;
          if (order == null) {
            return const Center(child: Text('Order not found'));
          }

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
                  builder: (cartCtrl) {
                    // This logic updates the text field whenever the controller state changes
                    if (cartCtrl.selectedTime.isNotEmpty) {
                      final date = cartCtrl.selectedDate;
                      final String formattedDate =
                          '${date.day}/${date.month}/${date.year}';
                      dateController.text =
                          '$formattedDate, ${cartCtrl.selectedTime}';
                    }

                    return CommonTextField(
                      controller: dateController,
                      keyboardType: TextInputType.none,
                      paddingVertical: 20,
                      borderRadius: 14,
                      hintText: 'Select Date & Time',
                      onTap:
                          () => bookingDateTimePopup(
                            id: historyCtrl.selectedOrderDetail!.chef.id,
                          ),
                      suffixIcon: InkWell(
                        onTap:
                            () => bookingDateTimePopup(
                              id: historyCtrl.selectedOrderDetail!.chef.id,
                            ),
                        child: const Icon(
                          CupertinoIcons.calendar,
                          color: Color(0xffFD713F),
                        ),
                      ),
                    );
                  },
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
                        constraints: BoxConstraints(minHeight: 60.h),
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 0.w,
                          top: 12.h,
                          bottom: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xfff2f2f2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child:
                                  cartCtrl.selectedAddress != null
                                      ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CommonText(
                                            text:
                                                cartCtrl
                                                        .selectedAddress!
                                                        .ownerName
                                                        .isNotEmpty
                                                    ? cartCtrl
                                                        .selectedAddress!
                                                        .ownerName
                                                    : cartCtrl
                                                        .selectedAddress!
                                                        .label,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff272727),
                                          ),
                                          CommonText(
                                            text:
                                                cartCtrl
                                                    .selectedAddress!
                                                    .detailsAddress,
                                            fontSize: 12,
                                            top: 2,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff777777),
                                          ),
                                        ],
                                      )
                                      : const CommonText(
                                        text: 'Select delivery address',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff777777),
                                        textAlign: TextAlign.left,
                                      ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, right: 12.w),
                              child: const CommonImage(
                                imageSrc: AppIcons.mapIcon,
                                imageColor: Color(0xffFD713F),
                                size: 24,
                              ),
                            ),
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
                    const CommonText(
                      text: AppString.orderDetails,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    CommonText(
                      text: '${order.staticItems.length} Items',
                      fontSize: 12,
                      color: const Color(0xff777777),
                    ),
                  ],
                ),
                20.height,
                InkWell(
                  onTap: () => historyCtrl.onChangeOrderDetailsPopup(),
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: order.chef.image,
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
                              text: order.chef.name,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            CommonText(
                              text: 'Booking ID: ${order.orderId}',
                              fontSize: 12,
                              color: const Color(0xff777777),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        historyCtrl.isOrderDetailsPopup
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                      ),
                    ],
                  ),
                ),

                if (historyCtrl.isOrderDetailsPopup) ...[
                  32.height,
                  // --- Dynamic Menu Items ---
                  ...order.staticItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: item.menuName,
                                fontWeight: FontWeight.w600,
                              ),
                              CommonText(
                                text: '${item.quantity} Items',
                                fontSize: 12,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                          /*CommonText(
                          text: '\$${item.totalPrice.toStringAsFixed(2)}',
                        ),*/
                        ],
                      ),
                    ),
                  ),
                ],

                28.height,
                const CommonText(
                  text: AppString.notesToPrivaeChef,
                  fontWeight: FontWeight.w600,
                  bottom: 8,
                ),
                CommonTextField(
                  controller: noteController,
                  hintText: 'Reason for change...',
                ),
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
            final cartController = Get.find<CartController>();
            final historyCtrl = Get.find<BookingHistoryController>();

            // Format the date to YYYY-MM-DD
            final String formattedDate =
                "${cartController.selectedDate.year}-${cartController.selectedDate.month.toString().padLeft(2, '0')}-${cartController.selectedDate.day.toString().padLeft(2, '0')}";

            historyCtrl.submitChangeRequest(
              orderId: orderId,
              date: formattedDate,
              time: cartController.selectedTime,
              // Takes "05:00 PM" from CartController
              addressId: cartController.selectedAddress?.id ?? '',
              note: noteController.text.trim(),
            );
          },
        ),
      ),
    );
  }
}
