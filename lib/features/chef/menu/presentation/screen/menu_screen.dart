import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../common/auth/signup_chef/presentation/controller/Chef_add_menu_controller.dart';
import 'add_menu_screen.dart';

class MenuScreen extends StatelessWidget {

  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final c = CafeAddMenuItemController.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
      ),
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF272727),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      final ctrl = TextEditingController();
                      String? error;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Add Menu Section',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F7F7),
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: error != null
                                            ? Border.all(color: Colors.red.shade300)
                                            : null,
                                      ),
                                      child: TextField(
                                        controller: ctrl,
                                        autofocus: true,
                                        style: TextStyle(fontSize: 13.sp),
                                        onChanged: (_) {
                                          if (error != null) {
                                            setState(() => error = null);
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 12.h,
                                          ),
                                          hintText: 'Enter Starters, Desserts',
                                          hintStyle: TextStyle(
                                            fontSize: 13.sp,
                                            color: const Color(0xFFBBBBBB),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (error != null) ...[
                                      4.verticalSpace,
                                      Text(
                                        error!,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (ctrl.text.trim().isEmpty) {
                                        setState(() {
                                          error = 'Please enter a section name';
                                        });
                                        return;
                                      }
                                      Navigator.pop(context);
                                      await c.addMenuSection(ctrl.text.trim());
                                    },
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(color: Color(0xFF1C1C1C), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),

                      child: Row(

                        mainAxisSize: MainAxisSize.min,

                        children: [

                          Icon(Icons.add, size: 14.sp, color: const Color(0xFF272727)),

                          4.horizontalSpace,

                          Text(
                            'Add Section',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF272727),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            const Divider(color: Color(0xFFF1F1F1), height: 1),

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
                        'No menu items yet.\nAdd your first item!',
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                itemCount: c.menuSections.length,
                itemBuilder: (context, sectionIndex) {
                  final section = c.menuSections[sectionIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(

                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF272727),
                          borderRadius: BorderRadius.circular(6.r),
                        ),

                        child: CommonText(
                          text: section.menuSection.toUpperCase(),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )

                      ),
                      10.verticalSpace,
                      ...section.menus.map((item) => _MenuCard(item: item)),
                      16.verticalSpace,
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
              child: GestureDetector(
                onTap: () async {
                  c.resetForm();
                  await c.fetchCategories();
                  await Get.to(() => const AddMenuScreen());
                  c.resetForm();
                  c.fetchMenus();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 16.sp, color: const Color(0xFF272727)),
                        6.horizontalSpace,
                        Text('Add Item',
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF272727),
                      decoration: TextDecoration.none,
                    ),
                  ),

                  8.verticalSpace,

                  Row(children: [
                    Icon(Icons.restaurant_menu,
                        size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    Text('Ingredients: ${item.ingredients.length} items',
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF777777))),
                  ]),

                  4.verticalSpace,

                  Row(children: [
                    Icon(Icons.access_time,
                        size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    Text('Cooking: ${item.estCookingTime}',
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
                          ),
                          child: Row(children: [

                            SvgPicture.asset(
                              AppIcons.edit_manu_bar,
                              width: 16,
                              height: 16,
                            ),

                            4.horizontalSpace,

                            Text('Edit Item',
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
                          ),
                          child:
                          SvgPicture.asset(
                            AppIcons.delete_menu_icon,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: item.images.isNotEmpty
                  ? Image.network(
                item.images.first.startsWith('http')
                    ? item.images.first
                    : '${ApiEndPoint.imageUrl}/${item.images.first}',
                width: 90.w,
                height: 90.w,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 90.w,
                    height: 90.w,
                    color: const Color(0xFFE0E0E0),
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF272727), strokeWidth: 2)),
                  );
                },
                errorBuilder: (_, error, __) => _placeholder(),
              )
                  : _placeholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 90.w,
    height: 90.w,
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Icon(Icons.restaurant,
        color: const Color(0xFF999999), size: 28.sp),
  );
}