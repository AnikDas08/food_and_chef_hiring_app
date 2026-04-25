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

import 'package:new_untitled/features/customer/chef_details/data/mamu_model.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/item_details.dart';

Widget cartItem(BuildContext context, CartMenuItem item, String chefId) {
  // We need an AnimationController for itemDetails
  // However, cartItem is a stateless-like function used in a ListView.
  // We can use Get.find if there's a controller or just create a one-off.
  // For the sake of consistency with food_item.dart, we'll need a TickerProvider.
  // Since cartItem is a function, we might need to wrap it or use a different approach.

  final CartMenuDetail? menuDetail =
  item.menu != null && item.menu!.isNotEmpty ? item.menu!.first : null;

  final String imageUrl =
  (menuDetail?.images != null && menuDetail!.images!.isNotEmpty)
      ? (menuDetail.images!.first.startsWith('http')
      ? menuDetail.images!.first
      : ApiEndPoint.imageUrl + menuDetail.images!.first)
      : AppImages.noImage;

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

      return _CartItemInkWell(
        controller: controller,
        item: item,
        menuDetail: menuDetail,
        chefId: chefId,
        name: name,
        cartItemId: cartItemId,
        liveQty: liveQty,
        imageUrl: imageUrl,
      );
    },
  );
}

class _CartItemInkWell extends StatefulWidget {
  final CartController controller;
  final CartMenuItem item;
  final CartMenuDetail? menuDetail;
  final String chefId;
  final String name;
  final String cartItemId;
  final int liveQty;
  final String imageUrl;

  const _CartItemInkWell({
    required this.controller,
    required this.item,
    required this.menuDetail,
    required this.chefId,
    required this.name,
    required this.cartItemId,
    required this.liveQty,
    required this.imageUrl,
  });

  @override
  State<_CartItemInkWell> createState() => _CartItemInkWellState();
}

class _CartItemInkWellState extends State<_CartItemInkWell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.controller.isEditingOrder
          ? () {
              if (widget.menuDetail == null) return;

              final menuData = MenuData(
                id: widget.menuDetail!.id,
                name: widget.menuDetail!.name,
                images: widget.menuDetail!.images,
                estCookingTime: widget.item.unitTimeStr,
                customizations: widget.menuDetail!.customizations ?? [],
              );

              itemDetails(
                context,
                _controller,
                menuData,
                cartItem: widget.item,
                chefId: widget.chefId,
              );
            }
          : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        margin: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CommonText(
                          text: widget.name,
                          maxLines: 5,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: const Color(0xff272727),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      //_buildDeleteBtn(context, widget.controller, widget.cartItemId, widget.chefId),
                    ],
                  ),
                  8.height,
                  if (widget.item.customizations != null && widget.item.customizations!.isNotEmpty) ...[
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: widget.item.customizations!.map((c) => _buildPill(c)).toList(),
                    ),
                    10.height,
                  ],
                  _buildStepper(context, widget.controller, widget.cartItemId, widget.chefId, widget.liveQty),
                  12.height,
                  if (widget.item.unitTimeStr != null) ...[
                    //_buildCookingTimeBadge(widget.item.unitTimeStr!),
                    //12.height,
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),
            CommonImage(
              imageSrc: widget.imageUrl,
              size: 95.r,
              borderRadius: 8.r,
              fill: BoxFit.cover,
              defaultImage: AppImages.noImage,
            ),
          ],
        ),
      ),
    );
  }
}

// ── REUSABLE RESPONSIVE SUB-WIDGETS ──

/*
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
*/

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
        Row(
          children: [
            CommonText(
              text: 'Cooking Time: ',
              fontSize: 11.sp,
              color: const Color(0xff777777),
              fontWeight: FontWeight.w400,
            ),
            CommonText(
              text: time,
              fontSize: 11.sp,
              color: const Color(0xff272727),
              fontWeight: FontWeight.w400,
            ),
          ],
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
          onTap: () {
            if (qty > 1) {
              controller.updateQuantity(
                  cartItemId: id, increment: false, chefId: chefId);
            }
          },
          // onTap: () => qty <= 1
          //     ? _confirmDelete(context, controller, id, chefId)
          //     : controller.updateQuantity(cartItemId: id, increment: false, chefId: chefId),
        ),
        SizedBox(
          width: 32.w,
          child: CommonText(
            text: qty.toString(),
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

/*
void _confirmDelete(BuildContext context, CartController controller, String cartItemId, String chefId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: CommonText(
        text: 'Remove Item',
        fontSize: 16.sp, fontWeight: FontWeight.w600
      ),

      content: CommonText(
        text: 'Are you sure you want to remove this item from your cart?',
        fontSize: 13.sp, color: const Color(0xff777777),
        maxLines: 2,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: CommonText(text: 'Cancel', color: const Color(0xff777777), fontSize: 13.sp),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(Get.context!);
            controller.deleteCartItem(cartItemId: cartItemId, chefId: chefId);
          },
          child: CommonText(text: 'Remove', color: const Color(0xffE53935), fontWeight: FontWeight.w600, fontSize: 13.sp),
        ),
      ],
    ),
  );
}
*/