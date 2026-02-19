import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/Cafe_menu_list_controller.dart';
import 'CafeAddMenuItemScreen.dart';
import 'Chef_cooking_expertise_screen.dart';

class CafeAddMenuItemsScreen extends StatelessWidget {
  const CafeAddMenuItemsScreen({super.key});

  void _showAddSectionDialog(BuildContext context, CafeMenuListController c) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Section"),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: "e.g. Desserts"),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () { c.addSection(ctrl.text); Get.back(); },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, CafeMenuListController c, CafeMenuSection section) {
    final nameCtrl = TextEditingController();
    final ingCtrl = TextEditingController(text: "0");
    final timeCtrl = TextEditingController(text: "0");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, autofocus: true, decoration: const InputDecoration(hintText: "Item name")),
            8.verticalSpace,
            TextField(controller: ingCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Ingredients count")),
            8.verticalSpace,
            TextField(controller: timeCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Cooking time (minutes)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              c.addItem(section, nameCtrl.text, int.tryParse(ingCtrl.text) ?? 0, int.tryParse(timeCtrl.text) ?? 0);
              Get.back();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = CafeMenuListController.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<CafeMenuListController>(
          builder: (c) => Column(
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
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp, color: const Color(0xFF272727)),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Menu Items",
                          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: const Color(0xFF272727), letterSpacing: -0.5)),
                      8.verticalSpace,
                      Text("Build your menu to showcase what you can cook for customers.",
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777), height: 1.5)),
                      20.verticalSpace,

                      // ── Menu Header ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Menu", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF272727))),
                          GestureDetector(
                            onTap: () => Get.toNamed('/cafe-add-menu-item'),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8.r)),
                              child: Row(children: [
                                Icon(Icons.add, size: 14.sp, color: const Color(0xFF272727)),
                                4.horizontalSpace,
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CafeAddMenuItemScreen()),
                                  ),
                                  child: Text(
                                    "Add Menu Item",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF272727),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,

                      // ── Sections ──
                      ...c.sections.map((section) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(section.title,
                              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: const Color(0xFF777777), letterSpacing: 1.1)),
                          10.verticalSpace,
                          ...section.items.map((item) => _MenuCard(
                            item: item,
                            onEdit: () => Get.toNamed('/cafe-add-menu-item'),
                            onDelete: () => c.deleteItem(section, item),
                            onImageTap: () => c.pickImage(item),
                          )),
                          16.verticalSpace,
                        ],
                      )),

                      // ── Add Menu Section ──
                      GestureDetector(
                        onTap: () => _showAddSectionDialog(context, c),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                          decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 16.sp, color: const Color(0xFF272727)),
                              6.horizontalSpace,
                              Text("Add Menu Section", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF272727))),
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
                    onPressed: (){

                      Get.to(()=>CafeCookingExpertiseScreen());

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C1C1C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      elevation: 0,
                    ),
                    child: Text("Finish & Create Account", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),

              // ── Skip ──
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text("Skip For Now",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF272727))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final CafeMenuItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onImageTap;

  const _MenuCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
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
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF272727))),
                  8.verticalSpace,
                  Row(children: [
                    Icon(Icons.restaurant_menu, size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    Text("Ingredients : ${item.ingredients} items",
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777))),
                  ]),
                  4.verticalSpace,
                  Row(children: [
                    Icon(Icons.access_time, size: 13.sp, color: const Color(0xFF777777)),
                    4.horizontalSpace,
                    Text("Cooking Time : ${item.cookingMinutes} minutes",
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777))),
                  ]),
                  12.verticalSpace,
                  Row(children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                        child: Row(children: [
                          Icon(Icons.edit, size: 13.sp, color: const Color(0xFF272727)),
                          4.horizontalSpace,
                          Text("Edit Item", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xFF272727))),
                        ]),
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                        child: Icon(Icons.delete_outline, size: 16.sp, color: const Color(0xFF272727)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onImageTap,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(12.r), bottomRight: Radius.circular(12.r)),
              child: item.image != null
                  ? Image.file(item.image!, width: 110.w, height: 130.h, fit: BoxFit.cover)
                  : Container(
                width: 110.w, height: 130.h,
                color: const Color(0xFFE0E0E0),
                child: Icon(Icons.add_photo_alternate_outlined, color: const Color(0xFF999999), size: 28.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}