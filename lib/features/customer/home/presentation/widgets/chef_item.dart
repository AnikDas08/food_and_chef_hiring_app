import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../data/chef_model.dart';

Widget chefItem({
  num height = 200,
  bool isSearch = false,
  required ChefData chef,
}) {
  // Check if chef has verified badge (you can adjust this logic)
  final bool isVerified = (chef.totalRating ?? 0) >= 5;

  return InkWell(
    onTap: () => Get.toNamed(AppRoutes.chefDetails, arguments: chef),
    child: Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CommonImage(
                  imageSrc: chef.image ?? '',
                  height: height.toDouble(),
                  width: 240,
                  fill: BoxFit.cover,
                ),
              ),
              if (isVerified)
                const Positioned(
                  bottom: 10,
                  left: 10,
                  child: CommonImage(imageSrc: AppIcons.chef),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 224.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CommonText(
                          text: chef.name ?? 'N/A',
                          fontSize: 12,
                          color: const Color(0xff272727),
                          fontWeight: FontWeight.w600,
                          top: 8,
                          bottom: 4,
                          //maxLine: 1,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: const Color(0xffFD713F),
                            size: 16.sp,
                          ),
                          const SizedBox(width: 4),
                          CommonText(
                            text: (chef.avgRating ?? 0).toStringAsFixed(1),
                            fontSize: 12,
                            color: const Color(0xff272727),
                            fontWeight: FontWeight.w600,
                            left: 4,
                            right: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CommonImage(
                        imageSrc: AppIcons.location,
                        imageColor: Color(0xff777777),
                      ),
                      CommonText(
                        text: chef.distance ?? 'N/A',
                        fontSize: 12,
                        color: const Color(0xff777777),
                        fontWeight: FontWeight.w400,
                        left: 4,
                        right: 16,
                      ),
                      const CommonImage(imageSrc: AppIcons.briefcase),
                      Expanded(
                        child: CommonText(
                          text: '${chef.experience ?? 0} years Experience',
                          fontSize: 12,
                          left: 4,
                          color: const Color(0xff777777),
                          //maxLine: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                isSearch ? 12.height : 24.height,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "\$${chef.pricing?.toStringAsFixed(2) ?? '0.00'}",
                        style: const TextStyle(
                          color: Color(0xff272727),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: ' /hr',
                        style: TextStyle(
                          color: Color(0xff777777),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}