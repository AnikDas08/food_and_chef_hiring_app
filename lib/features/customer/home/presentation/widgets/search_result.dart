import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
import '../data/chef_model.dart';

Widget searchResult(List<ChefData> chefs) {
  return Column(
    children: [
      CommonText(
        text: AppString.relatedResult.toUpperCase(),
        fontSize: 12,
        color: const Color(0xff777777),
        top: 16,
        bottom: 16,
      ).start,

      // Show message if no results
      if (chefs.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Column(
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: Color(0xffCCCCCC),
              ),
              SizedBox(height: 16.h),
              const CommonText(
                text: 'No chefs found',
                color: Color(0xff777777),
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        )
      else
        ListView.builder(
          itemCount: chefs.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final chef = chefs[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: InkWell(
                onTap: () {
                  //Navigate to chef details
                  Get.toNamed(AppRoutes.chefDetails, arguments: chef);
                },
                child: Row(
                  children: [
                    // Chef Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CommonImage(
                        imageSrc: ApiEndPoint.imageUrl+chef.image! ?? '',
                        size: 42,
                      ),
                    ),
                    12.width,

                    // Chef Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: chef.name ?? 'Unknown',
                            fontSize: 12,
                            color: const Color(0xff272727),
                            top: 8,
                            bottom: 4,
                          ),
                          Row(
                            children: [
                              // Distance
                              const CommonImage(imageSrc: AppIcons.location),
                              CommonText(
                                text: chef.distance ?? 'N/A',
                                fontSize: 12,
                                color: const Color(0xff777777),
                                left: 4,
                                right: 8,
                              ),

                              // Divider
                              Container(
                                height: 8.h,
                                width: 1,
                                color: const Color(0xffF1F1F1),
                                margin: const EdgeInsets.only(right: 8),
                              ).center,

                              // Experience
                              const CommonImage(imageSrc: AppIcons.briefcase),
                              CommonText(
                                text: '${chef.experience ?? 0} years Experience',
                                fontSize: 12,
                                left: 4,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    ],
  );
}