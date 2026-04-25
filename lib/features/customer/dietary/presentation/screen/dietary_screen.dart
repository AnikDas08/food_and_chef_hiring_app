import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';
import '../controller/dietary_controller.dart';
import 'dietary_save_screen.dart';

class DietaryScreen extends StatefulWidget {
  const DietaryScreen({super.key});

  @override
  State<DietaryScreen> createState() => _DietaryScreenState();
}

class _DietaryScreenState extends State<DietaryScreen> {
  late DietaryController controller;

  @override
  void initState() {
    super.initState();
    // Force delete old instance and create a fresh one every visit
    Get.delete<DietaryController>(force: true);
    controller = Get.put(DietaryController());
  }

  @override
  void dispose() {
    Get.delete<DietaryController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DietaryController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const CommonText(
              text: 'Dietary Restrictions',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                SizedBox(height: 6.h),

                const CommonText(
                  text:
                      'Vegetarian? Kosher? Halal? Food allergies? Enter the details below.',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 24.h),

                // ── Grouped dietary items ──────────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingDietary.value) {
                      return Center(child: CupertinoActivityIndicator());
                    }

                    final grouped = controller.groupedSavedItems;

                    if (grouped.isEmpty) {
                      return const Center(
                        child: CommonText(
                          text:
                              'No dietary preferences saved yet.\nTap Edit to add some.',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      );
                    }

                    return ListView(
                      children:
                          grouped.entries.map((entry) {
                            return _CategorySection(
                              title: entry.key,
                              items: entry.value,
                            );
                          }).toList(),
                    );
                  }),
                ),

                // ── Edit Button ────────────────────────────────────────────
                CommonButton(
                  titleText: 'Edit',
                  onTap: () async {
                    await Get.to(() => const DietarySaveScreen());
                    // Refresh after returning from edit screen
                    controller.loadSavedPreferences();
                  },
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

class _CategorySection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _CategorySection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: title,
          fontWeight: FontWeight.w600,
          color: const Color(0xff1F1F1F),
          fontSize: 16,
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => _Chip(label: item)).toList(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        // Changed to black background
        color: const Color(0xff272727),
        borderRadius: BorderRadius.circular(20),
      ),
      child: /*Text(

      ),*/ CommonText(
        text: label,
        fontSize: 12,
        color: const Color(0xffFFFFFF),
      ),
    );
  }
}
