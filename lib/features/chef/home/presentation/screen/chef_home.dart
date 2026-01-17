import 'dart:io';

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/chef/analytics/presentation/screen/analytics_screen.dart';
import 'package:new_untitled/features/chef/home/presentation/screen/chef_home_screen.dart';
import 'package:new_untitled/features/common/message/presentation/screen/chat_screen.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../../../chef_booking/presentation/screen/chef_booking_screen.dart';
import '../../../profile/presentation/screen/chef_profile_screen.dart';

class ChefHome extends StatefulWidget {
  const ChefHome({super.key});

  @override
  State<ChefHome> createState() => _ChefHomeState();
}

class TabData {
  final String title;
  final String icon;

  TabData({required this.title, required this.icon});
}

class _ChefHomeState extends State<ChefHome>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectedTabIndex = 0;
  final List<TabData> tabs = [
    TabData(title: "Home", icon: "house"),
    TabData(title: "Analytics", icon: "chart.xyaxis.line"),
    TabData(title: "Booking", icon: "basket"),
    TabData(title: "Chats", icon: "bubble.left.and.bubble.right"),
    TabData(title: "Profile", icon: "person.crop.circle"),
  ];

  final List<Widget> pages = [
    ChefHomeScreen(),
    AnalyticsScreen(),
    ChefBookingScreen(),
    ChatListScreen(),
    ChefProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    selectedTabIndex = Get.arguments?["index"] ?? 0;
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(updteTabIndex);
  }

  void updteTabIndex() {
    if (tabController.index != selectedTabIndex) {
      setState(() {
        selectedTabIndex = tabController.index;
      });
    }
  }

  void onTabTap(int index) {
    setState(() {
      selectedTabIndex = index;
    });
    tabController.animateTo(index);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: TabBarView(controller: tabController, children: pages),
      bottomNavigationBar:
          (Platform.isIOS)
              ? CNTabBar(
                items:
                    tabs
                        .map(
                          (TabData tab) => CNTabBarItem(
                            label: tab.title,
                            icon: CNSymbol(tab.icon),
                          ),
                        )
                        .toList(),
                tint: CupertinoColors.black,
                height: 85,
                currentIndex: selectedTabIndex,
                onTap: onTabTap,
              )
              : _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 4,
              offset: Offset(1, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_list.length, (index) {
            return InkWell(
              onTap: () => onTabTap(index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonImage(
                      imageSrc: _list[index],
                      size: 24,
                      imageColor:
                          index == selectedTabIndex
                              ? Colors.black
                              : const Color(0xff777777),
                    ),
                    CommonText(
                      text: _string[index],
                      fontSize: 12,
                      top: 4,
                      fontWeight: FontWeight.w400,
                      color:
                          index == selectedTabIndex
                              ? const Color(0xff272727)
                              : const Color(0xff777777),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

final List<String> _list = [
  AppIcons.home,
  AppIcons.analytics,
  AppIcons.basket,
  AppIcons.chats,
  AppIcons.profile,
];

final List<String> _string = [
  AppString.home,
  AppString.analytics,
  AppString.bookings,
  AppString.chats,
  AppString.profile,
];
