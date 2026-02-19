// lib/features/orders/view/review_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/review_controller_here.dart';
import '../widgets/review_success_pop_up.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      init: ReviewController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: CommonText(
              text: controller.order.rating > 0
                  ? "Edit Rating"
                  : "Leave Chef Rating",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
          ),

          body: controller.isLoading
          // ── Loading existing review ──────────────────
              ? const Center(child: CircularProgressIndicator())

          // ── Form ─────────────────────────────────────
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Chef Info Row ──────────────────────
                Row(
                  children: [
                    12.width,
                    CommonImage(
                      imageSrc:
                      "${ApiEndPoint.imageUrl}${controller.order.chef.image}",
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
                            text: controller.order.chef.name,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff272727),
                            bottom: 2,
                            left: 3,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16,
                                  color: Color(0xffFD713F)),
                              CommonText(
                                text: controller.order.rating > 0
                                    ? "${controller.order.rating}"
                                    : "No rating yet",
                                fontSize: 12,
                                left: 2,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.sp, vertical: 5.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xffDBEBD9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CommonText(
                        text: controller.order.status,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff2F8328),
                      ),
                    ),
                  ],
                ),

                24.height,

                // ── Order Details (expandable) ─────────
                InkWell(
                  onTap: controller.toggleExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: AppString.orderDetails,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff272727),
                      ),
                      Icon(
                        controller.isExpanded
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down_outlined,
                        color: const Color(0xff777777),
                      ),
                    ],
                  ),
                ),

                if (controller.isExpanded) ...[
                  16.height,
                  // Static items list
                  ...controller.order.staticItems.map(
                        (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                            text:
                            "\$${item.totalPrice.toStringAsFixed(2)}",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff272727),
                          ),
                        ],
                      ),
                    ),
                  ),

                  16.height,

                  // Price summary
                  _PriceRow(
                      label: "Subtotal",
                      value: controller.order.priceBreakdown.subtotal),
                  _PriceRow(
                      label: "Tax",
                      value: controller.order.priceBreakdown.taxs),
                  _PriceRow(
                      label: "Service Fee",
                      value:
                      controller.order.priceBreakdown.serviceFee),
                  const Divider(),
                  _PriceRow(
                    label: "Total",
                    value: controller.order.priceBreakdown.total,
                    isBold: true,
                  ),
                ],

                28.height,

                // ── Review Text ────────────────────────
                CommonText(
                  text: "Reviews",
                  bottom: 16,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),
                CommonTextField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  hintText: "Write your review here...",
                  controller: TextEditingController(
                      text: controller.reviewText),
                  onChanged: controller.onReviewChanged,
                ),

                // ── Ratings ────────────────────────────
                CommonText(
                  text: "Ratings",
                  bottom: 16,
                  top: 24,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),

                _RatingItem(
                  title: "Quality and Taste",
                  initialRating: controller.qualityAndTaste,
                  onRatingUpdate: controller.onQualityChanged,
                ),
                _RatingItem(
                  title: "Cleanliness",
                  initialRating: controller.cleanliness,
                  onRatingUpdate: controller.onCleanlinessChanged,
                ),
                _RatingItem(
                  title: "Timeliness",
                  initialRating: controller.timeliness,
                  onRatingUpdate: controller.onTimelinessChanged,
                ),
                _RatingItem(
                  title: "Friendliness",
                  initialRating: controller.friendliness,
                  onRatingUpdate: controller.onFriendlinessChanged,
                ),
                _RatingItem(
                  title: "Communication",
                  initialRating: controller.communication,
                  onRatingUpdate: controller.onCommunicationChanged,
                ),

                8.height,

                // ── Average Rating ─────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  width: Get.width,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: "Average Rating",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff272727),
                      ),
                      const Spacer(),
                      RatingBar.builder(
                        initialRating: controller.averageRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        ignoreGestures: true, // read-only computed avg
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Color(0xffFD713F),
                        ),
                        onRatingUpdate: (_) {},
                      ),
                      8.width,
                      CommonText(
                        text: "${controller.averageRating}",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff272727),
                      ),
                    ],
                  ),
                ),

                20.height,
              ],
            ),
          ),

          // ── Submit Button ───────────────────────────────────
          persistentFooterButtons: [
            SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: controller.isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : CommonButton(
                  titleText: AppString.submit,
                  onTap: controller.submitReview,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Rating Item Widget ──────────────────────────────────────────────────────
class _RatingItem extends StatelessWidget {
  final String title;
  final double initialRating;
  final Function(double) onRatingUpdate;

  const _RatingItem({
    required this.title,
    required this.initialRating,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xff272727),
            bottom: 8,
          ),
          Center(
            child: RatingBar.builder(
              initialRating: initialRating == 0 ? 1 : initialRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemPadding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Color(0xffFD713F),
              ),
              onRatingUpdate: onRatingUpdate,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Price Row ───────────────────────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
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
            text: "\$${value.toStringAsFixed(2)}",
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xff272727),
          ),
        ],
      ),
    );
  }
}