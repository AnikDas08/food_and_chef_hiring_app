import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/availability_pop_up.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../controller/chef_detail_controller.dart';
import '../widgets/exten_text.dart';
import '../widgets/menu.dart';

class ChefDetailsScreen extends StatefulWidget {
  const ChefDetailsScreen({super.key});

  @override
  State<ChefDetailsScreen> createState() => _ChefDetailsScreenState();
}

class _ChefDetailsScreenState extends State<ChefDetailsScreen> {
  bool _isCollapsed = false;
  bool _isSearchMode = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  static const double _expandedHeight = 300;
  static const double _collapseThreshold = _expandedHeight - 75 - 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final collapsed = _scrollController.offset > _collapseThreshold;
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
    // Exit search mode if user scrolls back up to expanded state
    if (!collapsed && _isSearchMode) {
      _exitSearchMode();
    }
  }

  void _enterSearchMode() {
    setState(() => _isSearchMode = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _exitSearchMode() {
    setState(() => _isSearchMode = false);
    _searchTextController.clear();
    final controller = Get.find<ChefDetailsController>();
    controller.clearSearch();
    _searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      init: ChefDetailsController(),
      builder: (controller) {
        final chef = controller.chefDetail;

        final String imageUrl =
            (chef?.image != null && chef!.image!.isNotEmpty)
                ? (chef.image!.startsWith('http')
                    ? chef.image!
                    : ApiEndPoint.imageUrl + chef.image!)
                : AppImages.image3;

        final double totalCartPrice =
            (controller.cartItems.length) * (chef?.priceWithFee ?? 0);
        final double pricePerChef = chef?.priceWithFee ?? 0.0;

        final List<String> sections = controller.chefDetail?.menuSections ?? [];

        return Scaffold(
          body: DefaultTabController(
            length: sections.isEmpty ? 1 : sections.length,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: _expandedHeight.h,
                    toolbarHeight: 90.h,
                    backgroundColor: Colors.white,
                    elevation: _isCollapsed ? 1 : 0,
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    leadingWidth: 80,
                    leading:
                        _isCollapsed
                            ? null
                            : Center(
                                child: InkWell(
                                  onTap: Get.back,
                                  child: LiquidGlassLayer(
                                    child: LiquidGlass(
                                      shape: const LiquidRoundedSuperellipse(
                                        borderRadius: 20,
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            CupertinoIcons.back,
                                            color: Color(0xff272727),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                    title:
                        _isCollapsed
                            ? (_isSearchMode
                                ? _SearchAppBarTitle(
                                  controller: controller,
                                  searchTextController: _searchTextController,
                                  searchFocusNode: _searchFocusNode,
                                  onClose: _exitSearchMode,
                                )
                                : _CollapsedAppBarTitle(
                                  controller: controller,
                                  onSearchTap: _enterSearchMode,
                                ))
                            : null,

                    actions:
                        _isCollapsed
                            ? []
                            : [
                              if(LocalStorage.myRole=="CUSTOMER")
                              Center(
                                child: InkWell(
                                  onTap: controller.toggleFavourite,
                                  child: LiquidGlassLayer(
                                    child: LiquidGlass(
                                      shape: const LiquidRoundedSuperellipse(
                                        borderRadius: 20,
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            controller.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                controller.isFavorite
                                                    ? Colors.red
                                                    : Color(0xff272727),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    SharePlus.instance.share(
                                      ShareParams(text: 'https://example.com'),
                                    );
                                  },
                                  child: LiquidGlassLayer(
                                    child: LiquidGlass(
                                      shape: const LiquidRoundedSuperellipse(
                                        borderRadius: 20,
                                      ),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            CupertinoIcons.share,
                                            color: Color(0xff272727),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],

                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: _expandedHeight.h,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child:
                                  controller.isLoadingDetail
                                      ? Container(
                                        color: const Color(0xffF2F2F2),
                                      )
                                      : CommonImage(
                                        imageSrc: imageUrl,
                                        fill: BoxFit.cover,
                                      ),
                            ),
                            const Positioned(
                              bottom: 20,
                              left: 20,
                              child: CommonImage(
                                imageSrc: AppIcons.chef,
                                height: 30,
                                width: 115,
                                fill: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Chef info section ───────────────────────────────
                  SliverToBoxAdapter(
                    child:
                        controller.isLoadingDetail
                            ? SizedBox(
                              height: 180.h,
                              child: const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            )
                            : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                children: [
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        text: chef?.name ?? 'N/A',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff272727),
                                      ),
                                      if(LocalStorage.myRole=="CUSTOMER")
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}",
                                              style: const TextStyle(
                                                color: Color(0xff272727),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' /hr',
                                              style: TextStyle(
                                                color: Color(0xff777777),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if(LocalStorage.myRole=="CUSTOMER")
                                  Row(
                                    children: [
                                      const CommonImage(
                                        imageSrc: AppIcons.location,
                                      ),
                                      CommonText(
                                        text:
                                            controller.chefArg?.distance ??
                                            'N/A',
                                        fontSize: 12,
                                        textAlign: TextAlign.start,
                                        left: 4,
                                        color: const Color(0xff777777),
                                      ),
                                      Container(
                                        height: 8,
                                        width: 1,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        color: const Color(0xffF1F1F1),
                                      ),
                                      const CommonImage(
                                        imageSrc: AppIcons.briefcase,
                                      ),
                                      CommonText(
                                        text:
                                            '${chef?.experience ?? 0} years Experience',
                                        fontSize: 12,
                                        left: 4,
                                        color: const Color(0xff777777),
                                      ),
                                    ],
                                  ),
                                  if(LocalStorage.myRole=="CHEF")
                                    Row(
                                      children: [
                                        const CommonImage(
                                          imageSrc: AppIcons.location,
                                        ),
                                        Expanded(
                                          child: CommonText(
                                            text:
                                            chef?.cookingArea?.address ??
                                                'N/A',
                                            fontSize: 12,
                                            textAlign: TextAlign.start,
                                            left: 4,
                                            color: const Color(0xff777777),
                                          ),
                                        ),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      const Flexible(
                                        child: Icon(
                                          Icons.star,
                                          color: Color(0xffFD713F),
                                          size: 20,
                                        ),
                                      ),
                                      Flexible(
                                        child: CommonText(
                                          text:
                                              '${(chef?.avgRating ?? 0).toStringAsFixed(2)} (${chef?.totalRating ?? 0} Reviews)',
                                          fontSize: 12,
                                          left: 4,
                                          color: const Color(0xff777777),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                    ],
                                  ),

                                  const CommonText(
                                    text: 'Minimum booking length: 1 hour ',
                                    color: AppColors.primaryTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                    top: 8,
                                  ).start,
                                  Text(
                                    'Labour-only chef: groceries provided by you.',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.secondaryTextColor,
                                      fontSize: 12.sp,
                                    ),
                                  ).start,
                                  ExtendText(
                                    text: chef?.about ?? '',
                                    isExpanded: controller.isExpanded,
                                    onTap: controller.onChangeExpand,
                                  ),
                                  const SizedBox(height: 16),
                                  CommonButton(
                                    titleText: AppString.checkAvailability,
                                    onTap: () {
                                      print(
                                        'chef id: 🤣🤣🤣🤣${controller.chefId}',
                                      );
                                      availabilityPopup(
                                        context,
                                        controller.chefId,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                  ),

                  // ── Pinned Menu Title + Tab Bar ─────────────────────
                  if (!controller.isLoadingDetail && sections.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _MenuTabBarDelegate(
                        sections: sections,
                        controller: controller,
                      ),
                    ),
                ];
              },
              body: MenuPage(isSearchMode: _isSearchMode),
            ),
          ),

          // ── Cart bottom bar ─────────────────────────────────────────
          bottomNavigationBar:
              controller.cartItems.isEmpty
                  ? null
                  : SafeArea(
                    top: false,
                    child: InkWell(
                      onTap: () => Get.toNamed(AppRoutes.cart),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: 60,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    CommonText(
                                      text: '${controller.cartItems.length}',
                                      fontWeight: FontWeight.w600,
                                    ).center,
                              ),
                              const CommonText(
                                text: AppString.viewCart,
                                color: Colors.white,
                                left: 8,
                              ),
                              const Spacer(),
                              CommonText(
                                text: '\$${pricePerChef.toStringAsFixed(2)}',
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
    );
  }
}

// ── Search app bar title (active search mode) ────────────────────────────────

class _SearchAppBarTitle extends StatelessWidget {
  final ChefDetailsController controller;
  final TextEditingController searchTextController;
  final FocusNode searchFocusNode;
  final VoidCallback onClose;

  const _SearchAppBarTitle({
    required this.controller,
    required this.searchTextController,
    required this.searchFocusNode,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // ── Search icon (left) ───────────────────────────────────
          const Icon(Icons.search, color: Color(0xff777777), size: 20),
          SizedBox(width: 8.w),

          // ── Text field ──────────────────────────────────────────
          Expanded(
            child: TextField(
              controller: searchTextController,
              focusNode: searchFocusNode,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff272727),
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                hintText: 'Search menu items...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xff999999),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                controller.searchMenu(value);
              },
            ),
          ),

          // ── Clear / Close icon (right) ──────────────────────────
          GestureDetector(
            onTap: () {
              if (searchTextController.text.isNotEmpty) {
                searchTextController.clear();
                controller.clearSearch();
              } else {
                onClose();
              }
            },
            child: Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xff272727),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Collapsed app bar title ───────────────────────────────────────────────────

class _CollapsedAppBarTitle extends StatelessWidget {
  final ChefDetailsController controller;
  final VoidCallback onSearchTap;

  const _CollapsedAppBarTitle({
    required this.controller,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final chef = controller.chefDetail;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // ── White circle back button ─────────────────────────────
          InkWell(
            onTap: () => Navigator.pop(Get.context!),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xff272727),
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // ── Chef name + price + rating ───────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  text: chef?.name ?? 'N/A',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/price.svg',
                            height: 16,
                            width: 16,
                            colorFilter: const ColorFilter.mode(
                              Color(0xff777777),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if(LocalStorage.myRole=="CUSTOMER")
                          CommonText(
                            text:
                                "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}/hr",
                            fontSize: 12,
                            color: const Color(0xff555555),
                          ),
                          if(LocalStorage.myRole=="CHEF")
                            CommonText(
                              text:
                              "\$${chef?.pricing?.toStringAsFixed(2) ?? '0.00'}/hr",
                              fontSize: 12,
                              color: const Color(0xff555555),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star, size: 14, color: Color(0xffFD713F)),
                    const SizedBox(width: 3),
                    CommonText(
                      text: (chef?.avgRating ?? 0).toStringAsFixed(1),
                      fontSize: 12,
                      color: const Color(0xff272727),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Search Icon ──────────────────────────────────────────
          InkWell(
            onTap: onSearchTap,
            child: Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: Color(0xff272727),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pinned tab bar delegate ───────────────────────────────────────────────────

class _MenuTabBarDelegate extends SliverPersistentHeaderDelegate {
  final List<String> sections;
  final ChefDetailsController controller;

  const _MenuTabBarDelegate({required this.sections, required this.controller});

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CommonText(
            text: AppString.menu,
            fontSize: 16,
            left: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xff272727),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: TabBar(
              controller: controller.tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.start,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.5, color: Color(0xffFD713F)),
              ),
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
              labelColor: const Color(0xffFD713F),
              unselectedLabelColor: const Color(0xff777777),
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: getLetterSpacing(14, FontWeight.w500),
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: getLetterSpacing(14, FontWeight.w400),
              ),
              tabs:
                  sections
                      .map(
                        (s) => Tab(
                          child: Text(
                            s,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_MenuTabBarDelegate oldDelegate) =>
      oldDelegate.sections != sections;
}
