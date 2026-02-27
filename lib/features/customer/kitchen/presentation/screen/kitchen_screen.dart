import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Assuming these are your specific project paths - update if names differ
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import 'package:new_untitled/config/route/app_routes.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenEquipmentScreenState();
}

class _KitchenEquipmentScreenState extends State<KitchenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF272727), size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              CommonText(
                text: 'Kitchen Equipment',
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF272727),
              ),

              SizedBox(height: 24.h),

              // Progress Section Logic
              buildProgressSection(),

              SizedBox(height: 24.h),

              Text(
                'My Equipment',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF272727),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 16.h),

              // Equipment List
              Expanded(
                child: ListView.separated(
                  itemCount: 10,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16.h),
                  itemBuilder: (context, index) {
                    return _buildEquipmentCard();
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                ),
              ),

              // Bottom Button
              _buildAddButton(),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- PROGRESS SECTION COMPONENT ---
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
          CommonText(
            text: 'You’re Ready for Cooking',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff272727),
          ),
          SizedBox(height: 12.h),
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

  // --- EQUIPMENT CARD COMPONENT ---
  Widget _buildEquipmentCard() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFF2F2F2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Extra Long Professional \nSilicone Oven Mitt Set',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF272727),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      '128 g',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777)),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Stainless Steel',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF777777)),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: const Color(0xFFDBEBD9),
                  ),
                  child: Text(
                    'Your Kitchen is Ready',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF2F8328),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          CommonImage(
            imageSrc: AppImages.dietary,
            size: 120.r,
          ),
        ],
      ),
    );
  }

  // --- ADD BUTTON COMPONENT ---
  Widget _buildAddButton() {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.addEquipment),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 52.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color(0xff272727),
        ),
        child: Center(
          child: Text(
            'Add Equipment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}