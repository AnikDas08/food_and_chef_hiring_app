// lib/features/orders/widgets/past_item_details_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../cart/presentation/widgets/order_summary.dart';
import '../controller/past_order_controller.dart';
import '../data/past_order_model.dart';

void bookingDetailsShow(BuildContext context) {
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

          // ── Loading State ────────────────────────────────
          if (controller.isLoadingDetail || controller.selectedOrder == null) {
            return SizedBox(
              height: 300,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final order = controller.selectedOrder!;

          // ── Status colors ────────────────────────────────
          Color statusBg;
          Color statusColor;
          switch (order.status.toLowerCase()) {
            case 'completed':
              statusBg = const Color(0xffDBEBD9);
              statusColor = const Color(0xff2F8328);
              break;
            case 'cancelled':
              statusBg = const Color(0xffFFE5E5);
              statusColor = const Color(0xffFF3C3C);
              break;
            default:
              statusBg = const Color(0xffFFF3E0);
              statusColor = const Color(0xffF57C00);
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Chef + Order ID + Status ─────────────
                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Row(
                      children: [
                        CommonImage(
                          imageSrc:
                          "${ApiEndPoint.imageUrl}${order.chef.image}",
                          size: 40,
                          borderRadius: 50,
                          fill: BoxFit.cover,
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
                                color: const Color(0xff272727),
                              ),
                              CommonText(
                                text: order.orderId,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.sp, vertical: 5.sp),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CommonText(
                            text: order.status,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  34.height,

                  // ── Address ──────────────────────────────
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
                              text: order.formattedAddress,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            /*CommonText(
                              text:
                              "Lat: ${order.formattedAddressCoordinates['lat']}, "
                                  "Lng: ${order.formattedAddressCoordinates['lng']}",
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),

                  16.height,

                  // ── Date & Time ──────────────────────────
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
                              text: _formatDateOnly(order.formattedDate),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            CommonText(
                              text: order.strTime,
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

                  /*// ── Order History Timeline ───────────────
                  if (order.history.isNotEmpty) ...[
                    CommonText(
                      text: "Order Timeline",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                      bottom: 8,
                    ),
                    ...order.history.map((h) => _HistoryItem(history: h)),
                    16.height,
                  ],*/

                  // ── Order Details ────────────────────────
                  CommonText(
                    text: AppString.orderDetails,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                    top: 4,
                    bottom: 16,
                  ),

                  // ── Static Items ─────────────────────────
                  ...order.staticItems.map((item) => _OrderItemRow(item: item)),

                  16.height,

                  // ── Price Breakdown ──────────────────────
                  _PriceBreakdownWidget(order: order),

                  const Divider(),
                  12.height,

                  // ── Rating (if rated) ────────────────────
                  if (order.rating > 0) ...[
                    Row(
                      children: [
                        CommonText(
                          text: "Your Rating: ",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff272727),
                        ),
                        ...List.generate(5, (i) {
                          return Icon(
                            i < order.rating.floor()
                                ? Icons.star
                                : (i < order.rating
                                ? Icons.star_half
                                : Icons.star_border),
                            color: const Color(0xffFD713F),
                            size: 18,
                          );
                        }),
                        CommonText(
                          text: " ${order.rating}",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffFD713F),
                          left: 4,
                        ),
                      ],
                    ),
                    if (order.rating != null && order.rating!="")
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffF9F9F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xffF1F1F1)),
                        ),
                        child: CommonText(
                          text: '"${order.rating}"',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff777777),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    12.height,
                  ],

                  // ── Action Buttons ───────────────────────
                  CommonButton(
                    titleText: AppString.reorder,
                    onTap: () => Get.toNamed(AppRoutes.reorder, arguments: order),
                  ),
                  12.height,
                  CommonButton(
                    /*titleText: order.rating > 0
                        ? "Edit Rating"
                        : "Leave a Rating",*/
                    titleText: "Leave a Rating",
                    buttonColor: const Color(0xffF2F2F2),
                    borderColor: Colors.transparent,
                    titleColor: const Color(0xff272727),
                    onTap: () => Get.toNamed(AppRoutes.review, arguments: order),
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

// ── History Timeline Item ───────────────────────────────────────────────────
class _HistoryItem extends StatelessWidget {
  final OrderHistory history;
  const _HistoryItem({required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xffFD713F),
              shape: BoxShape.circle,
            ),
          ),
          8.width,
          Expanded(
            child: CommonText(
              text: history.type,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xff272727),
            ),
          ),
          CommonText(
            text: _formatDateOnly(history.date),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: const Color(0xff777777),
          ),
        ],
      ),
    );
  }
}

// ── Order Item Row ──────────────────────────────────────────────────────────
class _OrderItemRow extends StatelessWidget {
  final StaticItem item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: item.menuName,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff4E4E4E),
                ),
                CommonText(
                  text:
                  "${item.quantity} Item${item.quantity > 1 ? 's' : ''}"
                      "${item.customizations.isNotEmpty ? ' + ${item.customizations.map((c) => c.replaceAll('_', ' ')).join(', ')}' : ''}",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff777777),
                ),
              ],
            ),
          ),
          CommonText(
            text: "\$${item.totalPrice.toStringAsFixed(2)}",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff272727),
          ),
        ],
      ),
    );
  }
}

// ── Price Breakdown ─────────────────────────────────────────────────────────
class _PriceBreakdownWidget extends StatelessWidget {
  final PastOrderModel order;
  const _PriceBreakdownWidget({required this.order});

  @override
  Widget build(BuildContext context) {
    final pb = order.priceBreakdown;
    return Column(
      children: [
        _PriceRow(label: "Subtotal", value: pb.subtotal),
        _PriceRow(label: "Tax", value: pb.taxs),
        _PriceRow(label: "Service Fee", value: pb.serviceFee),
        if (order.hasDiscount)
          _PriceRow(
            label: "Discount",
            value: -order.discountAmount,
            valueColor: const Color(0xff2F8328),
          ),
        const Divider(),
        _PriceRow(
          label: "Total",
          value: pb.total,
          isBold: true,
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: label,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isBold
                ? const Color(0xff272727)
                : const Color(0xff777777),
          ),
          CommonText(
            text: "${value < 0 ? '-' : ''}\$${value.abs().toStringAsFixed(2)}",
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: valueColor ??
                (isBold
                    ? const Color(0xff272727)
                    : const Color(0xff4E4E4E)),
          ),
        ],
      ),
    );
  }
}

// ── Date Helpers ────────────────────────────────────────────────────────────
String _formatDateOnly(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate).toLocal();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${dt.day} ${months[dt.month - 1]}, ${dt.year}";
  } catch (_) {
    return isoDate;
  }
}