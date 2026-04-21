import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/customer/groceries/presentations/screens/groceries_screen.dart';

import '../../../../common/message/presentation/screen/chat_screen.dart';
import '../../../booking/presentation/screen/booking_history_screen.dart';
import '../../../profile/presentation/screen/profile_screen.dart';
import 'home_screen.dart';

// Assuming these are your local imports
// import 'package:new_untitled/component/image/common_image.dart';
// import 'package:new_untitled/component/text/common_text.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectedTabIndex = 0;

  final List<TabData> tabs = [
    TabData(title: 'Home', icon: 'house', selectedIcon: 'house.fill'),
    TabData(
      title: 'Bookings',
      icon: 'calendar.badge.clock',
      selectedIcon: 'calendar.badge.clock',
    ),
    TabData(title: 'Groceries', icon: 'basket', selectedIcon: 'basket.fill'),
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
    const CustomerHome(),
    const BookingHistoryScreen(),
    const GroceryScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Get initial index from arguments safely
    selectedTabIndex = Get.arguments?['index'] ?? 0;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: selectedTabIndex,
    );
    tabController.addListener(_updateTabIndex);
  }

  void _updateTabIndex() {
    // Only update if the index actually changed and isn't in the middle of an animation
    if (!tabController.indexIsChanging &&
        tabController.index != selectedTabIndex) {
      setState(() {
        selectedTabIndex = tabController.index;
      });
    }
  }

  void onTabTap(int index) {
    tabController.animateTo(index);
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void dispose() {
    tabController.removeListener(_updateTabIndex);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody is crucial so the body renders behind the floating navigation bar
      extendBody: true,
      body: TabBarView(
        controller: tabController,
        // Disable swiping if you want to force navigation through buttons
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar:
          Platform.isIOS ? _buildCupertinoBar() : _buildAndroidBar(),
    );
  }

  // IOS NATIVE STYLE
  Widget _buildCupertinoBar() {
    return CNTabBar(
      items:
          tabs
              .map(
                (tab) => CNTabBarItem(
                  label: tab.title,
                  icon: CNSymbol(
                    tabs[selectedTabIndex] == tab ? tab.selectedIcon : tab.icon,
                    color: const Color(0xff272727),
                    size: 18.sp, // Responsive size
                  ),
                ),
              )
              .toList(),
      tint: const Color(0xff272727),
      backgroundColor: Colors.white.withOpacity(0.9),
      //height: 90.h, // Scaled height
      currentIndex: selectedTabIndex,
      onTap: onTabTap,
    );
  }

  // CUSTOM RESPONSIVE ANDROID BAR
  Widget _buildAndroidBar() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 12.h),
        height: 68.h, // same as Chef Home
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35.r), // Scaled corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            final bool isSelected = selectedTabIndex == index;
            return Expanded(
              child: InkWell(
                onTap: () => onTabTap(index),
                borderRadius: BorderRadius.circular(35.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      text: tabs[index].title,
                      fontSize: 10.sp, // Scale text
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected
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
