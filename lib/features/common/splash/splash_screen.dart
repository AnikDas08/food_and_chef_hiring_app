import 'package:flutter/material.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../config/route/app_routes.dart';
import 'package:get/get.dart';

import '../../../component/image/common_image.dart';
import '../../../services/storage/storage_services.dart';
import '../../../utils/constants/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      print("My userId👌👌👌👌👌: ${LocalStorage.userId}");
      if (LocalStorage.isLogIn&&LocalStorage.token!="") {
        if (LocalStorage.myRole == 'CUSTOMER') {
          Get.offAllNamed(AppRoutes.customerHomeScreen);
        } else {
          Get.offAllNamed(AppRoutes.chefHomeScreen);
        }
      }
      else{
        Get.offAllNamed(AppRoutes.onboarding);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          CommonImage(
            imageSrc: AppImages.splash,
            fill: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ).center,
    );
  }
}
