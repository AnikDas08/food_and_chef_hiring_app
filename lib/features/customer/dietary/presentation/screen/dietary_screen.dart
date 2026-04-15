import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
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

                CommonText(text: "Dietary Restrictions & Allergies",fontSize: 24,fontWeight: FontWeight.w600,color: Color(0xff272727),maxLines: 2,textAlign: TextAlign.start,),
                SizedBox(height: 6.h),
                /*const Text(
                  'Vegetarian? Kosher? Halal? Food allergies? Enter the details below.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff777777),
                  ),
                ),*/
                CommonText(
                  text: "Vegetarian? Kosher? Halal? Food allergies? Enter the details below.",
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    final grouped = controller.groupedSavedItems;

                    if (grouped.isEmpty) {
                      return Center(
                        child: CommonText(
                          text: 'No dietary preferences saved yet.\nTap Edit to add some.',
                          fontSize: 13,
                          color: const Color(0xff777777),
                        ),
                      );
                    }

                    return ListView(
                      children: grouped.entries.map((entry) {
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
        /*Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
        ),*/
        CommonText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff1F1F1F),
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
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          // Changed to white text
          color: Colors.white,
        ),
      ),*/
      CommonText(
          text: label,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xffFFFFFF),

      )
    );
  }
}