import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/customer/groceries/presentations/screens/groceries_screen.dart';
import '../../../../../utils/extensions/extension.dart';
import '../controller/home_controller.dart';

import '../../../../common/message/presentation/screen/chat_screen.dart';
import '../../../booking/presentation/screen/booking_history_screen.dart';
import '../../../profile/presentation/screen/profile_screen.dart';
import '../widgets/groceries_notification_popup.dart';
import 'home_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectedTabIndex = 0;
  final HomeController homeController = Get.put(HomeController());

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
    // Call isRead to get unread message count
    homeController.isRead();
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
      bottomNavigationBar: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedTabIndex == 0 && homeController.showStatusCard.value)
                _buildStatusCard(),
              Platform.isIOS ? _buildCupertinoBar() : _buildAndroidBar(),
            ],
          )),
    );
  }

  Widget _buildStatusCard() {
    return InkWell(
      onTap: () {
        Get.dialog(const GroceriesNotificationPopup());
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 0.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xff272727),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Icon with badge
            CommonImage(
              imageSrc: "assets/images/confirm_image.png",
              height: 48.h,
              width: 48.h,
            ),
            12.width,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Awaiting Confirmation by Privae...',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                  CommonText(
                    text: 'Estimated 4m - 12m',
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    top: 2.h,
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // IOS NATIVE STYLE
  // Badge is positioned by dividing screen width into 5 equal tab slots.
  // Chat tab is index 3. Icon center = tabWidth * 3 + tabWidth / 2.
  // Icon width is 18.sp, so half = 9.sp. Badge sits at iconCenter + half icon width - half badge width.
  Widget _buildCupertinoBar() {
    return Builder(
      builder: (context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double tabWidth = screenWidth / tabs.length; // 5 tabs
        // Center X of the chat tab (index 3)
        final double chatIconCenterX = tabWidth * 3 + (tabWidth / 2);
        // Place badge at top-right corner of the icon:
        // iconCenter + half of icon size (9.sp) - half of badge size (4.w)
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
                  icon: _buildIconWithBadge(tab, index),
                );
              }).toList(),
              tint: const Color(0xff272727),
              backgroundColor: Colors.white.withOpacity(0.9),
              currentIndex: selectedTabIndex,
              onTap: onTabTap,
            ),
            if (homeController.unreadCount.value > 0)
              Positioned(
                left: badgeLeft,
                top: 6.h,
                child: Container(
                  width: 8.w,
                  height: 8.w, // use .w for both to keep a perfect circle
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
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Column(
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
                    if (index == 3) // Chat tab index
                      Positioned(
                        top: -5.h,
                        right: -5.w,
                        child: Obx(() => _buildNotificationDot()),
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

  // Build icon with badge for iOS
  CNSymbol _buildIconWithBadge(TabData tab, int index) {
    return CNSymbol(
      tabs[selectedTabIndex] == tab ? tab.selectedIcon : tab.icon,
      color: const Color(0xff272727),
      size: 18.sp, // Responsive size
    );
  }

  // Build notification dot
  Widget _buildNotificationDot() {
    return homeController.unreadCount.value > 0
        ? Container(
      width: 8.w,
      height: 8.w, // .w for both to keep a perfect circle on all screens
      decoration: const BoxDecoration(
        color: Color(0xFFFD713F),
        shape: BoxShape.circle,
      ),
    )
        : const SizedBox.shrink();
  }

  // Helper method to map SF Symbol names to CupertinoIcons
  IconData _getCupertinoIcon(String sfSymbolName) {
    switch (sfSymbolName) {
      case 'house':
      case 'house.fill':
        return CupertinoIcons.house_fill;
      case 'calendar.badge.clock':
        return CupertinoIcons.calendar;
      case 'basket':
        return CupertinoIcons.bag;
      case 'basket.fill':
        return CupertinoIcons.bag_fill;
      case 'ellipsis.message':
        return CupertinoIcons.chat_bubble;
      case 'ellipsis.message.fill':
        return CupertinoIcons.chat_bubble_fill;
      case 'person.crop.circle':
        return CupertinoIcons.person_circle;
      case 'person.circle.fill':
        return CupertinoIcons.person_circle_fill;
      default:
        return CupertinoIcons.question_circle;
    }
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