import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/features/customer/groceries/presentations/screens/my_groceries_screen.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/grocerie_controller.dart';
import '../widgets/groceries_item.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      GroceryController(),
      tag: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // Check if coming from booking history (has arguments)
    final bool fromBookingHistory = Get.arguments != null;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: fromBookingHistory,

      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: fromBookingHistory,
        flexibleSpace: appBarOpacity(),
        actions: [LiquidGlassLayer(
          child: LiquidGlass(
            shape: const LiquidRoundedSuperellipse(borderRadius: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
        title: const CommonText(
          text: 'Groceries',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        final bool hasInitialId =
            controller.initialOrderId != null &&
            controller.initialOrderId!.isNotEmpty;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, fromBookingHistory ? 100.h : 16.h, 16.w, fromBookingHistory ? 30.h : 16.h),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. BOOKING LIST ---
                const CommonText(
                  text: 'Select bookings for grocery delivery',
                  color: Color(0xff272727),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 12.h),
                if (hasInitialId)
                  _buildSingleOrderView(controller)
                else if (controller.availableOrders.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const CommonText(
                        text: 'No pending bookings available',
                        color: AppColors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                else
                  _buildFullListView(controller),
            
                SizedBox(height: 24.h),
            
                // --- 2. PARTNER SELECTION (RESTORED LOGIC) ---
                const CommonText(
                  text: 'Choose your grocery delivery partner',
                  color: Color(0xff272727),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 6.h),
                const CommonText(
                  text: 'Order groceries for your booking',
                  color: Color(0xff777777),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
            
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      _partnerIcon(
                        label: 'Instacart',
                        iconPath: 'assets/images/intacart.png',
                        isSelected:
                            controller.selectedPartner.value == 'Instacart',
                        onTap: () {
                          controller.selectedPartner.value = 'Instacart';
                          controller
                              .createInstacartLink(); // CALLS API IMMEDIATELY
                        },
                      ),
                      SizedBox(width: 20.w),
                      _partnerIcon(
                        label: 'Get your own\ngroceries',
                        icon: Icons.directions_walk,
                        isSelected: controller.selectedPartner.value == 'Self',
                        onTap: () => controller.selectedPartner.value = 'Self',
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 24.h),
            
                // --- 3. GROCERY BASKET ---
                if (controller.basketItems.isNotEmpty)
                  const CommonText(
                    text: 'Edit your grocery basket',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    fontSize: 16,
                  ),
                SizedBox(height: 12.h),
            
                if (controller.isIngredientsLoading.value)
                  const Center(
                    child: CupertinoActivityIndicator(),
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.basketItems.length,
                    itemBuilder:
                        (context, index) => GroceryItemTile(
                          data: controller.basketItems[index],
                          onTap: () => controller.toggleBasketItem(index),
                          isLast: index == controller.basketItems.length - 1,
                        ),
                  ),

                SizedBox(height: 20.h,),
                // --- 4. BOTTOM BUTTON ---
                if (controller.isInstacartLoading.value)
                  const Center(
                    child: CupertinoActivityIndicator(),
                  )
                else if (controller.basketItems.isNotEmpty)
                  CommonButton(
                    titleText: 'Add to Cart',
                    onTap: () {
                      // We send the list of selected IDs to the next screen
                      if (controller.selectedOrderIds.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConfirmedGroceryScreen(),
                            settings: RouteSettings(
                              arguments:
                                  controller.selectedOrderIds
                                      .toList(), // same as Get.arguments
                            ),
                          ),
                        );
                      } else {
                        Get.snackbar(
                          'Selection Required',
                          'Please select at least one booking.',
                        );
                      }
                    },
                  ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- Helper Methods using your SAME designs ---

  Widget _buildSingleOrderView(GroceryController controller) {
    final order = controller.availableOrders.firstWhere(
      (e) => e['_id'] == controller.initialOrderId,
      orElse: () => {},
    );
    if (order.isEmpty) return const SizedBox();
    return _buildBookingCard(order: order, isSelected: true, onTap: () {}, isLast: true);
  }

  Widget _buildFullListView(GroceryController controller) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.availableOrders.length,
      itemBuilder: (context, index) {
        final order = controller.availableOrders[index];
        final bool isLast = index == controller.availableOrders.length - 1;
        return _buildBookingCard(
          order: order,
          isSelected: controller.selectedOrderIds.contains(order['_id']),
          onTap: () => controller.toggleOrderSelection(order['_id']),
          isLast: isLast,
        );
      },
    );
  }

  Widget _buildBookingCard({
    required Map<String, dynamic> order,
    required bool isSelected,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final chef = order['chef'] ?? {};
    final List staticItems = order['static_items'] as List? ?? [];

    // 1. Extract the first image from each menu item in static_items
    final List<String> recipeImages = [];
    for (var item in staticItems) {
      final menu = item['menu'] ?? {};
      final List images = menu['images'] as List? ?? [];
      if (images.isNotEmpty && images[0] != null) {
        recipeImages.add(images[0].toString());
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff272727) : const Color(0xffffffff),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.white : Color(0xff777777),
              size: 22,
            ),
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(
                (chef['image'] != null && chef['image'].toString().startsWith('http'))
                    ? chef['image'].toString()
                    : ApiEndPoint.imageUrl + (chef['image'] ?? ''),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: chef['name'] ?? 'Unknown Chef',
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xff272727),
                  ),
                  CommonText(
                    text:
                        "${staticItems.length} Recipe • ${order['order_id'] ?? ''}",
                    color: isSelected ? Colors.white : Color(0xff777777),
                    fontSize: 12,
                  ),
                ],
              ),
            ),

            // --- 2. CONDITIONAL IMAGE SECTION ---
            // Only show this block if there are images available
            if (recipeImages.isNotEmpty)
              Row(
                children: [
                  // Show max 2 images
                  ...recipeImages
                      .take(2)
                      .map(
                        (imageUrl) => Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              imageUrl.startsWith('http')
                                  ? imageUrl
                                  : ApiEndPoint.imageUrl + imageUrl,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const SizedBox.shrink(), // Hide if URL fails
                            ),
                          ),
                        ),
                      ),

                  // 3. Show "more" count only if recipes exceed the 2 displayed images
                  if (staticItems.length > 2)
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Container(
                        width: 45.w,
                        height: 40.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: CommonText(
                          text: '${staticItems.length - 2} more\nitems',
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _partnerIcon({
    required String label,
    String? iconPath,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected
                      ? const Color(0xff272727).withOpacity(0.1)
                      : const Color(0xffF5F5F5),
              border:
                  isSelected
                      ? Border.all(color: const Color(0xff272727), width: 2)
                      : null,
            ),
            child: Center(
              child:
                  icon != null
                      ? Icon(
                        icon,
                        color:
                            isSelected ? const Color(0xffFD713F) : Colors.grey,
                      )
                      : (iconPath != null
                          ? Image.asset(iconPath, width: 30.w)
                          : const SizedBox()),
            ),
          ),
          SizedBox(height: 8.h),
          CommonText(
            text: label,
            fontSize: 11,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ],
      ),
    );
  }
}
