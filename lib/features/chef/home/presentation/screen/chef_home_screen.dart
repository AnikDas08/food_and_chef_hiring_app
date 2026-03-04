import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/features/chef/home/presentation/widgets/chef_home_appbar.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import '../controller/chef_home_controller.dart';
import '../widgets/request_item.dart';

class ChefHomeScreen extends StatelessWidget {

  const ChefHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: ChefHomeAppBar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ).copyWith(bottom: 0),
        child: ListView(
          children: [
            Obx(() {
              final c = Get.find<ChefHomeController>();
              return ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: Get.width,
                  color: const Color(0xff1E1E1E),
                  child: Stack(
                    children: [
                      // Wave circles
                      Positioned(
                        right: -30,
                        bottom: -20,
                        child: Container(
                          width: 160.w,
                          height: 160.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 60,
                        bottom: -40,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 18.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current Balance",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white60,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "\$${c.walletBalance.value.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 34.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(Icons.north_east,
                                        color: const Color(0xff4CAF50),
                                        size: 13.sp),
                                    SizedBox(width: 3.w),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "0.48%",
                                            style: TextStyle(
                                              color: const Color(0xff4CAF50),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " higher than last month",
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              child: InkWell(
                                onTap: (){

                                  Get.toNamed(AppRoutes.chefPayment);

                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: Colors.black,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Cash Out",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            32.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: AppString.requestedBookings,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),
                InkWell(
                  onTap: () {
                    Get.offAndToNamed(AppRoutes.chefHomeScreen, arguments: {"index": 2});
                  },
                  child: CommonText(
                    text: AppString.seeAll,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffFD713F),
                  ),
                ),
              ],
            ),

            Obx(() {
              final c = Get.find<ChefHomeController>();
              if (c.isLoadingBookings.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.requestedBookings.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Text(
                      "No requested bookings",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: c.requestedBookings.length,
                itemBuilder: (context, index) {
                  return requestItem(context, c.requestedBookings[index], isRequested: true);
                },
              );
            }),
            32.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: "Upcoming Bookings",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                ),
                InkWell(
                  onTap: () {
                    Get.offAndToNamed(AppRoutes.chefHomeScreen, arguments: {"index": 2});
                  },

                  child: InkWell(
                    child: CommonText(
                      text: AppString.seeAll,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffFD713F),
                    ),
                  ),
                ),
              ],
            ),

            Obx(() {
              final c = Get.find<ChefHomeController>();
              if (c.isLoadingUpcoming.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.upcomingBookings.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Text(
                      "No upcoming bookings",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: c.upcomingBookings.length,
                itemBuilder: (context, index) {
                  return requestItem(context, c.upcomingBookings[index]);
                },
              );
            }),


          ],
        ),
      ),
    );
  }
}
