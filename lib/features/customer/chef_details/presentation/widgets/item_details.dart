import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../data/mamu_model.dart';
import '../controller/chef_detail_controller.dart';
import 'exten_text.dart';

String _buildImageUrl(String path) {
  if (path.startsWith('http')) return path;
  return ApiEndPoint.imageUrl + path;
}

void itemDetails(
    BuildContext context, AnimationController controller, MenuData item) {
  // Resolve image
  final String? firstImage =
  (item.images != null && item.images!.isNotEmpty) ? item.images!.first : null;
  final String imageUrl =
  firstImage != null ? _buildImageUrl(firstImage) : AppImages.image6;

  // Kitchen status
  final bool kitchenReady =
      item.kitchenStatus?.toLowerCase() == "ready" || item.kitchenStatus == null;

  // Ingredient names joined
  final String ingredientNames = item.ingredients != null && item.ingredients!.isNotEmpty
      ? item.ingredients!.map((e) => e.name ?? '').where((n) => n.isNotEmpty).join(', ')
      : 'N/A';

  // Special equipment names joined
  final String equipmentNames =
  item.specialEquipment != null && item.specialEquipment!.isNotEmpty
      ? item.specialEquipment!.map((e) => e.name ?? '').where((n) => n.isNotEmpty).join(', ')
      : 'None';

  final bool hasSpecialEquipment =
      item.specialEquipment != null && item.specialEquipment!.isNotEmpty;

  // Customizations to show as dish options
  final List<Map<String, dynamic>> dishOptions = item.customizations != null
      ? item.customizations!.map((c) => {"name": c, "isSelected": false}).toList()
      : [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    transitionAnimationController: controller,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<ChefDetailsController>(
        builder: (ctrl) {
          return SafeArea(
            child: DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.5,
              initialChildSize: 1,
              maxChildSize: 1,
              builder: (_, scrollController) {
                return Column(
                  children: [
                    // Drag handle
                    Container(
                      height: 4,
                      width: 40.w,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16).copyWith(bottom: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Food image ──────────────────────────────
                            CommonImage(
                              imageSrc: imageUrl,
                              borderRadius: 8,
                              height: 232,
                              width: Get.width,
                              fill: BoxFit.fill,
                            ),

                            // ── Name ────────────────────────────────────
                            CommonText(
                              text: item.name ?? 'N/A',
                              color: const Color(0xff272727),
                              fontSize: 16,
                              top: 16,
                              fontWeight: FontWeight.w600,
                            ),

                            8.height,

                            // ── Cooking time + Kitchen status row ───────
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF2F2F2),
                                    border: Border.all(
                                      color: const Color(0xffF2F2F2),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonImage(
                                        imageSrc: AppIcons.time,
                                        size: 16,
                                        imageColor: const Color(0xff777777),
                                      ),
                                      4.width,
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Cooking Time: ",
                                              style: TextStyle(
                                                color: Color(0xff777777),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: item.estCookingTime ?? 'N/A',
                                              style: const TextStyle(
                                                color: Color(0xff272727),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                8.width,

                                // Kitchen status badge
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: kitchenReady
                                          ? const Color(0xffDBEBD9)
                                          : const Color(0xffFFF0E0),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: kitchenReady
                                            ? const Color(0xffC2E2BE)
                                            : const Color(0xffFFD4A0),
                                      ),
                                    ),
                                    child: CommonText(
                                      text: item.kitchenStatus ?? 'Kitchen Ready',
                                      color: kitchenReady
                                          ? const Color(0xff2F8328)
                                          : const Color(0xffC17A00),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            8.height,

                            // ── Prep time ───────────────────────────────
                            if (item.estPrepTime != null) ...[
                              Row(
                                children: [
                                  CommonImage(
                                    imageSrc: AppIcons.time,
                                    size: 16,
                                    imageColor: const Color(0xff777777),
                                  ),
                                  4.width,
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Prep Time: ",
                                          style: TextStyle(
                                            color: Color(0xff777777),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.estPrepTime!,
                                          style: const TextStyle(
                                            color: Color(0xff272727),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              8.height,
                            ],

                            // ── Diet types & Allergens tags ─────────────
                            if (item.dietTypes != null && item.dietTypes!.isNotEmpty) ...[
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: item.dietTypes!.map((diet) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBEBD9),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: const Color(0xffC2E2BE)),
                                    ),
                                    child: CommonText(
                                      text: diet,
                                      color: const Color(0xff2F8328),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                }).toList(),
                              ),
                              8.height,
                            ],

                            if (item.alergens != null && item.alergens!.isNotEmpty) ...[
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: item.alergens!.map((allergen) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF0E0),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: const Color(0xffFFD4A0)),
                                    ),
                                    child: CommonText(
                                      text: '⚠ $allergen',
                                      color: const Color(0xffC17A00),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                }).toList(),
                              ),
                              8.height,
                            ],

                            // ── Description ─────────────────────────────
                            if (item.description != null) ...[
                              ExtendText(
                                text: item.description!,
                                isExpanded: ctrl.isExpanded,
                                onTap: ctrl.onChangeExpand,
                              ),
                              8.height,
                            ],

                            const Divider(),
                            12.height,

                            // ── Customizations ──────────────────────────
                            if (dishOptions.isNotEmpty) ...[
                              CommonText(
                                text: "Customize the Dish",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff272727),
                              ),
                              ...List.generate(ctrl.dish.length, (index) {
                                final isSelected = ctrl.dish[index]["isSelected"];
                                return InkWell(
                                  onTap: () => ctrl.onChangeDish(index),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 15.sp,
                                          width: 15.sp,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.black
                                                : const Color(0xffF1F1F1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: isSelected
                                              ? Icon(Icons.check,
                                              color: Colors.white,
                                              size: 12.sp)
                                              : null,
                                        ),
                                        CommonText(
                                          text: ctrl.dish[index]["name"],
                                          color: const Color(0xff272727),
                                          fontSize: 12,
                                          left: 8,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              12.height,
                              const Divider(),
                              12.height,
                            ],

                            // ── Ingredients ─────────────────────────────
                            CommonText(
                              text: "List of Ingredients",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                              bottom: 8,
                            ),
                            if (item.ingredients != null &&
                                item.ingredients!.isNotEmpty)
                              ...item.ingredients!.map((ingredient) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.circle,
                                          size: 6, color: Color(0xff777777)),
                                      8.width,
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: ingredient.name ?? '',
                                                style: const TextStyle(
                                                  color: Color(0xff272727),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (ingredient.quantity != null ||
                                                  ingredient.unit != null)
                                                TextSpan(
                                                  text:
                                                  ' — ${ingredient.quantity ?? ''} ${ingredient.unit ?? ''}'
                                                      .trim(),
                                                  style: const TextStyle(
                                                    color: Color(0xff777777),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()
                            else
                              CommonText(
                                text: 'N/A',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff272727),
                              ),

                            // ── Special Equipment ────────────────────────
                            CommonText(
                              text: "Special Equipment",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                              top: 16,
                              bottom: 8,
                            ),
                            CommonText(
                              text: hasSpecialEquipment ? equipmentNames : 'None required',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff272727),
                            ),

                            // ── Avg Rating & Bookings ────────────────────
                            if ((item.avgRating ?? 0) > 0 ||
                                (item.totalBooking ?? 0) > 0) ...[
                              16.height,
                              Row(
                                children: [
                                  if ((item.avgRating ?? 0) > 0) ...[
                                    const Icon(Icons.star_rounded,
                                        color: Color(0xffF5A623), size: 18),
                                    4.width,
                                    CommonText(
                                      text: item.avgRating!.toStringAsFixed(1),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff272727),
                                    ),
                                    16.width,
                                  ],
                                  if ((item.totalBooking ?? 0) > 0)
                                    CommonText(
                                      text: '${item.totalBooking} bookings',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff777777),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // ── Add to Order button ──────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          const Divider(),
                          4.height,
                          CommonButton(
                            titleText: AppString.addToOrder,
                            onTap: () {
                              ctrl.addToCart({
                                "name": item.name ?? 'Item',
                                "id": item.id,
                              });
                            },
                          ),
                          16.height,
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}