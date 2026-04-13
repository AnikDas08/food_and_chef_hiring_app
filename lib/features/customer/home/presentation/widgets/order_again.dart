import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../controller/home_controller.dart';
import '../data/order_model.dart';

Widget orderAgain() {
  return GetBuilder<HomeController>(
    builder: (controller) {
      if (controller.isLoadingOrderAgain) {
        return Center(child: CupertinoActivityIndicator());
      }

      if (controller.orderAgainList.isEmpty) {
        return Center(
          child: CommonText(
            text: "No previous orders",
            fontSize: 12.sp,
            color: Color(0xff777777),
            fontWeight: FontWeight.w400,
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.orderAgainList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final OrderAgainData order = controller.orderAgainList[index];
          final List<OrderStaticItem> items = order.staticItems ?? [];
          final int totalItems = items.length;

          // Always show max 2 food images; remaining shown as "X more items"
          final int visibleCount = totalItems > 2 ? 2 : totalItems;
          final int moreCount = totalItems > 2 ? totalItems - 2 : 0;

          return Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chef info row
                Row(
                  children: [
                    CommonImage(
                      imageSrc: (order.chef?.image != null &&
                          order.chef!.image!.isNotEmpty)
                          ? ApiEndPoint.imageUrl + order.chef!.image!
                          : AppImages.image4,
                      size: 40,
                    ),
                    12.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: order.chef?.name ?? "Chef",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                        CommonText(
                          text: order.dateStr ?? "",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff777777),
                        ),
                      ],
                    ),
                  ],
                ),

                12.height,

                // Food images row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show up to 2 food images with name overlay
                    ...List.generate(visibleCount, (i) {
                      final menuImages = items[i].menu?.images ?? [];
                      final hasImage =
                          menuImages.isNotEmpty && menuImages[0].isNotEmpty;
                      final menuName = items[i].menu?.name ?? "";

                      return Padding(
                        padding: EdgeInsets.only(
                          right: (i < visibleCount - 1 || moreCount > 0) ? 6 : 0,
                        ),
                        child: _foodImageWithName(
                          imageSrc: hasImage
                              ? ApiEndPoint.imageUrl + menuImages[0]
                              : AppImages.noImage,
                          name: menuName,
                        ),
                      );
                    }),

                    // Show "X more items" tile if there are extras
                    if (moreCount > 0) _moreItemsTile(moreCount),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// Food image card with name label overlaid at the bottom
Widget _foodImageWithName({
  required String imageSrc,
  required String name,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Stack(
      children: [
        CommonImage(
          imageSrc: imageSrc,
          height: 78,
          width: 78,
          fill: BoxFit.cover,
        ),
        // Dark gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),
        ),
        // Name label
        Positioned(
          bottom: 6,
          left: 5,
          right: 5,
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

/// "X more items" tile matching the design (white background, fork icon, text)
Widget _moreItemsTile(int count) {
  return Container(
    height: 78,
    width: 78,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.collections,
          size: 22,
          color: Color(0xff9E9E9E),
        ),
        4.height,
        Text(
          "$count more\nitems",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: Color(0xff9E9E9E),
          ),
        ),
      ],
    ),
  );
}