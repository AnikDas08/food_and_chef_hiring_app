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
import '../../../chef_booking_control/Cooking_OrderItem_page/Cooking_OrderItem.dart';
import '../../../chef_booking_control/widgets/BookingDetailsSheet.dart';
import '../../../profile/presentation/screen/chef_profile_screen.dart';
import '../../../../common/message/presentation/screen/chat_screen.dart';
import '../controller/chef_home_controller.dart';
import '../widgets/menu_Working_Banner.dart';
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
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showExitDialog();
        return exit;
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            TabBarView(
              controller: tabController,
              children: pages,
            ),

            if (selectedTabIndex == 0)
              Positioned(
                bottom: 100.h,
                left: 16.w,
                right: 16.w,
                child: InkWell(
                  onTap: () async {
                    final homeC = Get.find<ChefHomeController>();

                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      final order =
                      await homeC.fetchSingleOrder("69a66ebdf0507595e4636281");

                      Get.back();

                      if (order != null) {
                        final user = order['user'] ?? {};
                        final staticItems = order['static_items'] as List? ?? [];
                        final breakdown = order['price_breakdown'] ?? {};

                        BookingDetailsSheet.show(
                          context,
                          booking: BookingDetailsModel(
                            chefName: user['name'] ?? '',
                            bookingId: order['order_id'] ?? '',
                            chefImage: user['image'] ?? '',
                            status: order['status'] ?? '',
                            customerName: user['name'] ?? '',
                            address: order['formatted_address'] ?? '',
                            date: order['formatted_date'] ?? '',
                            time: order['strTime'] ?? '',
                            orderItems: staticItems.map((item) {
                              return OrderItem(
                                name: item['menu']?['name'] ?? '',
                                description:
                                '${item['quantity']} Items + ${(item['customizations'] as List?)?.join(', ') ?? ''}',
                              );
                            }).toList(),
                            estimatedTime: order['duration'] ?? '',
                            hourlyRate: (breakdown['subtotal'] ?? 0).toDouble(),
                            estimatedTaxes: (breakdown['taxs'] ?? 0).toDouble(),
                            onStartCooking: () {
                              Get.back();
                              Get.to(
                                    () => CookingStopwatchScreen(
                                  orderId: order['_id']?.toString() ?? "",
                                  orderItems: staticItems.map((item) {
                                    return CookingOrderItem(
                                      name:
                                      '${item['menu']?['name']} (x${item['quantity']})',
                                        description:
                                       (item['customizations'] as List?)
                                          ?.join(', ') ??
                                          '',
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    } catch (e) {
                      Get.back();
                      Get.snackbar("Message", "Something went wrong");
                    }
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  //child: menuWorkingBanner(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }



  Widget _buildBottomBar() {

    return SafeArea(
      bottom: true,
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
            bool isSelected = index == selectedTabIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTabTap(index),
                borderRadius: BorderRadius.circular(40.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImage(
                      imageSrc: _list[index],
                      size: 22.r,
                      imageColor: isSelected ? Colors.black : const Color(0xff777777),
                    ),
                    SizedBox(height: 4.h),
                    CommonText(
                      text: _string[index],
                      fontSize: 10.sp,
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