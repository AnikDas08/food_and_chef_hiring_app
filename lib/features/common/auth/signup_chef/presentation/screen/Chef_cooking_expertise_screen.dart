import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CafeCookingExpertiseScreen extends StatefulWidget {
  const CafeCookingExpertiseScreen({super.key});

  @override
  State<CafeCookingExpertiseScreen> createState() =>
      _CafeCookingExpertiseScreenState();
}

class _CafeCookingExpertiseScreenState
    extends State<CafeCookingExpertiseScreen> {


  final List<String> _allCuisines = [
    "Chinese",
    "Italian",
    "American",
    "Indian",
    "Japanese",
    "Mexican",
    "Thai",
    "French",
    "Greek",
    "Turkish",
  ];


  final List<String> _selected = ["Chinese", "Italian"];


  bool _dropdownOpen = false;

  void _toggleCuisine(String cuisine) {
    setState(() {
      if (_selected.contains(cuisine)) {
        _selected.remove(cuisine);
      } else {
        _selected.add(cuisine);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Back Button ──
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: const Color(0xFF272727),
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    Text(
                      "Cooking Expertise",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF272727),
                        letterSpacing: -0.5,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      "Define your speciality cuisine.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                    24.verticalSpace,

                    // ── Label ──
                    Text(
                      "Cuisines",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF272727),
                      ),
                    ),
                    10.verticalSpace,

                    // ── Dropdown Container ──
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          // ── Header row (selected chips + arrow) ──
                          GestureDetector(
                            onTap: () =>
                                setState(() => _dropdownOpen = !_dropdownOpen),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 10.h),
                              child: Row(
                                children: [
                                  // Selected chips
                                  Expanded(
                                    child: _selected.isEmpty
                                        ? Text(
                                      "Select cuisines",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xFFBBBBBB),
                                      ),
                                    )
                                        : Wrap(
                                      spacing: 6.w,
                                      runSpacing: 6.h,
                                      children: _selected
                                          .map((c) => _Chip(label: c))
                                          .toList(),
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  Icon(
                                    _dropdownOpen
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 20.sp,
                                    color: const Color(0xFF272727),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ── Dropdown List ──
                          if (_dropdownOpen) ...[
                            Divider(
                                height: 1,
                                color: Colors.grey.shade200),
                            ..._allCuisines.map((cuisine) {
                              final isSelected = _selected.contains(cuisine);
                              return GestureDetector(
                                onTap: () => _toggleCuisine(cuisine),
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 14.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        cuisine,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                          color: const Color(0xFF272727),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (isSelected)
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF272727),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14.sp,
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: const Color(0xFFCCCCCC),
                                                width: 1.5),
                                          ),
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
              ),
            ),

            // ── Continue Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selected.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please select at least one cuisine")),
                      );
                      return;
                    }
                    Get.back(result: {'cuisines': _selected});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
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