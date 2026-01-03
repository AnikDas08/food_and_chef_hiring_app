import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';

import '../controller/dietary_controller.dart';
import '../widgets/drop_down_widgets.dart';
import '../widgets/search_builder.dart';

class DietaryScreen extends StatefulWidget {
  const DietaryScreen({super.key});

  @override
  State<DietaryScreen> createState() => _DietaryRestrictionsScreenState();
}

class _DietaryRestrictionsScreenState extends State<DietaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            Get.back();
          },
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

                const Text(
                  'Dietary Restrictions and\nAllergies',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 24.h),

                const Text(
                  'DIETARY RESTRICTIONS',
                  style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                ),

                const SizedBox(height: 12),

                CustomDropdown(
                  dropdownHeight: 170,
                  dropdown: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          controller.categories.map((item) {
                            final isSelected = controller.selectedCategories
                                .contains(item);

                            return Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: Color(0xff272727),
                                    checkColor: Colors.white,

                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          controller.selectedCategories.add(
                                            item,
                                          );
                                        } else {
                                          controller.selectedCategories.remove(
                                            item,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  CommonText(text: item, fontSize: 12),
                                ],
                              ),
                            );

                            return CheckboxListTile(
                              value: isSelected,
                              title: CommonText(text: item, fontSize: 12),
                              titleAlignment: ListTileTitleAlignment.center,

                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    controller.selectedCategories.add(item);
                                  } else {
                                    controller.selectedCategories.remove(item);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),

                  child: Container(
                    height: 48,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text:
                              controller.selectedCategories.isEmpty
                                  ? 'Select Category'
                                  : controller.selectedCategories.join(', '),

                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF777777),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                Text(
                  'ALLERGIES',
                  style: TextStyle(fontSize: 12.sp, color: Color(0xff777777)),
                ),

                SizedBox(height: 12.h),

                buildSearchSection(),

                SizedBox(height: 12.h),

                Expanded(
                  child: ListView.separated(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(12.h),
                        height: 130,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Color(0xFFF2F2F2),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Peanuts',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF272727),
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                Text(
                                  'No specific details',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Color(0xFF777777),
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                Row(
                                  children: [
                                    SizedBox(width: 14),

                                    Icon(Icons.edit_note),

                                    Text(
                                      'Edit Item',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF272727),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            CommonImage(imageSrc: AppImages.dietary),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 12.h);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
