import 'dart:async';
import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xffF8F4F1),
      body: SafeArea(
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
    );
  }
}
