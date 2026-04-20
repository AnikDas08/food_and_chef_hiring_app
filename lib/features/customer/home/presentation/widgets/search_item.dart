import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/other_widgets/common_loader.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../controller/search_controller.dart';
import 'chef_item.dart';

const List<String> _sortList = [
  "Recommended",
  "Rating",
  "Price",
  "Next Available",
];

class SearchItem extends StatelessWidget {
  final ScrollController scrollController;

  const SearchItem({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder: (controller) {
        final chefs = controller.nearbyChefsList;
        final isLoading =
            controller.isLoadingLocation || controller.isLoadingChefs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Sort by label ────────────────────────────────────────────
            CommonText(
              text: AppString.sortBy,
              top: 0,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
              bottom: 8,
            ).start,

            // ── Sort filter chips ────────────────────────────────────────
            SizedBox(
              height: 36.h,
              child: ListView.builder(
                itemCount: _sortList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final String label = _sortList[index];
                  final bool isSelected =
                      controller.selectedSortLabel == label;

                  return InkWell(
                    onTap: () => controller.onSortChanged(label),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xff272727)
                            : const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: CommonText(
                          text: label,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xff272727),
                        ),
                      ),
                    ).center,
                  );
                },
              ),
            ),

            // ── Related results label ────────────────────────────────────
            CommonText(
              text: AppString.relatedResult,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
              top: 12,
            ).start,
            Obx(
                  () => CommonText(
                text: "Showing ${chefs.length} related results",
                fontSize: 12,
                color: const Color(0xff777777),
                fontWeight: FontWeight.w400,
                top: 0,
                bottom: 8,
              ).start,
            ),

            // ── Grid ─────────────────────────────────────────────────────
            if (isLoading)
              const CommonLoader()
            else if (chefs.isEmpty)
              Center(
                child: CommonText(
                  text: "No chefs found nearby",
                  fontSize: 14,
                  color: const Color(0xff777777),
                  fontWeight: FontWeight.w400,
                ),
              )
            else
            // itemCount is exactly chefs.length — no extra loader slot needed.
            // The loading indicator lives in SearchScreen below this widget.
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: chefs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 230.h,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                ),
                itemBuilder: (context, index) {
                  return chefItem(
                    height: 140.h,
                    isSearch: true,
                    chef: chefs[index],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}