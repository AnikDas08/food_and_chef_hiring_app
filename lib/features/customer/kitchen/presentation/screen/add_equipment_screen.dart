import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../widgets/add_item.dart';

class AddEquipmentScreen extends StatefulWidget {
  const AddEquipmentScreen({super.key});

  @override
  State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {

  // Add this inside the _AddEquipmentScreenState class
  Widget buildProgressSection() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xFFF2F2F2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You’re Ready for Cooking',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff272727),
            ),
          ),
          SizedBox(height: 12.h),
          // Note: Ensure you have the percent_indicator package imported
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            barRadius: Radius.circular(30.r),
            lineHeight: 8.h,
            percent: 0.7,
            progressColor: const Color(0xffFD713F),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              text: "Your kitchen can handle ",
              style: TextStyle(color: const Color(0xff777777), fontSize: 12.sp),
              children: [
                TextSpan(
                  text: "100%",
                  style: TextStyle(
                    color: const Color(0xffFD713F),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " of recipes on the platform",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  List<Map<String, dynamic>> cookingItems = [
    {'name': 'Large pan', 'selected': true},
    {'name': 'Large pot', 'selected': false},
    {'name': 'Wok', 'selected': false},
    {'name': 'Roasting pan', 'selected': false},
    {'name': 'Frying pan', 'selected': true},
    {'name': 'Sauce pan', 'selected': false},
  ];

  List<Map<String, dynamic>> bankingItems = [
    {'name': 'Ledger', 'selected': true},
    {'name': 'Calculator', 'selected': false},
    {'name': 'Printer', 'selected': false},
    {'name': 'Cash Drawer', 'selected': false},
    {'name': 'POS Machine', 'selected': true},
    {'name': 'Checkbook', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                'Kitchen Equipment',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.sp),
              ),
              SizedBox(height: 28.h),
              buildProgressSection(),
              SizedBox(height: 32.h),
        
              ///================================ Cooking Equipment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cooking Equipment',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.keyboard_arrow_up),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              EquipmentGrid(
                items: cookingItems,
                onItemTap: (index) {
                  setState(() {
                    cookingItems[index]['selected'] =
                        !cookingItems[index]['selected'];
                  });
                },
                shrinkWrap: true,
              ),
              SizedBox(height: 32.h),
        
              /// ======================Banking Equipment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Banking Equipment',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xff272727),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.keyboard_arrow_up),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              EquipmentGrid(
                items: bankingItems,
                onItemTap: (index) {
                  setState(() {
                    bankingItems[index]['selected'] =
                        !bankingItems[index]['selected'];
                  });
                },
                shrinkWrap: true,
              ),
              SizedBox(height: 40.h),
        
              ///==============================add button
              InkWell(
                onTap: () {
                  Get.to(AddItemScreen());
                },
                child: Container(
                  height: 45.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      'Add Equipment',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

///======================================================= Equipment Grid Widget
class EquipmentGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final void Function(int index)? onItemTap;
  final bool shrinkWrap;

  const EquipmentGrid({
    super.key,
    required this.items,
    this.onItemTap,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      // scroll off
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            if (onItemTap != null) onItemTap!(index);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 109.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color:
                          item['selected'] ? Colors.black : Colors.grey[300]!,
                      width: 3,
                    ),
                  ),
                  child:
                      CommonImage(imageSrc: AppImages.large, size: 60).center,
                ),
              ),

              SizedBox(height: 8.h),
              Text(
                item['name'],
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
