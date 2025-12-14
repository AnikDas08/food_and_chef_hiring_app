import 'package:flutter/material.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/food_item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 300),
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorColor: Color(0xffFD713F),
            indicatorWeight: 2,
            unselectedLabelColor: Color(0xff777777),
            padding: EdgeInsets.symmetric(horizontal: 0),
            labelPadding: EdgeInsets.symmetric(horizontal: 0),
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xffFD713F),
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff777777),
            ),

            tabs: [
              Tab(text: 'Starters'),
              Tab(text: 'Main Courses'),
              Tab(text: 'Desserts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return foodItem(context);
                },
              ),
            ),
            Center(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return foodItem(context);
                },
              ),
            ),
            Center(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return foodItem(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
