import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../common/auth/signup_chef/presentation/controller/Chef_add_menu_controller.dart';
import '../../../../common/auth/signup_chef/presentation/screen/Chef_cooking_expertise_screen.dart';
import 'add_menu_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = CafeAddMenuItemController.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 36.w, height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16.sp, color: const Color(0xFF272727)),
                    ),
                  ),
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF272727),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      c.resetForm();
                      await c.fetchCategories();
                      await Get.to(() => const AddMenuScreen());
                      c.resetForm();
                      c.fetchMenus();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(children: [
                        Icon(Icons.add, size: 14.sp, color: const Color(0xFF272727)),
                        4.horizontalSpace,
                        Text("Add Item",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727))),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: const Color(0xFFF1F1F1), height: 1),

            // ── Body ──
            Expanded(
              child: c.isLoadingMenu.value
                  ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : c.menuSections.isEmpty
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restaurant_menu,
                          size: 48.sp, color: const Color(0xFFCCCCCC)),
                      16.verticalSpace,
                      Text(
                        "No menu items yet.\nAdd your first item!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF999999),
                            height: 1.6),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 12.h),
                itemCount: c.menuSections.length,
                itemBuilder: (context, sectionIndex) {
                  final section = c.menuSections[sectionIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Label
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF272727),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          section.menuSection.toUpperCase(),
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.1),
                        ),
                      ),
                      10.verticalSpace,
                      ...section.menus.map((item) =>
                          _MenuCard(item: item)),
                      16.verticalSpace,
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
              child: GestureDetector(
                onTap: () {
                  final ctrl = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Add Menu Section",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                      content: TextField(
                        controller: ctrl,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Enter Starters Desserts",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Cancel")),
                        TextButton(
                          onPressed: () {
                            if (ctrl.text.trim().isNotEmpty) {
                              c.addMenuSection(ctrl.text.trim());
                              Get.back();
                            }
                          },
                          child: const Text("Add",
                              style: TextStyle(color: Color(0xFF1C1C1C))),
                        ),
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 25),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,
                            size: 16.sp, color: const Color(0xFF272727)),
                        6.horizontalSpace,
                        Text("Add Menu Section",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF272727))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItemModel item;
  const _MenuCard({required this.item});
  @override
  Widget build(BuildContext context) {
    final c = CafeAddMenuItemController.instance;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF272727))),
                  8.verticalSpace,
                  Row(children: [
                    Icon(Icons.restaurant_menu,
                        size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    Text("Ingredients: ${item.ingredients.length} items",
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF777777))),
                  ]),
                  4.verticalSpace,
                  Row(children: [
                    Icon(Icons.access_time,
                        size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    Text("Cooking: ${item.estCookingTime}",
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF777777))),
                  ]),
                  12.verticalSpace,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          c.loadItemForEdit(item);
                          await c.fetchCategories();
                          await Get.to(() => const AddMenuScreen());
                          c.resetForm();
                          c.fetchMenus();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border:
                            Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Row(children: [
                            Icon(Icons.edit_outlined,
                                size: 13.sp, color: const Color(0xFF272727)),
                            4.horizontalSpace,
                            Text("Edit Item",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF272727))),
                          ]),
                        ),
                      ),
                      12.horizontalSpace,
                      GestureDetector(
                        onTap: () => c.deleteMenuItem(item.id),
                        child: Container(
                          padding: EdgeInsets.all(7.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border:
                            Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Icon(Icons.delete_outline,
                              size: 16.sp, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Image ──
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r)),
            child: item.images.isNotEmpty
                ? Image.network(
              item.images.first.startsWith('http')
                  ? item.images.first
                  : "${ApiEndPoint.imageUrl}${item.images.first}",
              width: 110.w,
              height: 130.h,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 110.w,
                  height: 130.h,
                  color: const Color(0xFFE0E0E0),
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF272727), strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (_, error, __) => _placeholder(),
            )
                : _placeholder(),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 110.w,
    height: 130.h,
    color: const Color(0xFFE0E0E0),
    child: Icon(Icons.restaurant,
        color: const Color(0xFF999999), size: 28.sp),
  );
}