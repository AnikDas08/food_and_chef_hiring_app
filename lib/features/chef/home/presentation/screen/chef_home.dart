import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// Note: Ensure cupertino_native is still in your pubspec if using CNTabBar
// import 'package:cupertino_native/cupertino_native.dart';

import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

// Import your screens...
import '../../../analytics/presentation/screen/analytics_screen.dart';
import '../../../chef_booking/presentation/screen/chef_booking_screen.dart';
import '../../../profile/presentation/screen/chef_profile_screen.dart';
import '../../../../common/message/presentation/screen/chat_screen.dart';
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

  TabData({required this.title, required this.icon, required this.selectedIcon});
}

class _ChefHomeState extends State<ChefHome> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectedTabIndex = 0;

  final List<TabData> tabs = [
    TabData(title: "Home", icon: "house", selectedIcon: "house.fill"),
    TabData(title: "Analytics", icon: "chart.xyaxis.line", selectedIcon: "chart.xyaxis.line"),
    TabData(title: "Booking", icon: "basket", selectedIcon: "basket.fill"),
    TabData(title: "Chats", icon: "ellipsis.message", selectedIcon: "ellipsis.message.fill"),
    TabData(title: "Profile", icon: "person.crop.circle", selectedIcon: "person.circle.fill"),
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
    selectedTabIndex = Get.arguments?["index"] ?? 0;
    tabController = TabController(
      length: pages.length,
      vsync: this,
      initialIndex: selectedTabIndex,
    );
    tabController.addListener(_updateTabIndex);
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
      extendBody: true, // Allows content to flow behind the floating bar
      body: TabBarView(
        controller: tabController,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    // We wrap in SafeArea to handle the "Home Indicator" on modern phones
    return SafeArea(
      bottom: true,
      child: Container(
        height: 68.h, // Scaled height for the bar
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
          borderRadius: BorderRadius.circular(40.r), // Responsive corner radius
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_list.length, (index) {
            bool isSelected = index == selectedTabIndex;

            // Using Expanded ensures each tab gets exactly 20% of the bar width
            return Expanded(
              child: InkWell(
                onTap: () => onTabTap(index),
                borderRadius: BorderRadius.circular(40.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImage(
                      imageSrc: _list[index],
                      size: 22.r, // Scaled icon
                      imageColor: isSelected ? Colors.black : const Color(0xff777777),
                    ),
                    SizedBox(height: 4.h),
                    CommonText(
                      text: _string[index],
                      fontSize: 10.sp, // Scaled text
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xff272727) : const Color(0xff777777),
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

// Data lists moved outside for cleanliness
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