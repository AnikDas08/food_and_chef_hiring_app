import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../data/mamu_model.dart';
import 'item_details.dart';

class FoodItem extends StatefulWidget {
  final MenuData item;

  const FoodItem({super.key, required this.item});

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem>
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

  String _buildImageUrl(String path) {
    if (path.startsWith('http')) return path;
    return ApiEndPoint.imageUrl + path;
  }

  @override
  Widget build(BuildContext context) {
    final MenuData item = widget.item;
    final String? firstImage =
    (item.images != null && item.images!.isNotEmpty)
        ? item.images!.first
        : null;

    // kitchen status badge
    final bool kitchenReady =
        item.kitchenStatus?.toLowerCase() == "ready" ||
            item.kitchenStatus == null;

    return InkWell(
      onTap: () {
        itemDetails(context, _controller, item);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ── Text info ────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Name
                      CommonText(
                        text: item.name ?? "N/A",
                        color: Color(0xff272727),
                        fontWeight: FontWeight.w600,
                      ),
                      4.height,

                      // Ingredients count
                      Row(
                        children: [
                          CommonImage(
                            imageSrc: AppIcons.ingredients,
                            size: 16,
                            imageColor: Color(0xff777777),
                          ),
                          CommonText(
                            text: "Ingredients : ",
                            fontSize: 12,
                            left: 4,
                            color: Color(0xff777777),
                            fontWeight: FontWeight.w400,
                          ),
                          CommonText(
                            text:
                            "${item.ingredients?.length ?? 0} items",
                            fontSize: 12,
                            color: Color(0xff272727),
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      4.height,

                      // Cooking time
                      Row(
                        children: [
                          CommonImage(
                            imageSrc: AppIcons.time,
                            size: 16,
                            imageColor: Color(0xff777777),
                          ),
                          CommonText(
                            text: "Cooking Time : ",
                            fontSize: 12,
                            left: 4,
                            color: Color(0xff777777),
                            fontWeight: FontWeight.w400,
                          ),
                          CommonText(
                            text: item.estCookingTime ?? "N/A",
                            fontSize: 12,
                            color: Color(0xff272727),
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),

                      28.height,

                      // Kitchen status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: kitchenReady
                              ? Color(0xffDBEBD9)
                              : Color(0xffFFF0E0),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: kitchenReady
                                ? Color(0xffC2E2BE)
                                : Color(0xffFFD4A0),
                          ),
                        ),
                        child: CommonText(
                          text: item.kitchenStatus ?? "Your Kitchen is Ready",
                          color: kitchenReady
                              ? Color(0xff2F8328)
                              : Color(0xffC17A00),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Food image ────────────────────────────────────────────
                CommonImage(
                  imageSrc: firstImage != null
                      ? _buildImageUrl(firstImage)
                      : AppImages.image6,
                  size: 120,
                  borderRadius: 8,
                  fill: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}