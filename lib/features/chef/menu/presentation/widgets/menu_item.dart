import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';

Widget menuItem() {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  text: 'Quesadilla',
                  color: Color(0xff272727),
                  fontWeight: FontWeight.w600,
                ),
                4.height,
                const Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.ingredients,
                      size: 16,
                      imageColor: Color(0xff777777),
                    ),
                    CommonText(
                      text: 'Ingredients : ',
                      fontSize: 12,
                      left: 4,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w400,
                    ),
                    CommonText(
                      text: '10 items',
                      fontSize: 12,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                4.height,
                const Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.time,
                      size: 16,
                      imageColor: Color(0xff777777),
                    ),
                    CommonText(
                      text: 'Cooking Time : ',
                      fontSize: 12,
                      left: 4,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w400,
                    ),
                    CommonText(
                      text: '40 minutes',
                      fontSize: 12,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                28.height,
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.editMenu);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [

                            SvgPicture.asset(
                              AppIcons.editmanu,
                              width: 16,
                              height: 16,
                            ),

                            const SizedBox(width: 6),

                            CommonText(
                              text: 'Edit Item',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(CupertinoIcons.delete, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /*const CommonImage(
            imageSrc: (item.images != null && item.images!.isNotEmpty) ? _buildImageUrl(item.images!.first) : AppImages.noImage,
            size: 120,
            borderRadius: 8,
          ),*/
        ],
      ),
    ),
  );
}
