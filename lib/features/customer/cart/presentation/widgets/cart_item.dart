import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../data/cart_model.dart';
import '../controller/cart_controller.dart';

Widget cartItem(BuildContext context, CartMenuItem item, String chefId) {
  final CartMenuDetail? menuDetail =
  item.menu != null && item.menu!.isNotEmpty ? item.menu!.first : null;

  final String imageUrl =
  (menuDetail?.images != null && menuDetail!.images!.isNotEmpty)
      ? (menuDetail.images!.first.startsWith('http')
      ? menuDetail.images!.first
      : ApiEndPoint.imageUrl + menuDetail.images!.first)
      : AppImages.image6;

  final String name = menuDetail?.name ?? 'N/A';
  final String cartItemId = item.id ?? '';
  final int currentQty = item.quantity ?? 1;

  return GetBuilder<CartController>(
    builder: (controller) {
      // ── Read live data from controller so qty + price update reactively ──
      CartMenuItem? liveItem;
      for (final group in controller.chefGroups) {
        liveItem = group.menus?.firstWhereOrNull((m) => m.id == cartItemId);
        if (liveItem != null) break;
      }
      final int liveQty = liveItem?.quantity ?? currentQty;

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Text info ────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + delete button row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CommonText(
                              text: name,
                              color: const Color(0xff272727),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () => _confirmDelete(
                                context, controller, cartItemId, chefId),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 20,
                                color: Color(0xffE53935),
                              ),
                            ),
                          ),
                        ],
                      ),
                      4.height,

                      // Customizations as pills
                      if (item.customizations != null &&
                          item.customizations!.isNotEmpty) ...[
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: item.customizations!.map((c) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xffE0E0E0)),
                              ),
                              child: CommonText(
                                text: c,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff555555),
                              ),
                            );
                          }).toList(),
                        ),
                        6.height,
                      ],

                      // Cooking time
                      if (item.unitTimeStr != null) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined,
                                  size: 16, color: Color(0xff777777)),
                              CommonText(
                                text: "Cooking Time: ",
                                fontSize: 12,
                                left: 4,
                                color: const Color(0xff777777),
                                fontWeight: FontWeight.w400,
                              ),
                              CommonText(
                                text: item.unitTimeStr!,
                                fontSize: 12,
                                color: const Color(0xff272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        8.height,
                      ],

                     /* // Price line
                      CommonText(
                        text:
                        "\$${(item.unitPrice ?? 0).toStringAsFixed(2)} × $currentQty  =  \$${(item.totalPrice ?? 0).toStringAsFixed(2)}",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff272727),
                      ),*/

                      16.height,

                      // ── Quantity stepper ──────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement
                            InkWell(
                              onTap: () {
                                if (liveQty <= 1) {
                                  _confirmDelete(context, controller,
                                      cartItemId, chefId);
                                } else {
                                  controller.updateQuantity(
                                    cartItemId: cartItemId,
                                    increment: false,
                                    chefId: chefId,
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.remove, size: 16),
                              ),
                            ),

                            // Count
                            SizedBox(
                              width: 36,
                              child: CommonText(
                                text: liveQty.toString(),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff272727),
                              ).center,
                            ),

                            // Increment
                            InkWell(
                              onTap: () {
                                controller.updateQuantity(
                                  cartItemId: cartItemId,
                                  increment: true,
                                  chefId: chefId,
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.add, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),

                      6.height,
                    ],
                  ),
                ),

                8.width,

                // ── Food image ──────────────────────────────────────────
                CommonImage(
                  imageSrc: imageUrl,
                  size: 110,
                  borderRadius: 8,
                  fill: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/// Shows a confirmation dialog before deleting.
void _confirmDelete(BuildContext context, CartController controller,
    String cartItemId, String chefId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Remove Item",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727)),
      ),
      content: const Text(
        "Are you sure you want to remove this item from your cart?",
        style: TextStyle(fontSize: 13, color: Color(0xff777777)),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel",
              style: TextStyle(color: Color(0xff777777))),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            controller.deleteCartItem(
                cartItemId: cartItemId, chefId: chefId);
          },
          child: const Text("Remove",
              style: TextStyle(
                  color: Color(0xffE53935), fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}