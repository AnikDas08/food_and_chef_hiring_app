import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../controller/home_controller.dart';
import '../data/order_model.dart';

Widget orderAgain() {
  final HomeController controller = Get.find<HomeController>();

  return GetBuilder<HomeController>(
    builder: (controller) {
      if (controller.isLoadingOrderAgain) {
        return Center(child: CupertinoActivityIndicator());
      }

      if (controller.orderAgainList.isEmpty) {
        return Center(
          child: CommonText(
            text: "No previous orders",
            fontSize: 13,
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
                Row(
                  children: [
                    CommonImage(
                      imageSrc: (order.chef?.image != null &&
                          order.chef!.image!.isNotEmpty)
                          ? order.chef!.image!
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (i) {
                    // If it's the 3rd slot and there are more than 2 items, show moreItem image
                    if (i == 2) {
                      return Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: CommonImage(
                          imageSrc: AppImages.moreItem,
                          height: 78,
                        ),
                      );
                    }

                    // Show menu item image if available, otherwise fallback
                    final menuImages =
                    (i < items.length) ? items[i].menu?.images ?? [] : [];
                    final hasImage =
                        menuImages.isNotEmpty && menuImages[0].isNotEmpty;

                    return Padding(
                      padding: i > 0 ? EdgeInsets.only(left: 6) : EdgeInsets.zero,
                      child: CommonImage(
                        imageSrc: hasImage ? menuImages[0] : AppImages.image5,
                        height: 78,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}