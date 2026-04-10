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
  bool _isCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  static const double _expandedHeight = 300;
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

        final String imageUrl =
        (chef?.image != null && chef!.image!.isNotEmpty)
            ? (chef.image!.startsWith('http')
            ? chef.image!
            : ApiEndPoint.imageUrl + chef.image!)
            : AppImages.image3;

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
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: _expandedHeight.h,
                    backgroundColor: Colors.white,
                    elevation: _isCollapsed ? 1 : 0,
                    titleSpacing: 0,

                    // ── When collapsed: disable default leading so we
                    //    render back button INSIDE the title card
                    automaticallyImplyLeading: !_isCollapsed,

                    title: _isCollapsed
                        ? _CollapsedAppBarTitle(controller: controller)
                        : null,

                    // ── Leading: only shown when NOT collapsed ──────────
                    leading: _isCollapsed
                        ? null // back button lives inside the title card
                        : InkWell(
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
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
                        ? []
                        : [
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

                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: _expandedHeight.h,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: controller.isLoadingDetail
                                  ? Container(
                                  color: const Color(0xffF2F2F2))
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
                              CommonImage(
                                  imageSrc: AppIcons.briefcase),
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
// Back button + chef name + price chip + star rating — all inside ONE card

class _CollapsedAppBarTitle extends StatelessWidget {
  final ChefDetailsController controller;

  const _CollapsedAppBarTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    final chef = controller.chefDetail;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
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
                // Chef name
                CommonText(
                    text: chef?.name??"N/A",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // Price chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/price.svg',
                            height: 12,
                            width: 12,
                            colorFilter: const ColorFilter.mode(
                              Color(0xff777777),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          /*Text(
                            "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}/hr",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff555555),
                            ),
                          ),*/
                          CommonText(
                              text: "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}/hr",
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff555555),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Star + rating
                    const Icon(Icons.star,
                        size: 14, color: Color(0xffFD713F)),
                    const SizedBox(width: 3),
                    /*Text(
                      (chef?.avgRating ?? 0).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff272727),
                      ),
                    ),*/
                    CommonText(
                        text: (chef?.avgRating ?? 0).toStringAsFixed(1),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff272727),
                    ),
                  ],
                ),
              ],
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

  const _MenuTabBarDelegate({required this.sections});

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
                  ? TabAlignment.start
                  : TabAlignment.fill,
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