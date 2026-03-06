import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/extensions/extension.dart';
import '../controller/search_controller.dart';
import '../widgets/filter.dart';
import '../widgets/search_item.dart';
import '../widgets/search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController _controller = Get.put(SearchController());
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        title: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 30.r),
            child: TextField(
              controller: _controller.searchController,
              focusNode: _focusNode,
              onChanged: _controller.onSearchChanged,
              onSubmitted: (value) {
                _controller.onSearchSubmitted(value);
                _focusNode.unfocus();
              },
              decoration: InputDecoration(
                hintText: "Search chefs...",
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
                  onPressed: () => Get.back(),
                ),
                suffixIcon: _buildSuffixIcon(),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isTyping = _controller.searchText.value.isNotEmpty;
        final bool isSubmitted = _controller.isSubmitted.value;

        // Typing but NOT yet submitted → show live search results
        if (isTyping && !isSubmitted) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            children: [
              searchResult(_controller.searchResults),
            ],
          );
        }

        // ── MAIN RESULTS VIEW WITH CLEAR FILTERS OPTION ─────────────────
        return Stack(
          children: [
            // Results grid/list
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const SearchItem(),
            ),

            // ── CLEAR FILTERS BUTTON (Floating at top) ──────────────────
            Obx(
                  () {
                // Show clear button only if filters are applied
                final hasActiveFilters = _controller.minPrice.value > 0 ||
                    _controller.maxPrice.value < 100 ||
                    _controller.selectedAvailability.isNotEmpty ||
                    _controller.selectedProfessionalLevels.isNotEmpty ||
                    _controller.selectedDietaryPrefs.isNotEmpty ||
                    _controller.selectedCuisines.isNotEmpty ||
                    _controller.savedChefsOnly.value;

                if (!hasActiveFilters) {
                  return SizedBox.shrink(); // Hide if no filters active
                }

                return Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFD713F),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Clear all filters
                          _controller.clearAllFilters();
                          // Fetch unfiltered results
                          _controller.getNearbyChefs();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                              6.width,
                              CommonText(
                                text: "Clear Filters",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSuffixIcon() {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_controller.searchText.value.isNotEmpty)
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.clear,
              size: 20,
              color: Color(0xff636363),
            ),
            onPressed: () {
              _controller.clearSearch();
              _focusNode.requestFocus();
            },
          ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            _focusNode.unfocus();
            filterPanel();
          },
          icon: CommonImage(
            imageSrc: AppIcons.fliter,
            imageColor: const Color(0xff636363),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    ));
  }
}