import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/Chef_add_menu_controller.dart';
import 'CafeAddMenuItemScreen.dart';
import 'Chef_cooking_expertise_screen.dart';

class CafeAddMenuItemsScreen extends StatelessWidget {
  const CafeAddMenuItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = CafeAddMenuItemController.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // ── Back ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
              ),
            ),

            Expanded(
              child: c.isLoadingMenu.value
                  ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add Menu Items",
                        style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727),
                            letterSpacing: -0.5)),
                    8.verticalSpace,
                    Text("Build your menu to showcase what you can cook for customers.",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF777777),
                            height: 1.5)),
                    20.verticalSpace,

                    // ── Menu Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Menu",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF272727))),
                        GestureDetector(
                          onTap: () async {
                            await Get.to(() => const CafeAddMenuItemScreen());
                            c.fetchMenus(); // ← add এর পরে refresh
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 7.h),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(8.r)),
                            child: Row(children: [
                              Icon(Icons.add,
                                  size: 14.sp, color: const Color(0xFF272727)),
                              4.horizontalSpace,
                              Text("Add Menu Item",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF272727))),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,

                    // ── Sections from API ──
                    if (c.menuSections.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Text(
                            "No menu items yet.\nAdd your first item!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF999999),
                                height: 1.6),
                          ),
                        ),
                      )
                    else
                      ...c.menuSections.map((section) => Column(
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
                          ...section.menus.map((item) => _ApiMenuCard(item: item)),
                          16.verticalSpace,
                        ],
                      )),

                    32.verticalSpace,
                  ],
                ),
              ),
            ),

            // ── Finish Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
              child: SizedBox(
                width: double.infinity, height: 54.h,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => CafeCookingExpertiseScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: Text("Finish & Create Account",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text("Skip For Now",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF272727))),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

// ── API থেকে আসা Menu Card ──
class _ApiMenuCard extends StatelessWidget {
  final MenuItemModel item;
  const _ApiMenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
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
              "http://10.10.7.9:5014${item.images.first}",
              width: 110.w,
              height: 110.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
                : _placeholder(),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 110.w,
    height: 110.h,
    color: const Color(0xFFE0E0E0),
    child: Icon(Icons.restaurant,
        color: const Color(0xFF999999), size: 28.sp),
  );
}