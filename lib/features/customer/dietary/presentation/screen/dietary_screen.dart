import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import '../controller/dietary_controller.dart';

class DietaryScreen extends StatefulWidget {
  const DietaryScreen({super.key});

  @override
  State<DietaryScreen> createState() => _DietaryScreenState();
}

class _DietaryScreenState extends State<DietaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<DietaryController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),

                // ── TITLE ──────────────────────────────────────────────────
                const Text(
                  'Dietary Restrictions and\nAllergies',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 24.h),

                // ── DROPDOWN SECTION ───────────────────────────────────────
                CommonText(
                  text: 'SELECT CATEGORY',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                  bottom: 8,
                ),

                // Dropdown Button
                Obx(
                      () => Container(
                    height: 48,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF2F2F2),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox.shrink(),
                      value: controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value,
                      hint: CommonText(
                        text: 'Select Category',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF777777),
                      ),
                      items: controller.categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: CommonText(
                            text: category,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectCategory(newValue);
                        }
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                // ── SEARCH SECTION ─────────────────────────────────────────
                CommonText(
                  text: 'DIETARY ITEMS',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                  bottom: 8,
                ),

                CommonTextField(
                  controller: controller.searchController,
                  hintText: 'Search items...',
                  borderRadius: 12,
                  borderColor: const Color(0xffF2F2F2),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.search),
                  ),
                  paddingHorizontal: 0,
                ),

                SizedBox(height: 16.h),

                // ── LOADING INDICATOR ──────────────────────────────────────
                Obx(
                      () => controller.isLoadingDietary.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox.shrink(),
                ),

                // ── DIETARY ITEMS LIST WITH CHECKBOXES ─────────────────────
                Obx(
                      () {
                    if (controller.selectedCategory.value.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: CommonText(
                            text: 'Please select a category first',
                            fontSize: 12,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      );
                    }

                    if (controller.filteredDietaryItems.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: CommonText(
                            text: 'No dietary items found',
                            fontSize: 12,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        itemCount: controller.filteredDietaryItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredDietaryItems[index];

                          // ✅ Wrap each item with Obx for reactivity
                          return Obx(
                                () {
                              final isSelected = controller.isItemSelected(item);

                              return Container(
                                padding: EdgeInsets.all(12.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: const Color(0xFFF2F2F2),
                                  border: isSelected
                                      ? Border.all(
                                    color: const Color(0xff272727),
                                    width: 2,
                                  )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: const Color(0xff272727),
                                      checkColor: Colors.white,
                                      value: isSelected,
                                      onChanged: (_) {
                                        // Toggle selection
                                        controller.toggleDietaryItem(item);
                                      },
                                    ),
                                    Expanded(
                                      child: CommonText(
                                        text: item,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF272727),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                      ),
                    );
                      },
                ),

                SizedBox(height: 24.h),

                // ── SAVE BUTTON ────────────────────────────────────────────
                Obx(
                      () => CommonButton(
                    titleText: controller.isLoadingDietary.value
                        ? 'Saving...'
                        : 'Save Dietary Preferences',
                    onTap: controller.isLoadingDietary.value
                        ? null
                        : () => controller.saveDietaryPreferences(),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}