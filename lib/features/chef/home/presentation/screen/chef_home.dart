import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../../../../../services/api/api_service.dart';
import '../../../analytics/presentation/screen/analytics_screen.dart';
import '../../../chef_booking/presentation/screen/chef_booking_screen.dart';
import '../../../profile/presentation/screen/chef_profile_screen.dart';
import '../../../../common/message/presentation/screen/chat_screen.dart';
import '../controller/chef_home_controller.dart';
import '../widgets/show_ExitDialog.dart';
import 'chef_home_screen.dart';

class ChefHome extends StatefulWidget {
  const ChefHome({super.key});

  @override
  State<ChefHome> createState() => _ChefHomeState();
}

class TabData {
  final String title;
  final String icon;
  final String selectedIcon;

  TabData({
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });
}

class _ChefHomeState extends State<ChefHome>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectedTabIndex = 0;
  final ChefHomeController _homeController = Get.put(ChefHomeController());

  final List<TabData> tabs = [
    TabData(title: 'Home', icon: 'house', selectedIcon: 'house.fill'),
    TabData(
      title: 'Analytics',
      icon: 'chart.xyaxis.line',
      selectedIcon: 'chart.xyaxis.line',
    ),
    TabData(title: 'Booking', icon: 'basket', selectedIcon: 'basket.fill'),
    TabData(
      title: 'Chats',
      icon: 'ellipsis.message',
      selectedIcon: 'ellipsis.message.fill',
    ),
    TabData(
      title: 'Profile',
      icon: 'person.crop.circle',
      selectedIcon: 'person.circle.fill',
    ),
  ];

  final List<Widget> pages = [
    const ChefHomeScreen(),
    const AnalyticsScreen(),
    const ChefBookingScreen(),
    const ChatListScreen(),
    const ChefProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedTabIndex = Get.arguments?['index'] ?? 0;
    tabController = TabController(
      length: pages.length,
      vsync: this,
      initialIndex: selectedTabIndex,
    );
    tabController.addListener(_updateTabIndex);
    _homeController.isRead();
  }

  void _updateTabIndex() {
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
    _homeController.isRead();
  }

  @override
  void dispose() {
    tabController.removeListener(_updateTabIndex);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool exit = await showExitDialog();
        return exit;
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [TabBarView(controller: tabController, children: pages)],
        ),
        bottomNavigationBar:
        Platform.isIOS ? _buildCupertinoBar() : _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        height: 68.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_list.length, (index) {
            final bool isSelected = index == selectedTabIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTabTap(index),
                borderRadius: BorderRadius.circular(40.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 3
                        ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CommonImage(
                          imageSrc: _list[index],
                          size: 22.r,
                          imageColor: isSelected
                              ? Colors.black
                              : const Color(0xff777777),
                        ),
                        Obx(() {
                          if (_homeController.unreadCount.value == 0) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: Color(0xffFD713F),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                      ],
                    )
                        : CommonImage(
                      imageSrc: _list[index],
                      size: 22.r,
                      imageColor: isSelected
                          ? Colors.black
                          : const Color(0xff777777),
                    ),
                    SizedBox(height: 4.h),
                    CommonText(
                      text: _string[index],
                      fontSize: 10.sp,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
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

  Widget _buildCupertinoBar() {
    return Builder(
      builder: (context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double tabWidth = screenWidth / tabs.length;
        final double chatIconCenterX = tabWidth * 3 + (tabWidth / 2);
        final double badgeLeft = chatIconCenterX + 9.sp - 4.w;

        return Obx(() => Stack(
          clipBehavior: Clip.none,
          children: [
            CNTabBar(
              items: tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                return CNTabBarItem(
                  label: tab.title,
                  icon: CNSymbol(
                    selectedTabIndex == index ? tab.selectedIcon : tab.icon,
                    color: const Color(0xff272727),
                    size: 18.sp,
                  ),
                );
              }).toList(),
              tint: const Color(0xff272727),
              backgroundColor: Colors.white.withOpacity(0.9),
              currentIndex: selectedTabIndex,
              onTap: onTabTap,
            ),
            if (_homeController.unreadCount.value > 0)
              Positioned(
                left: badgeLeft,
                top: 6.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFD713F),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ));
      },
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