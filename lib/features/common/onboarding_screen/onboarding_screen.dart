import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../component/button/common_button.dart';
import '../../../config/route/app_routes.dart';
import '../../../utils/constants/app_string.dart';
import 'widgets/screen_1.dart';
import 'widgets/screen_2.dart';
import 'widgets/screen_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List _list = [Screen1(), Screen2(), Screen3()];
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (currentPage < _list.length - 1) {
        currentPage++;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  currentPage = index;
                },
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return _list[index];
                },
              ),
            ),
            28.height,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  CommonButton(
                    titleText: AppString.signIn,
                    onTap: () => Get.toNamed(AppRoutes.signIn),
                  ),
                  12.height,

                  CommonButton(
                    titleText: "I’m New, Sign Me Up",
                    buttonColor: Color(0xffF2F2F2),
                    borderColor: Colors.transparent,
                    titleColor: Colors.black,
                    titleSize: 16,
                    titleWeight: FontWeight.w600,
                    onTap: () => Get.toNamed(AppRoutes.signUp),
                  ),
                  20.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
