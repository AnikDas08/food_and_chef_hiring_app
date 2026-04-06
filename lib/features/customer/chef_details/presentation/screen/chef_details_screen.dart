import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/availability_pop_up.dart';
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
  // Track whether the hero image has been fully scrolled away
  bool _isCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  // expandedHeight for the SliverAppBar hero image
  static const double _expandedHeight = 300;

  // The appbar collapses once scroll offset exceeds expandedHeight minus
  // the standard toolbar height (~56). We use a small buffer (–10) so the
  // transition feels snappy.
  static const double _collapseThreshold = _expandedHeight - 56 - 10;

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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      init: ChefDetailsController(),
      builder: (controller) {
        final chef = controller.chefDetail;

        // Build image URL
        final String imageUrl =
        (chef?.image != null && chef!.image!.isNotEmpty)
            ? (chef.image!.startsWith('http')
            ? chef.image!
            : ApiEndPoint.imageUrl + chef.image!)
            : AppImages.image3;

        // Total price in cart
        final double totalCartPrice =
            (controller.cartItems.length) * (chef?.priceWithFee ?? 0);

        final List<String> sections =
            controller.chefDetail?.menuSections ?? [];

        return Scaffold(
          body: DefaultTabController(
            length: sections.isEmpty ? 1 : sections.length,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // ── Hero image app bar ──────────────────────────────
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: _expandedHeight.h,
                    // Use _isCollapsed (from StatefulWidget) — NOT innerBoxIsScrolled
                    backgroundColor: Colors.white,
                    elevation: _isCollapsed ? 1 : 0,
                    titleSpacing: 0,

                    // ── Title: only visible when collapsed ─────────────
                    title: _isCollapsed
                        ? _CollapsedAppBarTitle(controller: controller)
                        : null,

                    // ── Leading ────────────────────────────────────────
                    leading: _isCollapsed
                        ? InkWell(
                      onTap: Get.back,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xff272727),
                            size: 22,
                          ),
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: Get.back,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.50),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Actions ────────────────────────────────────────
                    actions: _isCollapsed
                        ? [
                      /*// Collapsed: search icon only
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const Icon(
                          Icons.search,
                          color: Color(0xff272727),
                          size: 24,
                        ),
                      ),*/
                    ]
                        : [
                      // Expanded: favourite + share
                      InkWell(
                        onTap: controller.toggleFavourite,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.50),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              controller.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.isFavorite
                                  ? Colors.red
                                  : Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          SharePlus.instance.share(
                            ShareParams(text: 'https://example.com'),
                          );
                        },
                        child: CommonImage(imageSrc: AppIcons.share),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // ── Hero image (expandable background) ─────────────
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: _expandedHeight.h,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: controller.isLoadingDetail
                                  ? Container(color: const Color(0xffF2F2F2))
                                  : CommonImage(
                                imageSrc: imageUrl,
                                fill: BoxFit.cover,
                              ),
                            ),
                            Positioned(
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
                    child: controller.isLoadingDetail
                        ? SizedBox(
                      height: 180.h,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          // Name + price
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                text: chef?.name ?? "N/A",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff272727),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                      "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}",
                                      style: const TextStyle(
                                        color: Color(0xff272727),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " /hr",
                                      style: TextStyle(
                                        color: Color(0xff777777),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Distance | Experience
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonImage(imageSrc: AppIcons.location),
                              CommonText(
                                text: controller.chefArg?.distance ??
                                    "N/A",
                                fontSize: 12,
                                textAlign: TextAlign.start,
                                left: 4,
                                color: const Color(0xff777777),
                              ),
                              Container(
                                height: 8,
                                width: 1,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                color: const Color(0xffF1F1F1),
                              ),
                              CommonImage(imageSrc: AppIcons.briefcase),
                              CommonText(
                                text:
                                "${chef?.experience ?? 0} years Experience",
                                fontSize: 12,
                                left: 4,
                                color: const Color(0xff777777),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  "${(chef?.avgRating ?? 0).toStringAsFixed(2)} (${chef?.totalRating ?? 0} Reviews)",
                                  fontSize: 12,
                                  left: 4,
                                  color: const Color(0xff777777),
                                ),
                              ),
                              SizedBox(width: 4.w),
                            ],
                          ),

                          // About / bio
                          ExtendText(
                            text: chef?.about ?? "",
                            isExpanded: controller.isExpanded,
                            onTap: controller.onChangeExpand,
                          ),

                          const SizedBox(height: 16),

                          CommonButton(
                            titleText: AppString.checkAvailability,
                            titleColor: Colors.white,
                            onTap: () {
                              print(
                                  "chef id: 🤣🤣🤣🤣${controller.chefId}");
                              availabilityPopup(
                                  context, controller.chefId);
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
                      delegate: _MenuTabBarDelegate(sections: sections),
                    ),
                ];
              },
              body: const MenuPage(),
            ),
          ),

          // ── Cart bottom bar ─────────────────────────────────────────
          bottomNavigationBar: controller.cartItems.isEmpty
              ? null
              : SafeArea(
            top: false,
            child: InkWell(
              onTap: () => Get.toNamed(AppRoutes.cart),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
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
                        child: CommonText(
                          text: "${controller.cartItems.length}",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff272727),
                        ).center,
                      ),
                      CommonText(
                        text: AppString.viewCart,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        left: 8,
                      ),
                      const Spacer(),
                      CommonText(
                        text:
                        "\$${totalCartPrice.toStringAsFixed(2)}  •  ${chef?.estCookingTime ?? ''}",
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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

// ── Collapsed app bar title ───────────────────────────────────────────────────
// Shown only when _isCollapsed == true
// Matches the screenshot: chef name bold + price chip + star rating

class _CollapsedAppBarTitle extends StatelessWidget {
  final ChefDetailsController controller;

  const _CollapsedAppBarTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    final chef = controller.chefDetail;

    return Padding(
      padding: EdgeInsets.only(left: 4.w,right: 20),
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chef name
            Text(
              chef?.name ?? "N/A",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                // Price chip — grey pill like in screenshot
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                    'assets/icons/price.svg',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}/hr",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff555555),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Star + rating value
                const Icon(Icons.star, size: 14, color: Color(0xffFD713F)),
                const SizedBox(width: 3),
                Text(
                  (chef?.avgRating ?? 0).toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff272727),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pinned tab bar delegate ───────────────────────────────────────────────────

class _MenuTabBarDelegate extends SliverPersistentHeaderDelegate {
  final List<String> sections;

  const _MenuTabBarDelegate({required this.sections});

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // If sections <= 2: fixed tabs (fills full width, centered)
    // If sections > 2: scrollable tabs (left-aligned, scroll right)
    final bool isScrollable = sections.length > 2;

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
              isScrollable: isScrollable,
              tabAlignment: isScrollable
                  ? TabAlignment.start  // scrollable: left-aligned
                  : TabAlignment.fill,  // 1 or 2 items: fill full width

              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.5,
                  color: Color(0xffFD713F),
                ),
                insets: EdgeInsets.symmetric(horizontal: 10),
              ),

              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,

              labelPadding: const EdgeInsets.symmetric(horizontal: 16),

              labelColor: Color(0xffFD713F),
              unselectedLabelColor: Color(0xff777777),

              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),

              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),

              tabs: sections
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

// ── Reusable app-bar icon button ──────────────────────────────────────────────

class _AppBarIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.85),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: CommonImage(
          imageSrc: icon,
          height: 18.w,
          width: 18.w,
          fill: BoxFit.contain,
        ),
      ),
    );
  }
}