import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../data/cart_model.dart';

import 'package:get/get.dart';
import '../controller/cart_controller.dart';

Widget chefInfo(CartChefInfo? chef) {
  final controller = Get.find<CartController>();
  final String imageUrl = (chef?.image != null && chef!.image!.isNotEmpty)
      ? (chef.image!.startsWith('http')
      ? chef.image!
      : ApiEndPoint.imageUrl + chef.image!)
      : AppImages.image3;

  return Row(
    children: [
      CommonImage(
        imageSrc: imageUrl,
        size: 44,
        borderRadius: 50,
        fill: BoxFit.cover,
      ),
      12.width,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: chef?.name ?? 'Chef',
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/price.svg',
                ),
                const SizedBox(width: 8,),
                CommonText(
                  text: chef?.pricing != null
                      ? '\$${chef!.pricing!.toStringAsFixed(2)} per hour'
                      : '',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff777777),
                ),
              ],
            ),
          ],
        ),
      ),
      /*Obx(() => InkWell(
        onTap: controller.toggleEditingOrder,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: controller.isEditingOrder ? Colors.black : const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.mode_edit_outline_outlined,
                size: 16,
                color: controller.isEditingOrder ? Colors.white : Colors.black,
              ),
              CommonText(
                text: controller.isEditingOrder ? 'Done' : AppString.editOrder,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: controller.isEditingOrder ? Colors.white : const Color(0xff272727),
                left: 6,
              ),
            ],
          ),
        ),
      )),*/
    ],
  );
}