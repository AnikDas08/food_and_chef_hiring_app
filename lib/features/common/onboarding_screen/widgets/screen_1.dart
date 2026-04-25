import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../component/image/common_image.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_string.dart';
import 'indicatior.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    28.height,
                    const CommonImage(imageSrc: AppImages.logo),
                    28.height,
                    CommonImage(
                      imageSrc: AppImages.onboarding_1,
                      fill: BoxFit.fill,
                      height: 320.h,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: const BoxDecoration(color: Colors.white),
              child: const Column(
                children: [
                  CommonText(
                    text: AppString.welcomeToPrivae,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 28,
                  ),
                  CommonText(
                    text: AppString.effortlesslyHirePersonal,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    top: 12,
                    bottom: 20,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem extends StatefulWidget {
  const OnboardingItem({super.key});

  @override
  State<OnboardingItem> createState() => _OnboardingItemState();
}

class _OnboardingItemState extends State<OnboardingItem> {
  final List _list = [
    {
      'image': AppImages.onboarding_1,
      'title': AppString.welcomeToPrivae,
      'subtitle': AppString.effortlesslyHirePersonal,
    },

    {
      'image': AppImages.onboarding_2,
      'title': AppString.findYourPrivaeChef,
      'subtitle': AppString.browseThroughTalentedChefs,
    },

    {
      'image': AppImages.onboarding_3,
      'title': AppString.bookAnytimeAnywhere,
      'subtitle': AppString.scheduleYourChefAtYourConvenience,
    },
  ];

  int currentPage = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (currentPage < _list.length - 1) {
        currentPage++;
        setState(() {});
      } else {
        t.cancel();
      }
    });
  }

  Map get item => _list[currentPage];

  void update(details) {
    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! > 0) {
      if (currentPage == 0) return;
      currentPage--;
    } else if (details.primaryVelocity! < 0) {
      if (currentPage == 2) return;
      currentPage++;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: update,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      28.height,
                      const CommonImage(
                        imageSrc: AppImages.logo,
                        height: 38,
                        width: 104,
                        fill: BoxFit.cover,
                      ),
                      28.height,
                      CommonImage(
                        imageSrc: item['image'],
                        fill: BoxFit.fill,
                        height: 330.h,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    CommonText(
                      text: item['title'],
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                      top: 28,
                    ),
                    CommonText(
                      text: item['subtitle'],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff777777),
                      top: 12,
                      bottom: 20,
                      maxLines: 3,
                    ),
                    indicator(currentIndex: currentPage).center,
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
