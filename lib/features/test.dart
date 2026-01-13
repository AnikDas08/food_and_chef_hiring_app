import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/utils/constants/app_images.dart';

void main() {
  runApp(const CupertinoApp(debugShowCheckedModeBanner: false, home: Test()));
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class TabData {
  final String title;
  final String icon;
  TabData({required this.title, required this.icon});
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectedTabIndex = 0;
  final List<TabData> tabs = [
    TabData(title: "Home", icon: "house"),
    TabData(title: "Bookings", icon: "bag"),
    TabData(title: "Groceries", icon: "cart"),
    TabData(title: "Chats", icon: "message"),
    TabData(title: "Profile", icon: "person"),
  ];
  @override
  void initState() {
    super.initState();
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
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
              controller: tabController,
              children:
                  tabs
                      .map((TabData tab) => ImageTabPage(label: tab.title))
                      .toList(),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: CNTabBar(
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
            ),
          ),
        ],
      ),
    );
  }
}

class ImageTabPage extends StatelessWidget {
  const ImageTabPage({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.red),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 16),
              color: Colors.white,
              child: Text(
                label,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
