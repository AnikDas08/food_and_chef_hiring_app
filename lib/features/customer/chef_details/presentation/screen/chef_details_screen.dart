import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class ChefDetailsScreen extends StatelessWidget {
  const ChefDetailsScreen({super.key});

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
            (controller.cartItems.length) *
                (chef?.priceWithFee ?? 0);

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              controller.onChangeInnerBoxIsScrolled(innerBoxIsScrolled);
              return [
                // ── Hero image app bar ────────────────────────────────────
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 300.h,
                  backgroundColor: Colors.white,
                  leading: InkWell(
                    onTap: Get.back,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: CommonImage(imageSrc: AppIcons.back),
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: controller.onChange,
                      child: CommonImage(imageSrc: AppIcons.favorite),
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
                      height: 300.h,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: controller.isLoadingDetail
                                ? Container(color: Color(0xffF2F2F2))
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

                // ── Chef info section ─────────────────────────────────────
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
                              color: Color(0xff272727),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                    "\$${chef?.priceWithFee?.toStringAsFixed(2) ?? '0.00'}",
                                    style: TextStyle(
                                      color: Color(0xff272727),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
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

                        // Distance | Experience | Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonImage(
                                imageSrc: AppIcons.location),
                            CommonText(
                              text: controller.chefArg?.distance ??
                                  "N/A",
                              fontSize: 12,
                              left: 4,
                              color: Color(0xff777777),
                            ),
                            Container(
                              height: 8,
                              width: 1,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              color: Color(0xffF1F1F1),
                            ),
                            CommonImage(
                                imageSrc: AppIcons.briefcase),
                            CommonText(
                              text:
                              "${chef?.experience ?? 0} years Experience",
                              fontSize: 12,
                              left: 4,
                              color: Color(0xff777777),
                            ),
                            SizedBox(width: 4.w,),
                            Flexible(
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
                                color: Color(0xff777777),
                              ),
                            ),
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
                          onTap: (){
                            print("chef id: 🤣🤣🤣🤣${controller.chefId}");
                            availabilityPopup(context,controller.chefId);
                          },
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: const MenuPage(),
          ),

          // ── Cart bottom bar ─────────────────────────────────────────────
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
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Item count badge
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CommonText(
                          text:
                          "${controller.cartItems.length}",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
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