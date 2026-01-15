import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/extensions/extension.dart';
import '../controller/chef_detail_controller.dart';
import '../widgets/availability_pop_up.dart';
import '../widgets/exten_text.dart';
import '../widgets/menu.dart';

String text =
    "Javier Alison, born in Barcelona, Spain, is a celebrated chef known for his innovative Mediterranean cuisine.";

class ChefDetailsScreen extends StatelessWidget {
const ChefDetailsScreen({super.key});

  final double collapsedHeight = kToolbarHeight + 85;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              GetBuilder<ChefDetailsController>(
                builder: (controller) {
                  final double expandedHeight = 480.h;

                  return SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    expandedHeight: expandedHeight,
                    collapsedHeight: 90.h,
                    toolbarHeight: 60.h,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final currentHeight = constraints.biggest.height;

                        final collapseRange = expandedHeight - collapsedHeight;

                        final collapsedAmount = (expandedHeight - currentHeight)
                            .clamp(0.0, collapseRange);

                        final collapsePercent =
                            collapseRange == 0
                                ? 1.0
                                : collapsedAmount / collapseRange;

                        final titleOpacity = ((collapsePercent - 0.7) / 0.0)
                            .clamp(0.0, 1.0);

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              background: Column(
                                children: [
                                  Stack(
                                    children: [
                                      CommonImage(
                                        imageSrc: AppImages.image3,
                                        fill: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: SafeArea(
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: Get.back,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 16.w,
                                                  ),
                                                  child: CommonImage(
                                                    imageSrc: AppIcons.back,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: controller.onChange,
                                                child: CommonImage(
                                                  imageSrc: AppIcons.favorite,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              InkWell(
                                                onTap: () {
                                                  SharePlus.instance.share(
                                                    ShareParams(
                                                      text:
                                                          'https://example.com',
                                                    ),
                                                  );
                                                },
                                                child: CommonImage(
                                                  imageSrc: AppIcons.share,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CommonText(
                                              text: "Javier A.",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "\$70.00",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " /hr",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ExtendText(
                                          text: text,
                                          isExpanded: controller.isExpanded,
                                          onTap: controller.onChangeExpand,
                                        ),
                                        const SizedBox(height: 16),
                                        CommonButton(
                                          titleText:
                                              AppString.checkAvailability,
                                          titleColor: Colors.white,
                                          onTap:
                                              () => availabilityPopup(context),
                                        ),
                                        16.height,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top: MediaQuery.of(context).padding.top + 6,
                              left: 16.h,
                              right: 16.h,
                              child: IgnorePointer(
                                ignoring: titleOpacity == 0,
                                child: Opacity(
                                  opacity: titleOpacity,
                                  child: Container(
                                    height: 60.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF2F2F2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: Get.back,
                                          child: Container(
                                            width: 40.sp,
                                            height: 40.sp,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Icon(
                                              CupertinoIcons.back,
                                            ),
                                          ),
                                        ),
                                        12.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              12.height,
                                              CommonText(
                                                text: "Javier A.",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Row(
                                                children: [
                                                  CommonText(
                                                    text: "\$40.00 /hr",
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons.star_rate_rounded,
                                                    size: 18,
                                                    color: Colors.orange,
                                                  ),
                                                  CommonText(
                                                    text: "4.9",
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(CupertinoIcons.search),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60),
                      child: Column(
                        children: [
                          CommonText(text: "Menu", left: 16).start,
                          const TabBar(
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Color(0xff777777),
                            labelPadding: EdgeInsets.zero,
                            overlayColor: WidgetStateColor.transparent,

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
                            tabs: [
                              Tab(text: 'Starters'),
                              Tab(text: 'Main Courses'),
                              Tab(text: 'Desserts'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ];
          },

          body: TabBarView(children: [MenuList(), MenuList(), MenuList()]),
        ),

        bottomNavigationBar: GetBuilder<ChefDetailsController>(
          builder: (controller) {
            if (controller.cartItems.isEmpty) return const SizedBox();

            return SafeArea(
              top: false,
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.cart),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Text("1"),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "View Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                        const Text(
                          "\$70.00 30 min",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:new_untitled/component/button/common_button.dart';
// import 'package:new_untitled/component/image/common_image.dart';
// import 'package:new_untitled/utils/constants/app_images.dart';
// import 'package:new_untitled/utils/constants/app_string.dart';
// import 'package:new_untitled/utils/extensions/extension.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../../../../component/text/common_text.dart';
// import '../../../../../config/route/app_routes.dart';
// import '../../../../../utils/constants/app_colors.dart';
// import '../../../../../utils/constants/app_icons.dart';
// import '../../../../../utils/log/app_log.dart';
// import '../controller/chef_detail_controller.dart';
// import '../widgets/availability_pop_up.dart';
// import '../widgets/exten_text.dart';
// import '../widgets/menu.dart';
//
// String text =
//     "Javier Alison, born in Barcelona, Spain, is a celebrated chef known for his innovative Mediterranean cuisine. Trained at the Culinary Institute of Barcelona, Javier refined his skills at renowned restaurants like El Celler de Can Roca. In 2005, he opened his first restaurant, La Cuchara earning a Michelin star within three years. Javier has authored bestselling cookbooks and appeared on numerous cooking shows, sharing his passion and expertise. His philanthropic efforts include the Alison Culinary Foundation, supporting aspiring chefs and sustainable farming. Javier Alison continues to inspire with his creativity and dedication to culinary excellence";
//
// class ChefDetailsScreen extends StatelessWidget {
//   ChefDetailsScreen({super.key});
//
//   final _scrollController = ScrollController();
//
//   aa() {
//     _scrollController.addListener(() {
//       appLog(_scrollController.position, source: "${Get.height}");
//     });
//   }
//   final double collapsedHeight = kToolbarHeight + 85;
//   @override
//   Widget build(BuildContext context) {
//     // aa();
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         body: NestedScrollView(
//           controller: _scrollController,
//           headerSliverBuilder: (context, innerBoxIsScrolled) {
//             appLog(innerBoxIsScrolled, source: "ChefDetailsScreen");
//             ChefDetailsController.instance.onChangeInnerBoxIsScrolled(
//               innerBoxIsScrolled
//             );
//             return [
//               GetBuilder<ChefDetailsController>(
//                 builder:
//                     (controller) => SliverAppBar(
//                       pinned: true,
//                       expandedHeight: controller.isExpanded ? 600.h : 450.h,
//                       backgroundColor: Colors.white,
//                       automaticallyImplyLeading: false,
//                       titleSpacing: 0,
//                       toolbarHeight: 80,
//                       collapsedHeight: 85,
//                       // title: AnimatedOpacity(
//                       //   duration: Duration(milliseconds: 300),
//                       //   opacity: !controller.innerBoxIsScrolled.value ? 0 : 1,
//                       //   child: AnimatedContainer(
//                       //     duration: Duration(milliseconds: 300),
//                       //     decoration: BoxDecoration(
//                       //       color: Color(0xffF2F2F2),
//                       //       borderRadius: BorderRadius.circular(16),
//                       //     ),
//                       //     margin: const EdgeInsets.symmetric(
//                       //       horizontal: 16,
//                       //     ).copyWith(bottom: 16),
//                       //     padding: EdgeInsets.all(12),
//                       //     child: Row(
//                       //       children: [
//                       //         InkWell(
//                       //           onTap: () => Get.back(),
//                       //           child: Container(
//                       //             width: 40,
//                       //             height: 40,
//                       //             decoration: BoxDecoration(
//                       //               color: Colors.white,
//                       //               borderRadius: BorderRadius.circular(50),
//                       //             ),
//                       //             padding: const EdgeInsets.all(8),
//                       //             child: Icon(CupertinoIcons.back),
//                       //           ),
//                       //         ),
//                       //         12.width,
//                       //         Expanded(
//                       //           child: Column(
//                       //             crossAxisAlignment: CrossAxisAlignment.start,
//                       //             children: [
//                       //               CommonText(
//                       //                 text: "Javier A.",
//                       //                 fontSize: 12,
//                       //                 fontWeight: FontWeight.w600,
//                       //                 color: Color(0xff272727),
//                       //               ),
//                       //               Row(
//                       //                 children: [
//                       //                   CommonText(
//                       //                     text: "\$40.00 /hr",
//                       //                     fontSize: 12,
//                       //                     left: 4,
//                       //                     right: 4,
//                       //                     fontWeight: FontWeight.w400,
//                       //                     color: Color(0xff777777),
//                       //                   ),
//                       //                   Icon(
//                       //                     Icons.star_rate_rounded,
//                       //                     size: 20,
//                       //                     color: Color(0xffFD713F),
//                       //                   ),
//                       //                   CommonText(
//                       //                     text: "4.9",
//                       //                     fontSize: 12,
//                       //                     fontWeight: FontWeight.w400,
//                       //                     color: Color(0xff777777),
//                       //                   ),
//                       //                 ],
//                       //               ),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         Icon(CupertinoIcons.search),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                       flexibleSpace:  LayoutBuilder(
//                           builder: (context, constraints) {
//                             final maxHeight = controller.isExpanded ? 600.h : 450.h;
//                             final minHeight = collapsedHeight;
//                             final currentHeight = constraints.biggest.height;
//
//                             final collapseRange = maxHeight - minHeight;
//                             final collapsedAmount =
//                             (maxHeight - currentHeight).clamp(0.0, collapseRange);
//
//                             final collapsePercent = collapseRange == 0
//                                 ? 1.0
//                                 : (collapsedAmount / collapseRange);
//
//                             final titleOpacity =
//                             ((collapsePercent - 0.7) / 0.3).clamp(0.0, 1.0);
//                           return FlexibleSpaceBar(
//                             collapseMode: CollapseMode.pin,
//
//                             background: Column(
//                               children: [
//                                 Stack(
//                                   children: [
//                                     CommonImage(
//                                       imageSrc: AppImages.image3,
//                                       fill: BoxFit.cover,
//                                     ),
//                                     Positioned(
//                                       top: 0,
//                                       left: 0,
//                                       right: 0,
//                                       child: SafeArea(
//                                         child: Row(
//                                           children: [
//                                             InkWell(
//                                               onTap: Get.back,
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(left: 16.w),
//                                                 child: CommonImage(
//                                                   imageSrc: AppIcons.back,
//                                                 ),
//                                               ),
//                                             ),
//                                             Spacer(),
//                                             InkWell(
//                                               onTap: controller.onChange,
//                                               child: CommonImage(
//                                                 imageSrc: AppIcons.favorite,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 12),
//                                             InkWell(
//                                               onTap: () {
//                                                 SharePlus.instance.share(
//                                                   ShareParams(
//                                                     text: 'https://example.com',
//                                                   ),
//                                                 );
//                                               },
//                                               child: CommonImage(
//                                                 imageSrc: AppIcons.share,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 12),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 20,
//                                       left: 20,
//                                       child: CommonImage(
//                                         imageSrc: AppIcons.chef,
//                                         height: 30,
//                                         width: 115,
//                                         fill: BoxFit.fill,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                                   child: Column(
//                                     children: [
//                                       const SizedBox(height: 12),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           CommonText(
//                                             text: "Javier A.",
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: Color(0xff272727),
//                                           ),
//                                           Text.rich(
//                                             TextSpan(
//                                               children: [
//                                                 TextSpan(
//                                                   text: "\$70.00",
//                                                   style: TextStyle(
//                                                     color: Color(0xff272727),
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 TextSpan(
//                                                   text: " /hr",
//                                                   style: TextStyle(
//                                                     color: Color(0xff777777),
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Row(
//                                         children: [
//                                           CommonImage(imageSrc: AppIcons.location),
//                                           CommonText(
//                                             text: "2km",
//                                             fontSize: 12,
//                                             left: 4,
//                                             color: Color(0xff777777),
//                                           ),
//                                           Container(
//                                             height: 8,
//                                             width: 1,
//                                             margin: const EdgeInsets.symmetric(
//                                               horizontal: 8,
//                                             ),
//                                             color: Color(0xffF1F1F1),
//                                           ),
//                                           CommonImage(imageSrc: AppIcons.briefcase),
//                                           CommonText(
//                                             text: "4 years Experience",
//                                             fontSize: 12,
//                                             left: 4,
//                                             color: Color(0xff777777),
//                                           ),
//                                           const Spacer(),
//                                           Icon(
//                                             Icons.star,
//                                             color: Color(0xffFD713F),
//                                             size: 20,
//                                           ),
//                                           CommonText(
//                                             text: "4.5 (482 Reviews)",
//                                             fontSize: 12,
//                                             left: 4,
//                                             color: Color(0xff777777),
//                                           ),
//                                         ],
//                                       ),
//                                       ExtendText(
//                                         text: text,
//                                         isExpanded: controller.isExpanded,
//                                         onTap: controller.onChangeExpand,
//                                       ),
//                                       const SizedBox(height: 16),
//                                       CommonButton(
//                                         titleText: AppString.checkAvailability,
//                                         titleColor: Colors.white,
//                                         onTap: () => availabilityPopup(context),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                       ),
//                       bottom:  TabBar(
//                         indicatorColor: Colors.transparent,
//                         unselectedLabelColor: Color(0xff777777),
//                         labelPadding: EdgeInsets.zero,
//                         labelStyle: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xffFD713F),
//                         ),
//                         unselectedLabelStyle: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xff636363),
//                         ),
//                         tabs: [
//                           Tab(text: 'Starters'),
//                           Tab(text: 'Main Courses'),
//                           Tab(text: 'Desserts'),
//                         ],
//                       ),
//                     ),
//               ),
//             ];
//           },
//           body: TabBarView(
//             children: [MenuList(), MenuList(), MenuList()],
//           ),
//         ),
//
//         bottomNavigationBar: GetBuilder<ChefDetailsController>(
//           builder: (controller) {
//             return controller.cartItems.isEmpty
//                 ? SizedBox()
//                 : SafeArea(
//                   top: false,
//                   child: InkWell(
//                     onTap: () => Get.toNamed(AppRoutes.cart),
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 16,
//                         right: 16,
//                         bottom: 20,
//                       ),
//
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               height: 20,
//                               width: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                               ),
//                               child:
//                                   CommonText(
//                                     text: "1",
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xff272727),
//                                   ).center,
//                             ),
//                             CommonText(
//                               text: AppString.viewCart,
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               left: 8,
//                             ),
//                             Spacer(),
//                             CommonText(
//                               text: "\$70,00 30 min",
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//           },
//         ),
//       ),
//     );
//   }
// }
