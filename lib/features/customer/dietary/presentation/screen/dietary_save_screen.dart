import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/dietary_controller.dart';

class DietarySaveScreen extends StatelessWidget {
  const DietarySaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DietaryController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                // ── Title ──────────────────────────────────────────────────
                /*const Text(
                  'Dietary Restrictions & Allergies',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff272727),
                  ),
                ),*/
                const CommonText(
                  text: 'Dietary Restrictions & Allergies',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 6.h),
                /*const Text(
                  'Vegetarian? Kosher? Halal? Food allergies? Enter the details below.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff777777),
                  ),
                ),*/
                const CommonText(
                  text: 'Vegetarian? Kosher? Halal? Food allergies? Enter the details below.',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 24.h),

                // ── All categories with selectable chips ───────────────────
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingDietary.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      children: controller.categories.map((category) {
                        final items = controller.itemsByCategory[category] ?? [];
                        if (items.isEmpty) return const SizedBox.shrink();
                        return _EditableCategorySection(
                          title: category,
                          items: items,
                          controller: controller,
                        );
                      }).toList(),
                    );
                  }),
                ),

                // ── Save Changes Button ────────────────────────────────────
                Obx(
                      () => CommonButton(
                    titleText: controller.isLoadingDietary.value
                        ? 'Saving...'
                        : 'Save Changes',
                    onTap: controller.isLoadingDietary.value
                        ? null
                        : () => controller.saveDietaryPreferences(),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EditableCategorySection extends StatelessWidget {
  final String title;
  final List<String> items;
  final DietaryController controller;

  const _EditableCategorySection({
    required this.title,
    required this.items,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
              () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              final isSelected = controller.isItemSelected(item);
              return GestureDetector(
                onTap: () => controller.toggleDietaryItem(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff272727)
                        : const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xff272727),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}