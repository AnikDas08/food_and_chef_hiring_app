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
import '../../../../../utils/constants/app_icons.dart';
import '../controller/chef_detail_controller.dart';
import '../widgets/food_item.dart';


String text =
    "Javier Alison, born in Barcelona, Spain, is a celebrated chef known for his innovative Mediterranean cuisine. Trained at the Culinary Institute of Barcelona, Javier refined his skills at renowned restaurants like El Celler de Can Roca. In 2005, he opened his first restaurant, La Cuchara earning a Michelin star within three years. Javier has authored bestselling cookbooks and appeared on numerous cooking shows, sharing his passion and expertise. His philanthropic efforts include the Alison Culinary Foundation, supporting aspiring chefs and sustainable farming. Javier Alison continues to inspire with his creativity and dedication to culinary excellence";

class ChefDetailsScreen extends StatelessWidget {
  const ChefDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      init: ChefDetailsController(),
      builder:
          (controller) => Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      CommonImage(imageSrc: AppImages.image3),
                      Positioned(
                        top: 30,
                        left: 10,
                        child: InkWell(
                          onTap: Get.back,
                          child: Container(
                            height: 40.sp,
                            width: 40.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 10,
                        child: InkWell(
                          onTap: controller.onChange,
                          child: Container(
                            height: 40.sp,
                            width: 40.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              color: Colors.red,
                              controller.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ).copyWith(top: 20.h),
                    margin: EdgeInsets.only(top: 250.h),
                    decoration: BoxDecoration(color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff00580F),
                                      Color(0xff00AB1D),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Color(0xff00B41E)),
                                ),
                                child: Row(
                                  children: [
                                    CommonImage(
                                      imageSrc: AppIcons.chef,
                                      imageColor: Colors.white,
                                    ),
                                    CommonText(
                                      text: "Professional Chef",
                                      fontSize: 10,
                                      left: 4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  SharePlus.instance.share(
                                    ShareParams(text: 'https://example.com'),
                                  );
                                },
                                child: Container(
                                  height: 36.sp,
                                  width: 36.sp,
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xffF1F1F1),
                                    ),
                                  ),
                                  child: CommonImage(
                                    imageSrc: AppIcons.share,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                text: "Javier A.",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                              CommonText(
                                text: "\$70,00/hr",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonImage(imageSrc: AppIcons.location),
                              CommonText(
                                text: "2km",
                                fontSize: 12,
                                color: Color(0xff777777),
                                left: 4,
                                right: 4,
                              ),
                              CommonImage(imageSrc: AppIcons.briefcase),
                              CommonText(
                                text: "4 years Experience",
                                fontSize: 12,
                                left: 4,
                                color: Color(0xff777777),
                              ),

                              Spacer(),
                              Icon(
                                Icons.star,
                                color: Color(0xffE39400),
                                size: 20,
                              ),
                              CommonText(
                                text: "4.5 (482 Reviews)",
                                fontSize: 12,
                                left: 2,
                                color: Color(0xff777777),
                              ),
                            ],
                          ),
                          CommonText(
                            text: text,
                            maxLines: 2,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff272727),
                            textAlign: TextAlign.start,
                            top: 16,
                          ),
                          24.height,
                          CommonButton(
                            titleText: AppString.checkAvailability,
                            titleColor: Colors.white,
                            titleSize: 14,
                            titleWeight: FontWeight.w600,
                          ),

                          32.height,

                          foodItem(),
                          foodItem(),
                          foodItem(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
