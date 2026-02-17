import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../utils/constants/app_icons.dart';
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

        // Use a single ListView to avoid the 'Failed assertion' scroll errors
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          children: [
            if (_controller.hasSearched.value)
              searchResult(_controller.searchResults) // This now returns a Widget
            else
              const SearchItem(), // Recent searches or suggestions
          ],
        );
      }),
    );
  }

  Widget _buildSuffixIcon() {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clear button: shows only when there is text
        if (_controller.searchText.value.isNotEmpty)
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
                Icons.clear,
                size: 20,
                color: Color(0xff636363)
            ),
            onPressed: () {
              _controller.clearSearch();
              _focusNode.requestFocus(); // Keep focus after clearing
            },
          ),

        // Filter button: using your CommonImage component
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            _focusNode.unfocus(); // Close keyboard before opening filter
            filterPanel();
          },
          icon: CommonImage(
            imageSrc: AppIcons.fliter,
            imageColor: const Color(0xff636363),
          ),
        ),

        // Right padding to keep icons away from the edge
        SizedBox(width: 8.w),
      ],
    ));
  }
}