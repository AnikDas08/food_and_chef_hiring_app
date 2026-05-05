import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../controller/Chef_add_menu_controller.dart';

class CafeAddMenuItemScreen extends StatelessWidget {
  const CafeAddMenuItemScreen({super.key});

  void _showAddDialog(BuildContext context, String title, Function(String) onAdd) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add $title'),
        content: TextField(controller: ctrl, autofocus: true, decoration: InputDecoration(hintText: title)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                onAdd(ctrl.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add',)),
        ],
      ),
    );
  }

  void _showIngredientDialog(BuildContext context, CafeAddMenuItemController c) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    String localUnit = c.unitsList.isNotEmpty ? c.unitsList.first : 'kg';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Add Ingredient', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(nameCtrl, 'Ingredient name', autofocus: true),
              10.verticalSpace,
              _dialogField(qtyCtrl, 'Quantity', isNumber: true),
              10.verticalSpace,
              Obx(() {
                if (c.isLoadingUnits.value) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                }
                final units = c.unitsList.isEmpty ? ['kg', 'g', 'ml', 'l'] : c.unitsList;
                if (!units.contains(localUnit)) localUnit = units.first;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10.r)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: localUnit,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      icon: Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF272727)),
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
                      items: units.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) { if (v != null) setState(() => localUnit = v); },
                    ),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel',)),
            TextButton(onPressed: () { c.addIngredient(nameCtrl.text, qtyCtrl.text, localUnit); Navigator.of(context).pop(); }, child: const Text('Add',)),

          ],
        ),
      ),
    );
  }

  static Widget _dialogField(TextEditingController ctrl, String hint, {bool autofocus = false, bool isNumber = false}) {
    return Builder(builder: (context) => Container(
      decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10.r)),
      child: TextField(
        controller: ctrl,
        autofocus: autofocus,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(fontSize: 13.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB)),
        ),
      ),
    ));
  }

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
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Menu Item',
                        style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727), letterSpacing: -0.5)),
                    8.verticalSpace,
                    Text('Add your menu and items to showcase what you can cook for customers.',
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777), height: 1.5)),
                    20.verticalSpace,

                    _label('Previews'),
                    8.verticalSpace,
                    Obx(() => GestureDetector(
                      onTap: () => c.pickImage(),
                      child: Container(
                        width: 107.w, height: 112.h,
                        decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.r)),
                        child: c.previewImage.value != null
                            ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(c.previewImage.value!, fit: BoxFit.cover))
                            : Center(child: Icon(Icons.add, size: 28.sp, color: const Color(0xFF777777))),
                      ),
                    )),
                    20.verticalSpace,
                    _label('Menu Category'),
                    8.verticalSpace,
                    Obx(() {
                      if (c.isLoadingCategory.value) {
                        return Container(
                          height: 50.h,
                          decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
                          child: const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C), strokeWidth: 2)),
                        );
                      }
                      if (c.categoryList.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                          decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
                          child: Text('No category found. Add a menu section first.',
                              style: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB))),
                        );
                      }

                      final safeVal = c.safeCategoryValue;

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: safeVal,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            icon: Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF272727)),
                            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
                            items: c.categoryList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (v) { if (v != null) c.setCategory(v); },
                          ),
                        ),
                      );
                    }),
                    16.verticalSpace,

                    _label('Item Name'),
                    8.verticalSpace,
                    _textField(c.nameController,),
                    16.verticalSpace,

                    _label('Description'),
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
                          hintText: 'Describe your dish...',
                          hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB)),
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    _label('Diet Types'),
                    8.verticalSpace,
                    Obx(() => _dropdownContainer(
                      value: c.selectedDietType,
                      items: c.dietTypes,
                      onChanged: c.setDietType,
                    )),
                    16.verticalSpace,

                    _label('Allergens'),
                    8.verticalSpace,
                    Obx(() => GestureDetector(
                      onTap: c.toggleAllergensExpanded,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: c.allergensExpanded.value
                              ? BorderRadius.vertical(top: Radius.circular(12.r))
                              : BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.selectedAllergens.isEmpty ? 'Select allergens...' : c.selectedAllergens.join(', '),
                                style: TextStyle(fontSize: 13.sp,
                                    color: c.selectedAllergens.isEmpty ? const Color(0xFFBBBBBB) : const Color(0xFF272727)),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(c.allergensExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 18.sp, color: const Color(0xFF272727)),
                          ],
                        ),
                      ),
                    )),
                    Obx(() => c.allergensExpanded.value
                        ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
                      ),
                      child: Column(
                        children: c.allergens.map((allergen) {
                          final isSelected = c.selectedAllergens.contains(allergen);
                          return InkWell(
                            onTap: () => c.toggleAllergen(allergen),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18.w, height: 18.w,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF1C1C1C) : Colors.transparent,
                                      border: Border.all(color: isSelected ? const Color(0xFF1C1C1C) : const Color(0xFFCCCCCC), width: 1.5),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: isSelected ? Icon(Icons.check, size: 12.sp, color: Colors.white) : null,
                                  ),
                                  12.horizontalSpace,
                                  Text(allergen, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727),
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                        : const SizedBox.shrink()),
                    16.verticalSpace,

                    _label('Est. Preparation Time'),
                    8.verticalSpace,
                    Obx(() => _TimeInputRow(
                      controller: c.prepTimeController,
                      selectedUnit: c.selectedPrepUnit,
                      units: c.timeUnits,
                      onUnitChanged: c.setPrepUnit,
                    )),
                    16.verticalSpace,

                    _label('Est. Cooking Time'),

                    8.verticalSpace,

                    Obx(() => _TimeInputRow(
                      controller: c.cookTimeController,
                      selectedUnit: c.selectedCookUnit,
                      units: c.timeUnits,
                      onUnitChanged: c.setCookUnit,
                    )),

                    16.verticalSpace,

                    Obx(() => _SectionHeader(
                      title: 'Customize the Dish',
                      expanded: c.customizeExpanded.value,
                      onAddTap: () => _showAddDialog(context, 'Customize Option', c.addCustomizeOption),
                      onToggle: c.toggleCustomize,
                    )),

                    Obx(() => c.customizeExpanded.value
                        ? Column(
                      children: [
                        8.verticalSpace,
                        ...c.customizeOptions.map((opt) => _CheckItem(label: opt, onRemove: () => c.removeCustomizeOption(opt))),
                      ],
                    )
                        : const SizedBox.shrink()),
                    16.verticalSpace,

                    Obx(() => _SectionHeader(
                      title: 'Ingredients',
                      expanded: c.ingredientsExpanded.value,
                      onAddTap: () => _showIngredientDialog(context, c),
                      onToggle: c.toggleIngredients,
                    )),
                    Obx(() => c.ingredientsExpanded.value
                        ? Column(
                      children: [
                        8.verticalSpace,
                        c.ingredientsList.isEmpty
                            ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Text('select at least one ingredient',
                              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999))),
                        )
                            : Column(
                          children: List.generate(c.ingredientsList.length, (i) {
                            final ing = c.ingredientsList[i];
                            return _IngredientRow(name: ing.name, quantity: ing.quantity, unit: ing.unit, onRemove: () => c.removeIngredient(i));
                          }),
                        ),
                      ],
                    )
                        : const SizedBox.shrink()),
                    16.verticalSpace,

                    _label('Special Equipment'),
                    8.verticalSpace,
                    Obx(() => GestureDetector(
                      onTap: c.toggleEquipment,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: c.equipmentExpanded.value
                              ? BorderRadius.vertical(top: Radius.circular(12.r))
                              : BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.selectedEquipmentIds.isEmpty ? 'Select equipment...' : c.selectedEquipmentNames.join(', '),
                                style: TextStyle(fontSize: 13.sp,
                                    color: c.selectedEquipmentIds.isEmpty ? const Color(0xFFBBBBBB) : const Color(0xFF272727)),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(c.equipmentExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 18.sp, color: const Color(0xFF272727)),
                          ],
                        ),
                      ),
                    )),
                    Obx(() => c.equipmentExpanded.value
                        ? c.isLoadingEquipment.value
                        ? Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r))),
                      child: const Center(child: CircularProgressIndicator(color: Color(0xFF1C1C1C), strokeWidth: 2)),
                    )
                        : c.equipmentList.isEmpty
                        ? Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r))),
                      child: Text('No equipment found', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF999999))),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
                      ),
                      child: Column(
                        children: c.equipmentList.map((eq) {
                          final isSelected = c.selectedEquipmentIds.contains(eq.id);
                          return InkWell(
                            onTap: () => c.toggleEquipmentSelection(eq.id),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18.w, height: 18.w,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF1C1C1C) : Colors.transparent,
                                      border: Border.all(color: isSelected ? const Color(0xFF1C1C1C) : const Color(0xFFCCCCCC), width: 1.5),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: isSelected ? Icon(Icons.check, size: 12.sp, color: Colors.white) : null,
                                  ),
                                  12.horizontalSpace,
                                  Text(eq.name, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727),
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                        : const SizedBox.shrink()),

                    32.verticalSpace,
                  ],
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: Obx(() => SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: c.isSubmitting.value
                      ? null
                      : () => c.isEditMode.value
                      ? c.updateMenuItem()
                      : c.submitMenuItem(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    disabledBackgroundColor: const Color(0xFF1C1C1C),
                    disabledForegroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: c.isSubmitting.value
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(
                    c.isEditMode.value ? 'Update Item' : 'Add Item',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF272727)));

  Widget _textField(TextEditingController ctrl,) => Container(
    decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
    child: TextField(
      controller: ctrl,
      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        hintText: 'Enter name',
        hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB)),
      ),
    ),
  );

  Widget _dropdownContainer({required String value, required List<String> items, required Function(String) onChanged}) {

    final safeValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : null);
    if (safeValue == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          icon: Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF272727)),
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}


