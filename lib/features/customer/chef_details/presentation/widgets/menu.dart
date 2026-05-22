import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/food_item.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../data/mamu_model.dart';
import '../controller/chef_detail_controller.dart';

class MenuPage extends StatelessWidget {
  final bool isSearchMode;

  const MenuPage({super.key, this.isSearchMode = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      builder: (controller) {
        final sections = controller.filteredSections;

        if (controller.isLoadingDetail) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(child: CupertinoActivityIndicator()),
            ),
          );
        }

        // ── Search results view ──────────────────────────────────────
        if (isSearchMode && controller.isSearching) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (controller.searchResults.isEmpty) {
                    return _buildNoSearchResults(controller.searchQuery);
                  }
                  return FoodItem(item: controller.searchResults[index]);
                },
                childCount: controller.searchResults.isEmpty ? 1 : controller.searchResults.length,
              ),
            ),
          );
        }

        if (sections.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: Center(
                child: CommonText(
                  text: 'No menu sections available',
                  color: AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        }

        // ── Combined list for all sections ───────────────────────────
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // We need to flatten the sections and their items
                int currentIndex = 0;
                for (var section in sections) {
                  // Category Header
                  if (currentIndex == index) {
                    // Ensure key exists for this section
                    controller.categoryKeys.putIfAbsent(section, () => GlobalKey());
                    return Container(
                      key: controller.categoryKeys[section],
                      padding: EdgeInsets.only(top: sections.indexOf(section) == 0 ? 12.h : 24.h, bottom: 4.h),
                      child: CommonText(
                        text: section,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff272727),
                        textAlign: TextAlign.start,
                      ),
                    );
                  }
                  currentIndex++;

                  final items = controller.menuCache[section] ?? [];
                  
                  if (items.isEmpty) continue;

                  // Items in section
                  if (index >= currentIndex && index < currentIndex + items.length) {
                    return FoodItem(item: items[index - currentIndex]);
                  }
                  currentIndex += items.length;
                    
                  // Optional: Pagination loader
                  final hasMore = controller.hasMorePages(section);
                  if (hasMore) {
                    if (currentIndex == index) {
                      // Trigger load more
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.loadMoreMenu(section);
                      });
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }
                    currentIndex++;
                  }
                  }
                return null;
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoSearchResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xffCCCCCC),
          ),
          const SizedBox(height: 12),
          CommonText(
            text: 'No results for "$query"',
            color: const Color(0xff777777),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

