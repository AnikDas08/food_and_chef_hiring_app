import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/features/customer/home/presentation/controller/home_controller.dart';
import 'package:new_untitled/utils/constants/app_images.dart';

Widget category() {
  return GetBuilder<HomeController>(
    builder: (controller) {
      //add here
      if (controller.cuisineList.isEmpty) {
        return const Center(child: CupertinoActivityIndicator());
      }

      return ListView.builder(
        itemCount: controller.cuisineList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = controller.cuisineList[index];
          //print("image ${ApiEndPoint.imageUrl+item.image!}");
          return GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.homeSearch,arguments: item);
            },
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  /// Image
                  CommonImage(
                    imageSrc: item.image == null
                        ? AppImages.noImage
                        : (item.image!.startsWith('http')
                        ? item.image!
                        : ApiEndPoint.imageUrl + item.image!),
                    size: 60,
                  ),
                  /// Name
                  CommonText(
                    text: item.name ?? '',
                    fontSize: 12,
                    color: const Color(0xff222222),
                    top: 8,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

