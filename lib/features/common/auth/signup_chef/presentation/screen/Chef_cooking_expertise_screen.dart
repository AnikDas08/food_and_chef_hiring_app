import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../component/image/common_image.dart';
import '../../../../../../utils/constants/app_icons.dart';
import '../controller/chef_Cooking_Expertise_Controller.dart';

class CafeCookingExpertiseScreen extends StatelessWidget {
  const CafeCookingExpertiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CafeCookingExpertiseController());

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      Text(
                        'Cooking Expertise',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF272727),
                          letterSpacing: -0.5,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Define your speciality cuisine.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      24.verticalSpace,
                      Text(
                        'Cuisines',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF272727),
                        ),
                      ),
                      10.verticalSpace,


                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            // Header Row
                            GestureDetector(
                              onTap: controller.toggleDropdown,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: controller.selectedCuisines.isEmpty
                                          ? Text(
                                        'Select cuisines',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: const Color(0xFFBBBBBB),
                                        ),
                                      )
                                          : Wrap(
                                        spacing: 6.w,
                                        runSpacing: 6.h,
                                        children: controller.selectedCuisines
                                            .map((c) => _Chip(label: c.name))
                                            .toList(),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Icon(
                                      controller.dropdownOpen.value
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 20.sp,
                                      color: const Color(0xFF272727),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Dropdown List
                            if (controller.dropdownOpen.value) ...[
                              Divider(height: 1, color: Colors.grey.shade200),
                              ...controller.allCuisines.map((cuisine) {
                                final selected = controller.isSelected(cuisine.id);
                                return GestureDetector(
                                  onTap: () => controller.toggleCuisine(cuisine.id),
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 14.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          cuisine.name,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: selected
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                            color: const Color(0xFF272727),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? const Color(0xFF272727)
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: selected
                                                ? null
                                                : Border.all(
                                              color: const Color(0xFFCCCCCC),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: selected
                                              ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14.sp,
                                          )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                      32.verticalSpace,
                    ],
                  ),
                );
              }),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: controller.onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF272727),
        ),
      ),
    );
  }
}