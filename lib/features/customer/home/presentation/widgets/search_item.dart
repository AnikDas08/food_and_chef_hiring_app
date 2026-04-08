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
              top: 24,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xff272727),
              bottom: 12,
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
              top: 20,
            ).start,
            Obx(
                  () => CommonText(
                text: "Showing ${chefs.length} related results",
                fontSize: 12,
                color: const Color(0xff777777),
                fontWeight: FontWeight.w400,
                top: 2,
                bottom: 16,
              ).start,
            ),

            // ── Grid ─────────────────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? const CommonLoader()
                  : chefs.isEmpty
                  ? Center(
                child: CommonText(
                  text: "No chefs found nearby",
                  fontSize: 14,
                  color: const Color(0xff777777),
                  fontWeight: FontWeight.w400,
                ),
              )
                  : GridView.builder(
                // ✅ Attach the shared scroll controller
                controller: scrollController,
                // Allow the grid to scroll inside Column/Stack
                physics: const AlwaysScrollableScrollPhysics(),
                // +1 for the bottom loader row
                itemCount: chefs.length + 1,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250.h,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                itemBuilder: (context, index) {
                  // ── Last slot → loading indicator or end label ──
                  if (index == chefs.length) {
                    return Obx(
                          () => controller.isLoadingMore.value
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFD713F),
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : controller.hasMoreData.value
                          ? const SizedBox.shrink()
                          : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h),
                        /*child: Center(
                          child: CommonText(
                            text:
                            "You've seen all ${chefs.length} chefs",
                            fontSize: 12,
                            color:
                            const Color(0xffAAAAAA),
                            fontWeight: FontWeight.w400,
                          ),
                        ),*/
                      ),
                    );
                  }

                  return chefItem(
                    height: 140.h,
                    isSearch: true,
                    chef: chefs[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}