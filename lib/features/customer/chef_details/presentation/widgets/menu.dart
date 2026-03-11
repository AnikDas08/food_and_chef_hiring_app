import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/food_item.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:new_untitled/utils/log/app_log.dart';
import '../../../../../component/other_widgets/common_loader.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../data/mamu_model.dart';
import '../controller/chef_detail_controller.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      builder: (controller) {
        final List<String> sections = controller.chefDetail?.menuSections ?? [];

        if (controller.isLoadingDetail) return const SizedBox.shrink();

        if (sections.isEmpty) {
          return Center(
            child: CommonText(
              text: "No menu sections available",
              fontSize: 14,
              color: Color(0xff777777),
              fontWeight: FontWeight.w400,
            ),
          );
        }

        return DefaultTabController(
          length: sections.length,
          child: Scaffold(
            body: Obx(
                  () => SafeArea(
                top: controller.innerBoxIsScrolled.value,
                child: Column(
                  children: [
                    _Header(sections: sections),
                    Expanded(
                      child: TabBarView(
                        children: sections
                            .map((s) => _MenuList(section: s))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Tab header ──────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final List<String> sections;
  const _Header({required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onPanUpdate: (details) => appLog(details.globalPosition),
          child: CommonText(
            text: AppString.menu,
            fontSize: 16,
            left: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
        ),
        8.height,
        TabBar(
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Color(0xff777777),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          isScrollable: sections.length > 3,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xffFD713F),
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff636363),
          ),
          tabs: sections.map((s) => Tab(text: s)).toList(),
        ),
      ],
    );
  }
}

// ── Per-section list with pagination ───────────────────────────────────────

class _MenuList extends StatefulWidget {
  final String section;
  const _MenuList({required this.section});

  @override
  State<_MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<_MenuList>
    with AutomaticKeepAliveClientMixin {

  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Fetch first page when tab first appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = Get.find<ChefDetailsController>();
      final hasId = c.chefArg?.id != null || c.chefId.isNotEmpty;
      if (hasId) {
        c.fetchMenuForSection(widget.section);
      }
    });

    // Load more when user scrolls near the bottom
    _scrollController.addListener(() {
      final c = Get.find<ChefDetailsController>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        c.loadMoreMenu(widget.section);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GetBuilder<ChefDetailsController>(
      builder: (controller) {
        final bool isFirst = !controller.menuCache.containsKey(widget.section);
        final bool isLoading =
            controller.isLoadingMenu &&
                controller.selectedMenuSection == widget.section;

        // First load spinner
        if (isFirst || (isLoading && (controller.menuCache[widget.section]?.isEmpty ?? true))) {
          return const CommonLoader();
        }

        final List<MenuData> items =
            controller.menuCache[widget.section] ?? [];

        if (items.isEmpty) {
          return Center(
            child: CommonText(
              text: "No items in this section",
              fontSize: 14,
              color: Color(0xff777777),
              fontWeight: FontWeight.w400,
            ),
          );
        }

        final bool hasMore = controller.hasMorePages(widget.section);
        final bool loadingMore =
        controller.isLoadingMoreForSection(widget.section);

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // +1 for the loader/end row at the bottom
          itemCount: items.length + 1,
          itemBuilder: (_, index) {
            // Last item — show loader or "no more" indicator
            if (index == items.length) {
              if (loadingMore) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (!hasMore && items.length > 10) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CommonText(
                      text: "No more items",
                      fontSize: 12,
                      color: Color(0xff777777),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            return FoodItem(item: items[index]);
          },
        );
      },
    );
  }
}