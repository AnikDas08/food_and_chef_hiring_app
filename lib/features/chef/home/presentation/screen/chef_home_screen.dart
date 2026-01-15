import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/chef/home/presentation/widgets/chef_home_appbar.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import '../widgets/request_item.dart';

class ChefHomeScreen extends StatelessWidget {
  const ChefHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chefHomeAppBar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ).copyWith(bottom: 0),
        child: Column(
          children: [
            CommonImage(
              imageSrc: AppImages.img7,
              fill: BoxFit.fill,
              height: 112.h,
              width: Get.width,
            ),
            32.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: AppString.requestedBookings,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                CommonText(
                  text: AppString.seeAll,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xffFD713F),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return requestItem(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
