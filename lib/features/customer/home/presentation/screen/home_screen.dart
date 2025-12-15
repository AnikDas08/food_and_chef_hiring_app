import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/bottom_nav_bar/common_bottom_bar.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/route/app_routes.dart';
import '../widgets/category.dart';
import '../widgets/home_appbar.dart';
import '../widgets/order_again.dart';
import '../widgets/recommended.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CommonImage(imageSrc: AppImages.image1),
            12.height,
            CommonTextField(
              hintText: AppString.searchForFoodChefEtc,
              keyboardType: TextInputType.none,
              onTap: () => Get.toNamed(AppRoutes.homeSearch),
              borderRadius: 30,
              suffixIcon: Padding(
                padding: EdgeInsets.all(10),
                child: CommonImage(
                  imageSrc: AppIcons.fliter,
                  imageColor: Color(0xff636363),
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(CupertinoIcons.search),
              ),
            ),

            20.height,
            SizedBox(height: 90.h, child: category()),

            16.height,
            CommonText(
              text: AppString.recommendedPrivaeChefsNearby,
              fontSize: 16,
              color: Color(0xff272727),
              fontWeight: FontWeight.w600,
              bottom: 16,
            ).start,

            SizedBox(height: 300, child: recommended()),
            CommonText(
              text: AppString.orderAgain,
              fontSize: 16,
              top: 28,
              color: Color(0xff272727),
              fontWeight: FontWeight.w600,
              bottom: 16,
            ).start,

            SizedBox(height: 160.h, child: orderAgain()),
            30.height,
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavBar(currentIndex: 0),
    );
  }
}
