import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/features/chef/menu/presentation/widgets/menu_item.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: AppString.menu,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.addMenu);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 16),
                          CommonText(
                            text: AppString.addMenuSection,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff272727),
                            left: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              CommonText(
                text: AppString.starters,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff777777),
                bottom: 16,
                top: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return menuItem();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        SafeArea(
          child:
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    CommonText(
                      text: AppString.addMenuSection,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff272727),
                      left: 4,
                    ),
                  ],
                ),
              ).start,
        ),
      ],
    );
  }
}
