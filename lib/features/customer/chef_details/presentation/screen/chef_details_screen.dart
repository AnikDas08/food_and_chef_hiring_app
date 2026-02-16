import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
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

String text =
    "Javier Alison, born in Barcelona, Spain, is a celebrated chef known for his innovative Mediterranean cuisine. Trained at the Culinary Institute of Barcelona, Javier refined his skills at renowned restaurants like El Celler de Can Roca. In 2005, he opened his first restaurant, La Cuchara earning a Michelin star within three years. Javier has authored bestselling cookbooks and appeared on numerous cooking shows, sharing his passion and expertise. His philanthropic efforts include the Alison Culinary Foundation, supporting aspiring chefs and sustainable farming. Javier Alison continues to inspire with his creativity and dedication to culinary excellence";

class ChefDetailsScreen extends StatelessWidget {
  const ChefDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      init: ChefDetailsController(),
      builder: (controller) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            controller.onChangeInnerBoxIsScrolled(innerBoxIsScrolled);
            return [
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
                    height: 300.h, // Add explicit height
                    child: Stack(
                      children: [
                        Positioned.fill( // Use Positioned.fill
                          child: CommonImage(
                            imageSrc: AppImages.image3,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Javier A.",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff272727),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "\$70.00",
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
                      Row(
                        children: [
                          CommonImage(imageSrc: AppIcons.location),
                          CommonText(
                            text: "2km",
                            fontSize: 12,
                            left: 4,
                            color: Color(0xff777777),
                          ),
                          Container(
                            height: 8,
                            width: 1,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            color: Color(0xffF1F1F1),
                          ),
                          CommonImage(imageSrc: AppIcons.briefcase),
                          CommonText(
                            text: "4 years Experience",
                            fontSize: 12,
                            left: 4,
                            color: Color(0xff777777),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star,
                            color: Color(0xffFD713F),
                            size: 20,
                          ),
                          CommonText(
                            text: "4.5 (482 Reviews)",
                            fontSize: 12,
                            left: 4,
                            color: Color(0xff777777),
                          ),
                        ],
                      ),
                      ExtendText(
                        text: text,
                        isExpanded: controller.isExpanded,
                        onTap: controller.onChangeExpand,
                      ),
                      const SizedBox(height: 16),
                      CommonButton(
                        titleText: AppString.checkAvailability,
                        titleColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: MenuPage(),
        ),
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
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CommonText(
                        text: "1",
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
                    Spacer(),
                    CommonText(
                      text: "\$70,00 30 min",
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
      ),
    );
  }
}
