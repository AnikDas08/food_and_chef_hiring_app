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
  final ScrollController _scrollController = ScrollController();

  // Prevent firing loadMore multiple times for the same scroll event
  bool _isScrollLoadingLocked = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.shouldOpenFilter.value) {
        _controller.shouldOpenFilter.value = false;
        filterPanel();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    // Only trigger when near the bottom, not already loading, and more data exists
    if (currentScroll >= maxScroll - threshold &&
        !_controller.isLoadingMore.value &&
        _controller.hasMoreData.value &&
        !_isScrollLoadingLocked) {
      _isScrollLoadingLocked = true;

      final term =
          _controller.isSubmitted.value
              ? _controller.searchController.text.trim()
              : null;

      _controller.loadMoreChefs(searchTerm: term).then((_) {
        _isScrollLoadingLocked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 90.h,
        titleSpacing: 16.w,
        title: LiquidGlassLayer(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: 20.r),
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2).withOpacity(0.8),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: const Color(0xff272727),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller.searchController,
                      focusNode: _focusNode,
                      onChanged: _controller.onSearchChanged,
                      onSubmitted: (value) {
                        _controller.onSearchSubmitted(value);
                        _focusNode.unfocus();
                      },
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: 'Search chefs...',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xff777777),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  _buildSuffixIcon(),
                ],
              ),
            ),
          ),
        ),
        flexibleSpace: LiquidGlassLayer(
          child: LiquidGlass(
            shape: const LiquidRoundedSuperellipse(borderRadius: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
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
            padding: EdgeInsets.fromLTRB(16.w, 150.h, 16.w, 10.h),
            children: [searchResult(_controller.searchResults)],
          );
        }

        // ── MAIN RESULTS VIEW WITH PAGINATION ───────────────────────────
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 150.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── CLEAR FILTERS BUTTON ───────────────────
              Obx(() {
                final hasActiveFilters =
                    _controller.minPrice.value > 0 ||
                    _controller.maxPrice.value < 100 ||
                    _controller.selectedAvailability.isNotEmpty ||
                    _controller.selectedProfessionalLevels.isNotEmpty ||
                    _controller.selectedDietaryPrefs.isNotEmpty ||
                    _controller.selectedCuisines.isNotEmpty ||
                    _controller.savedChefsOnly.value;

                if (!hasActiveFilters) return const SizedBox.shrink();

                return Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      _controller.clearAllFilters();
                      _controller.getNearbyChefs();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const CommonText(
                      text: 'Clear Filters',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFD713F),
                    ),
                  ),
                );
              }),

              // ── Results grid ──────────────────────────────────────────
              SearchItem(scrollController: _scrollController),

              // ── LOAD MORE INDICATOR (bottom of list) ─────────────────
              Obx(() {
                if (!_controller.isLoadingMore.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xffFD713F),
                            ),
                          ),
                          8.width,
                          const CommonText(
                            text: 'Loading more chefs...',
                            fontSize: 12,
                            color: Color(0xff636363),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // ── END OF LIST MESSAGE ───────────────────────────────────
              Obx(() {
                if (_controller.hasMoreData.value ||
                    _controller.nearbyChefsList.isEmpty ||
                    _controller.isLoadingMore.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: CommonText(
                      text:
                          'Showing all ${_controller.nearbyChefsList.length} chefs',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff777777),
                    ),
                  ),
                );
              }),

              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSuffixIcon() {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_controller.searchText.value.isNotEmpty)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.clear, size: 20, color: Color(0xff636363)),
              onPressed: () {
                _controller.clearSearch();
                _focusNode.requestFocus();
              },
            ),
          Container(width: 1, height: 22.h, color: const Color(0xffE0E0E0)),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              _focusNode.unfocus();
              filterPanel();
            },
            icon: const CommonImage(
              imageSrc: AppIcons.fliter,
              imageColor: Color(0xff636363),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
