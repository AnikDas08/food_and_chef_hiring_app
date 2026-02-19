import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/Chef_add_menu_controller.dart';

class CafeAddMenuItemScreen extends StatelessWidget {
  const CafeAddMenuItemScreen({super.key});

  void _showAddDialog(BuildContext context, String title, Function(String) onAdd) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add $title"),
        content: TextField(controller: ctrl, autofocus: true, decoration: InputDecoration(hintText: title)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(onPressed: () { onAdd(ctrl.text); Get.back(); }, child: const Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = CafeAddMenuItemController.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<CafeAddMenuItemController>(
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
                      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10.r)),
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
                      Text("Add Menu Item",
                          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: const Color(0xFF272727), letterSpacing: -0.5)),
                      8.verticalSpace,
                      Text("Add your menu and items to showcase what you can cook for customers.",
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777), height: 1.5)),
                      20.verticalSpace,

                      // ── Previews ──
                      _label("Previews"),
                      8.verticalSpace,
                      GestureDetector(
                        onTap: () => c.pickImage(),
                        child: Container(
                          width: 107.w, height: 112.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: c.previewImage != null
                              ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(c.previewImage!, fit: BoxFit.cover))
                              : Center(child: Icon(Icons.add, size: 28.sp, color: const Color(0xFF777777))),
                        ),
                      ),
                      20.verticalSpace,

                      // ── Menu Category ──
                      _DropdownField(
                        title: "Menu Category",
                        value: c.selectedCategory,
                        items: c.categories,
                        onChanged: c.setCategory,
                      ),
                      16.verticalSpace,

                      // ── Item Name ──
                      _label("Item Name"),
                      8.verticalSpace,
                      _textField(c.nameController, "e.g. Quesadilla"),
                      16.verticalSpace,

                      // ── Description ──
                      _label("Description"),
                      8.verticalSpace,
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
                        child: TextField(
                          controller: c.descriptionController,
                          maxLines: 4,
                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(14.w),
                            hintText: "Describe your dish...",
                            hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB)),
                          ),
                        ),
                      ),
                      16.verticalSpace,

                      // ── Diet Types ──
                      _DropdownField(title: "Diet Types", value: c.selectedDietType, items: c.dietTypes, onChanged: c.setDietType),
                      16.verticalSpace,

                      // ── Allergens ──
                      _DropdownField(title: "Allergens", value: c.selectedAllergen, items: c.allergens, onChanged: c.setAllergen),
                      16.verticalSpace,

                      // ── Est. Preparation Time ──
                      _DropdownField(title: "Est. Preparation Time", value: c.selectedPrepTime, items: c.times, onChanged: c.setPrepTime),
                      16.verticalSpace,

                      // ── Est. Cooking Time ──
                      _DropdownField(title: "Est. Cooking Time", value: c.selectedCookTime, items: c.times, onChanged: c.setCookTime),
                      16.verticalSpace,

                      // ── Customize the Dish ──
                      _SectionHeader(
                        title: "Customize the Dish",
                        expanded: c.customizeExpanded,
                        onAddTap: () => _showAddDialog(context, "Customize Option", c.addCustomizeOption),
                        onToggle: c.toggleCustomize,
                      ),
                      if (c.customizeExpanded) ...[
                        8.verticalSpace,
                        ...c.customizeOptions.map((opt) => _CheckItem(
                          label: opt,
                          onRemove: () => c.removeCustomizeOption(opt),
                        )),
                      ],
                      16.verticalSpace,

                      // ── Ingredients ──
                      _SectionHeader(
                        title: "Ingredients",
                        expanded: c.ingredientsExpanded,
                        onAddTap: () => _showAddDialog(context, "Ingredient", c.addIngredient),
                        onToggle: c.toggleIngredients,
                      ),
                      if (c.ingredientsExpanded && c.ingredients.isNotEmpty) ...[
                        8.verticalSpace,
                        ...c.ingredients.map((ing) => _CheckItem(label: ing, onRemove: () => c.ingredients.remove(ing))),
                      ],
                      16.verticalSpace,

                      // ── Special Equipment ──
                      _SectionHeader(
                        title: "Special Equipment",
                        expanded: c.equipmentExpanded,
                        onAddTap: () => _showAddDialog(context, "Equipment", c.addEquipment),
                        onToggle: c.toggleEquipment,
                      ),
                      if (c.equipmentExpanded && c.specialEquipment.isNotEmpty) ...[
                        8.verticalSpace,
                        ...c.specialEquipment.map((eq) => _CheckItem(label: eq, onRemove: () => c.specialEquipment.remove(eq))),
                      ],
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),

              // ── Add Item Button ──
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                child: SizedBox(
                  width: double.infinity, height: 54.h,
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: c.getItemData()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C1C1C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      elevation: 0,
                    ),
                    child: Text("Add Item", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF272727)));

  Widget _textField(TextEditingController ctrl, String hint) => Container(
    decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
    child: TextField(
      controller: ctrl,
      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB)),
      ),
    ),
  );
}

// ─── Dropdown Field ───────────────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final Function(String) onChanged;

  const _DropdownField({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF272727))),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF272727)),
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) { if (v != null) onChanged(v); },
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Section Header (Customize / Ingredients / Equipment) ────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onAddTap;
  final VoidCallback onToggle;

  const _SectionHeader({
    required this.title,
    required this.expanded,
    required this.onAddTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF272727))),
        const Spacer(),
        GestureDetector(
          onTap: onAddTap,
          child: Row(children: [
            Icon(Icons.add, size: 14.sp, color: const Color(0xFF272727)),
            4.horizontalSpace,
            Text("Add", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF272727))),
          ]),
        ),
        12.horizontalSpace,
        GestureDetector(
          onTap: onToggle,
          child: Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 20.sp,
            color: const Color(0xFF272727),
          ),
        ),
      ],
    );
  }
}

// ─── Check Item ───────────────────────────────────────────────────────────────
class _CheckItem extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _CheckItem({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 18.w, height: 18.w,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          10.horizontalSpace,
          Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)))),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 16.sp, color: const Color(0xFF999999)),
          ),
        ],
      ),
    );
  }
}