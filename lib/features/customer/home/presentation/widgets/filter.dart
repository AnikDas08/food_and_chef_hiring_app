import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/switch_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/search_controller.dart';

Future<dynamic> filterPanel() {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: Get.context!,
    barrierColor: Colors.grey,
    isScrollControlled: true,
    builder: (context) {
      return const Filter();
    },
  );
}

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder:
          (controller) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12).copyWith(bottom: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: Get.size.height - 140.h,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          24.height,

                          // ── HEADER ─────────────────────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CommonText(
                                text: AppString.filters,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.clearAllFilters();
                                  Navigator.pop(context);
                                },
                                child: const CommonText(
                                  text: AppString.clearFilters,
                                  color: Color(0xffFD713F),
                                ),
                              ),
                            ],
                          ),

                          Divider(color: const Color(0xffF1F1F1), height: 32.h),

                          // ── PRICE RANGE ────────────────────────────────────────────
                          const CommonText(
                            text: AppString.price,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F1F1F),
                          ),
                          const CommonText(
                            text: AppString.selectARangeOfValues,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                            top: 12,
                          ),
                          Obx(
                            () => RangeSlider(
                              values: RangeValues(
                                controller.minPrice.value,
                                controller.maxPrice.value,
                              ),
                              max: 100,
                              activeColor: const Color(0xff272727),
                              inactiveColor: const Color(0xffEFEFEF),
                              labels: RangeLabels(
                                '\$${controller.minPrice.value.toInt()}',
                                '\$${controller.maxPrice.value.toInt()}',
                              ),
                              onChanged: (RangeValues newValues) {
                                controller.minPrice.value = newValues.start;
                                controller.maxPrice.value = newValues.end;
                              },
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                text: '\$0/hr',
                                fontSize: 12,
                                color: Color(0xff777777),
                              ),
                              CommonText(
                                text: '\$100/hr',
                                fontSize: 12,
                                color: Color(0xff777777),
                              ),
                            ],
                          ),

                          Divider(color: const Color(0xffF1F1F1), height: 32.h),

                          // ── TIME AVAILABILITY ─────────────────────────────────────
                          const CommonText(
                            text: AppString.timeAvailability,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F1F1F),
                            bottom: 12,
                          ),

                          const TimeAvailabilitySection(),

                          Divider(color: const Color(0xffF1F1F1), height: 32.h),

                          // ── PROFESSIONAL LEVEL ────────────────────────────────────
                          const CommonText(
                            text: AppString.chefProfessionalLevel,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F1F1F),
                            bottom: 12,
                          ),

                          const ProfessionalLevelSection(),

                          Divider(color: const Color(0xffF1F1F1), height: 32.h),

                          // ── SAVED CHEFS ONLY ───────────────────────────────────────
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CommonText(
                                  text: AppString.savedChefsOnly,
                                ),
                                switchButton(
                                  value: controller.savedChefsOnly.value,
                                  onTap: () {
                                    // Toggle: true → false, false → true
                                    controller.savedChefsOnly.value =
                                        !controller.savedChefsOnly.value;
                                  },
                                  color: const Color(0xff2F8328),
                                ),
                              ],
                            ),
                          ),

                          Divider(color: const Color(0xffF1F1F1), height: 32.h),

                          // ── CUISINE (FROM API) ─────────────────────────────────────
                          const CommonText(
                            text: AppString.cuisine,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F1F1F),
                            bottom: 12,
                          ),

                          const CuisineSection(),

                          Divider(color: const Color(0xffF1F1F1), height: 32.h),

                          // ── DIETARY PREFERENCES ────────────────────────────────────
                          const CommonText(
                            text: AppString.dietaryPreferences,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F1F1F),
                            bottom: 12,
                          ),

                          const DietaryPreferenceSection(),

                          // ── APPLY BUTTON ───────────────────────────────────────────
                        ],
                      ),
                    ),
                  ),
                  CommonButton(
                    titleText: AppString.apply,
                    onTap: () {
                      controller.applyFilters();
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

// ── TIME AVAILABILITY SECTION ──────────────────────────────────────────────
class TimeAvailabilitySection extends StatelessWidget {
  const TimeAvailabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final timeOptions = ['Today', 'This Week', 'Next Week', 'Next Month'];

    return GetBuilder<SearchController>(
      builder: (controller) {
        return SizedBox(
          height: 30.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeOptions.length,
            itemBuilder: (context, index) {
              final String value = timeOptions[index];
              return Obx(
                () => InkWell(
                  onTap: () {
                    final String mappedValue = _mapTimeToParam(value);
                    if (controller.selectedAvailability.contains(mappedValue)) {
                      controller.selectedAvailability.clear();
                    } else {
                      // Single select: clear and add new
                      controller.selectedAvailability.clear();
                      controller.selectedAvailability.add(mappedValue);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color:
                          _mapTimeToParam(value) ==
                                  (controller.selectedAvailability.isNotEmpty
                                      ? controller.selectedAvailability.first
                                      : '')
                              ? const Color(0xff272727)
                              : const Color(0xffEFEFEF),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      child: CommonText(
                        text: value,
                        fontSize: 12,
                        color:
                            _mapTimeToParam(value) ==
                                    (controller.selectedAvailability.isNotEmpty
                                        ? controller.selectedAvailability.first
                                        : '')
                                ? Colors.white
                                : const Color(0xff272727),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _mapTimeToParam(String timeOption) {
    switch (timeOption) {
      case 'Today':
        return 'today';
      case 'This Week':
        return 'this_week';
      case 'Next Week':
        return 'next_week';
      case 'Next Month':
        return 'next_month';
      default:
        return '';
    }
  }
}

// ── PROFESSIONAL LEVEL SECTION ─────────────────────────────────────────────
class ProfessionalLevelSection extends StatelessWidget {
  const ProfessionalLevelSection({super.key});

  @override
  Widget build(BuildContext context) {
    final levelOptions = [
      'Home Cook',
      'Professional Cook',
      'Restaurant Experience',
      'Michelin Star',
    ];

    return GetBuilder<SearchController>(
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                levelOptions.map((value) {
                  return Obx(
                    () => InkWell(
                      onTap: () {
                        if (controller.selectedProfessionalLevels.contains(
                          value,
                        )) {
                          controller.selectedProfessionalLevels.remove(value);
                        } else {
                          controller.selectedProfessionalLevels.add(value);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color:
                              controller.selectedProfessionalLevels.contains(
                                    value,
                                  )
                                  ? const Color(0xff272727)
                                  : const Color(0xffEFEFEF),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        child: CommonText(
                          text: value,
                          fontSize: 12,
                          color:
                              controller.selectedProfessionalLevels.contains(
                                    value,
                                  )
                                  ? Colors.white
                                  : const Color(0xff272727),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

// ── CUISINE SECTION (FROM API) ─────────────────────────────────────────────
class CuisineSection extends StatelessWidget {
  const CuisineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchController>();

    return Obx(() {
      if (controller.isLoadingCuisines.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(color: Color(0xffFD713F)),
          ),
        );
      }

      if (controller.cuisineList.isEmpty) {
        return const Center(
          child: CommonText(text: 'No cuisines available', fontSize: 12),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              controller.cuisineList.map((cuisine) {
                final cuisineId = cuisine.id ?? '';
                final cuisineName = cuisine.name ?? 'Unknown';

                return Obx(() {
                  final isSelected = controller.selectedCuisines.contains(
                    cuisineId,
                  );
                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        controller.selectedCuisines.remove(cuisineId);
                      } else {
                        controller.selectedCuisines.add(cuisineId);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color:
                            isSelected
                                ? const Color(0xff272727)
                                : const Color(0xffEFEFEF),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      child: CommonText(
                        text: cuisineName,
                        fontSize: 12,
                        color:
                            isSelected ? Colors.white : const Color(0xff272727),
                      ),
                    ),
                  );
                });
              }).toList(),
        ),
      );
    });
  }
}

// ── DIETARY PREFERENCE SECTION ─────────────────────────────────────────────
class DietaryPreferenceSection extends StatelessWidget {
  const DietaryPreferenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dietaryOptions = [
      'Vegetarian',
      'Non-Vegetarian',
      'Vegan',
      'Gluten Free',
      'Dairy Free',
    ];

    return GetBuilder<SearchController>(
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                dietaryOptions.map((value) {
                  return Obx(
                    () => InkWell(
                      onTap: () {
                        if (controller.selectedDietaryPrefs.contains(value)) {
                          controller.selectedDietaryPrefs.remove(value);
                        } else {
                          controller.selectedDietaryPrefs.add(value);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color:
                              controller.selectedDietaryPrefs.contains(value)
                                  ? const Color(0xff272727)
                                  : const Color(0xffEFEFEF),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        child: CommonText(
                          text: value,
                          fontSize: 12,
                          color:
                              controller.selectedDietaryPrefs.contains(value)
                                  ? Colors.white
                                  : const Color(0xff272727),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
