import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/chef_details/presentation/widgets/food_item.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/chef_detail_controller.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChefDetailsController>(
      builder: (controller) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Obx(
              () => SafeArea(
                top: controller.innerBoxIsScrolled.value,
                child: Column(
                  children: [
                    Header(),
                    Expanded(
                      child: TabBarView(
                        children: [_MenuList(), _MenuList(), _MenuList()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: AppString.menu,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
          8.height,
          const TabBar(
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Color(0xff777777),
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xffFD713F),
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff636363),
            ),
            tabs: [
              Tab(text: 'Starters'),
              Tab(text: 'Main Courses'),
              Tab(text: 'Desserts'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 10,
      itemBuilder: (_, __) => const FoodItem(),
    );
  }
}
