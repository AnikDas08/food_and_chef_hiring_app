import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/features/chef/chef_public_profile/presentation/controller/chef_public_profile_controller.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../customer/chef_details/presentation/widgets/menu.dart';

String text =
    "Javier Alison, born in Barcelona, Spain, is a celebrated chef known for his innovative Mediterranean cuisine. Trained at the Culinary Institute of Barcelona, Javier refined his skills at renowned restaurants like El Celler de Can Roca. In 2005, he opened his first restaurant, La Cuchara earning a Michelin star within three years. Javier has authored bestselling cookbooks and appeared on numerous cooking shows, sharing his passion and expertise. His philanthropic efforts include the Alison Culinary Foundation, supporting aspiring chefs and sustainable farming. Javier Alison continues to inspire with his creativity and dedication to culinary excellence";

class ChefPublicProfile extends StatelessWidget {

  const ChefPublicProfile({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ChefPublicProfileController>(

      init: ChefPublicProfileController(),

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
                          child: CommonImage(imageSrc: AppIcons.back),
                        ),
                      ),

                      Positioned(

                        top: 30,

                        right: 10,

                        child: InkWell(

                          onTap: () {

                            SharePlus.instance.share(

                              ShareParams(text: 'https://example.com'),

                            );

                          },

                          child: CommonImage(imageSrc: AppIcons.share),

                        ),

                      ),

                      Positioned(
                        bottom: 40,
                        left: 20,
                        child: InkWell(

                          onTap: controller.onChange,

                          child: CommonImage(imageSrc: AppIcons.chef),


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
                    child: Column(
                      children: [

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
                              color: Color(0xffFD713F),
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

                        CommonText(
                          text: AppString.menu,
                          fontSize: 16,
                          top: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ).start,

                        Expanded(child: MenuPage()),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
