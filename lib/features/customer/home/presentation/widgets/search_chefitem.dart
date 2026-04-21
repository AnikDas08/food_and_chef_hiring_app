import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../data/chef_model.dart';

Widget SearchChef({
  num height = 200,
  bool isSearch = false,
  required ChefData chef,
}) {
  bool isVerified = (chef.totalRating ?? 0) >= 5;

  return InkWell(
    onTap: () => Get.toNamed(AppRoutes.chefDetails, arguments: chef),
    child: Container(
      // No fixed width — let the parent (grid cell / ListView) size it
      margin: EdgeInsets.only(right: isSearch ? 0 : 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,   // don't over-expand vertically
        children: [
          // ── Image ──────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  width: double.infinity,  // fills card width exactly
                  height: height.toDouble(),
                  child: CommonImage(
                    imageSrc: chef.image ?? '',
                    height: height.toDouble(),
                    borderRadius: 0,
                    fill: BoxFit.cover,
                  ),
                ),
              ),
              if (isVerified)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: CommonImage(imageSrc: AppIcons.chef),
                ),
            ],
          ),

          // ── Info ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name + Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        chef.name ?? "N/A",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff272727),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xffFD713F),
                          size: 13,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          (chef.avgRating ?? 0).toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xff272727),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // Distance + Experience — each in its own Flexible
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppIcons.location,
                      imageColor: const Color(0xff777777),
                      height: 12,
                      width: 12,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        chef.distance ?? "N/A",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xff777777),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    CommonImage(
                      imageSrc: AppIcons.briefcase,
                      height: 12,
                      width: 12,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        "${chef.experience ?? 0} yrs",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xff777777),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Price — always on its own row, never clipped
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                        "\$${chef.priceWithFee?.toStringAsFixed(2) ?? '0.00'}",
                        style: const TextStyle(
                          color: Color(0xff272727),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: " /hr",
                        style: TextStyle(
                          color: Color(0xff777777),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}