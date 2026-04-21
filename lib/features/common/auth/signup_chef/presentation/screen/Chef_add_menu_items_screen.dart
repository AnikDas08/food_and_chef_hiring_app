import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../controller/Chef_add_menu_controller.dart';
import 'CafeAddMenuItemScreen.dart';
import 'Chef_cooking_expertise_screen.dart';

class CafeAddMenuItemsScreen extends StatelessWidget {
  const CafeAddMenuItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = CafeAddMenuItemController.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: const CommonImage(
                imageSrc: AppIcons.backIcon,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            Expanded(
              child: c.isLoadingMenu.value
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C)))
                  : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: 'Add Menu Items',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF272727),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                    ),
                    8.verticalSpace,
                    const CommonText(
                      text: 'Build your menu to showcase what you can cook for customers.',
                      fontSize: 12,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                    ),
                    20.verticalSpace,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CommonText(
                          text: 'Menu',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF272727),
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          onTap: () async {
                            c.resetForm();
                            await c.fetchCategories();
                            await Get.to(() => const CafeAddMenuItemScreen());
                            c.resetForm();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(8.r)),
                            child: Row(children: [
                              Icon(Icons.add, size: 14.sp, color: const Color(0xFF272727)),
                              4.horizontalSpace,
                              const CommonText(
                                text: 'Add Menu Item',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF272727),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,

                    if (c.menuSections.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: const CommonText(
                            text: 'No menu items yet.\nAdd your first item!',
                            color: Color(0xFF999999),
                            maxLines: 3,
                          ),
                        ),
                      )
                    else
                      ...c.menuSections.map((section) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF272727),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: CommonText(
                              text: section.menuSection.toUpperCase(),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          10.verticalSpace,
                          ...section.menus.map((item) => _ApiMenuCard(item: item)),
                          16.verticalSpace,
                        ],
                      )),

                    GestureDetector(
                      onTap: () {
                        final ctrl = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const CommonText(
                              text: 'Add Menu Section',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.left,
                            ),
                            content: TextField(
                              controller: ctrl,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Enter Your Menu',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const CommonText(text: 'Cancel', color: Colors.grey)),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if (ctrl.text.trim().isNotEmpty) {
                                    c.addMenuSection(ctrl.text.trim());
                                  }
                                },
                                child: const CommonText(
                                  text: 'Add',
                                  color: Color(0xFF1C1C1C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: const BoxDecoration(color: Color(0xFFF0F0F0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 16.sp, color: const Color(0xFF272727)),
                            6.horizontalSpace,
                            const CommonText(
                              text: 'Add Menu Section',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF272727),
                            ),
                          ],
                        ),
                      ),
                    ),

                    32.verticalSpace,
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
              child: SizedBox(
                width: double.infinity, height: 54.h,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const CafeCookingExpertiseScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: const CommonText(
                    text: 'Continue',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

class _ApiMenuCard extends StatelessWidget {
  final MenuItemModel item;
  const _ApiMenuCard({required this.item});

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
                  CommonText(
                    text: item.name,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF272727),
                    textAlign: TextAlign.left,
                  ),
                  8.verticalSpace,
                  Row(children: [
                    Icon(Icons.restaurant_menu, size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    CommonText(
                      text: 'Ingredients: ${item.ingredients.length} items',
                      fontSize: 12,
                      color: const Color(0xFF777777),
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.left,
                    ),
                  ]),
                  4.verticalSpace,
                  Row(children: [
                    Icon(Icons.access_time, size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    CommonText(
                      text: 'Cooking: ${item.estCookingTime}',
                      fontSize: 12,
                      color: const Color(0xFF777777),
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.left,
                    ),
                  ]),
                  12.verticalSpace,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          c.loadItemForEdit(item);
                          await c.fetchCategories();
                          if (c.categoryList.contains(item.menuSection)) {
                            c.setCategory(item.menuSection);
                          } else if (c.categoryList.isNotEmpty) {
                            c.setCategory(c.categoryList.first);
                          }
                          await Get.to(() => const CafeAddMenuItemScreen());
                          c.resetForm();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Row(children: [
                            Icon(Icons.edit_outlined, size: 13.sp, color: const Color(0xFF272727)),
                            4.horizontalSpace,
                            const CommonText(
                              text: 'Edit Item',
                              fontSize: 12,
                              color: Color(0xFF272727),
                            ),
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
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Icon(Icons.delete_outline, size: 16.sp, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r)),
            child: item.images.isNotEmpty
                ? Image.network(
              item.images.first.startsWith('http')
                  ? item.images.first
                  : '${ApiEndPoint.imageUrl}${item.images.first}',
              width: 110.w, height: 130.h, fit: BoxFit.cover,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 110.w, height: 130.h,
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
    width: 110.w, height: 130.h,
    color: const Color(0xFFE0E0E0),
    child: Icon(Icons.restaurant, color: const Color(0xFF999999), size: 28.sp),
  );
}