class _IngredientRow extends StatelessWidget {
  final String name;
  final String quantity;
  final String unit;
  final VoidCallback onRemove;

  const _IngredientRow({required this.name, required this.quantity, required this.unit, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(name, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF272727)))),
            Expanded(flex: 2, child: Text('$quantity $unit', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777)))),
            GestureDetector(onTap: onRemove, child: Icon(Icons.close, size: 16.sp, color: const Color(0xFF999999))),
          ],
        ),
      ),
    );
  }
}


class _TimeInputRow extends StatelessWidget {
  final TextEditingController controller;
  final String selectedUnit;
  final List<String> units;
  final Function(String) onUnitChanged;

  const _TimeInputRow({required this.controller, required this.selectedUnit, required this.units, required this.onUnitChanged});

  @override
  Widget build(BuildContext context) {
    final safeUnit = units.contains(selectedUnit) ? selectedUnit : units.first;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                hintText: 'Enter time',
                hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFBBBBBB)),
              ),
            ),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12.r)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safeUnit,
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                icon: Icon(Icons.keyboard_arrow_down, size: 18.sp, color: const Color(0xFF272727)),
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)),
                items: units.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) { if (v != null) onUnitChanged(v); },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {

  final String title;
  final bool expanded;
  final VoidCallback onAddTap;
  final VoidCallback onToggle;

  const _SectionHeader({required this.title, required this.expanded, required this.onAddTap, required this.onToggle});

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

            Text('Add', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF272727))),


          ]),
        ),
        12.horizontalSpace,
        GestureDetector(
          onTap: onToggle,
          child: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20.sp, color: const Color(0xFF272727)),
        ),
      ],
    );
  }
}


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
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCCCCCC)), borderRadius: BorderRadius.circular(4.r)),
          ),
          10.horizontalSpace,
          Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF272727)))),
          GestureDetector(onTap: onRemove, child: Icon(Icons.close, size: 16.sp, color: const Color(0xFF999999))),
        ],
      ),
    );
  }
}
