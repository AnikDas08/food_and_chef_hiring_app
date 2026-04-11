import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
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
      // ── Find the live item in the controller ──
      CartMenuItem? liveItem;
      for (final group in controller.chefGroups) {
        liveItem = group.menus?.firstWhereOrNull((m) => m.id == cartItemId);
        if (liveItem != null) break;
      }
      final int liveQty = liveItem?.quantity ?? currentQty;

      return Container(
        padding: EdgeInsets.all(10.r), // Uniform responsive padding
        margin: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left Column: Text & Controls ──────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Delete Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CommonText(
                          text: name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff272727),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      _buildDeleteBtn(context, controller, cartItemId, chefId),
                    ],
                  ),
                  8.height,

                  // Customization Pills
                  if (item.customizations != null && item.customizations!.isNotEmpty) ...[
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: item.customizations!.map((c) => _buildPill(c)).toList(),
                    ),
                    10.height,
                  ],

                  // Cooking Time Badge
                  if (item.unitTimeStr != null) ...[
                    _buildCookingTimeBadge(item.unitTimeStr!),
                    12.height,
                  ],

                  // Quantity Stepper
                  _buildStepper(context, controller, cartItemId, chefId, liveQty),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // ── Right Side: Product Image ─────────────────────────────
            CommonImage(
              imageSrc: imageUrl,
              size: 95.r, // Scaled for density
              borderRadius: 8.r,
              fill: BoxFit.cover,
            ),
          ],
        ),
      );
    },
  );
}

// ── REUSABLE RESPONSIVE SUB-WIDGETS ──

Widget _buildDeleteBtn(BuildContext context, CartController controller, String id, String chefId) {
  return InkWell(
    onTap: () => _confirmDelete(context, controller, id, chefId),
    borderRadius: BorderRadius.circular(20.r),
    child: Padding(
      padding: EdgeInsets.all(4.r),
      child: Icon(
        Icons.delete_outline_rounded,
        size: 20.r,
        color: const Color(0xffE53935),
      ),
    ),
  );
}

Widget _buildPill(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: const Color(0xffE0E0E0)),
    ),
    child: CommonText(
      text: text,
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xff555555),
    ),
  );
}

Widget _buildCookingTimeBadge(String time) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined, size: 14.r, color: const Color(0xff777777)),
        SizedBox(width: 4.w),
        Flexible(
          child: CommonText(
            text: "Cooking Time: $time",
            fontSize: 11.sp,
            color: const Color(0xff777777),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

Widget _buildStepper(BuildContext context, CartController controller, String id, String chefId, int qty) {
  return Container(
    padding: EdgeInsets.all(6.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepperActionBtn(
          icon: Icons.remove,
          onTap: () => qty <= 1
              ? _confirmDelete(context, controller, id, chefId)
              : controller.updateQuantity(cartItemId: id, increment: false, chefId: chefId),
        ),
        SizedBox(
          width: 32.w,
          child: CommonText(
            text: qty.toString(),
            textAlign: TextAlign.center,
            fontSize: 14.sp, fontWeight: FontWeight.w600
          ),
        ),
        _stepperActionBtn(
          icon: Icons.add,
          onTap: () => controller.updateQuantity(cartItemId: id, increment: true, chefId: chefId),
        ),
      ],
    ),
  );
}

Widget _stepperActionBtn({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20.r),
    child: Padding(
      padding: EdgeInsets.all(4.r),
      child: Icon(icon, size: 16.r, color: const Color(0xff272727)),
    ),
  );
}

// ── CONFIRMATION DIALOG ──

void _confirmDelete(BuildContext context, CartController controller, String cartItemId, String chefId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: CommonText(
        text: "Remove Item",
        fontSize: 16.sp, fontWeight: FontWeight.w600
      ),

      content: CommonText(
        text: "Are you sure you want to remove this item from your cart?",
        fontSize: 13.sp, color: const Color(0xff777777)
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: CommonText(text: "Cancel", color: const Color(0xff777777), fontSize: 13.sp),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(Get.context!);
            controller.deleteCartItem(cartItemId: cartItemId, chefId: chefId);
          },
          child: CommonText(text: "Remove", color: const Color(0xffE53935), fontWeight: FontWeight.w600, fontSize: 13.sp),
        ),
      ],
    ),
  );
}