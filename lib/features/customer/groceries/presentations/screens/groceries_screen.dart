import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/features/customer/groceries/presentations/screens/my_groceries_screen.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/grocerie_controller.dart';
import '../widgets/groceries_item.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroceryController(), tag: DateTime.now().millisecondsSinceEpoch.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const CommonText(text: "Groceries", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffFD713F)));
        }

        bool hasInitialId = controller.initialOrderId != null && controller.initialOrderId!.isNotEmpty;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                const CommonText(text: "My groceries", fontSize: 24, fontWeight: FontWeight.bold),
                SizedBox(height: 8.h),

                // --- 1. BOOKING LIST (SINGLE vs ALL) ---
                if (hasInitialId) ...[
                  const CommonText(text: "Ordering for this booking", color: Colors.grey),
                  SizedBox(height: 16.h),
                  _buildSingleOrderView(controller),
                ] else ...[
                  const CommonText(text: "Select bookings for grocery delivery", color: Colors.grey),
                  SizedBox(height: 16.h),
                  _buildFullListView(controller),
                ],

                SizedBox(height: 24.h),

                // --- 2. PARTNER SELECTION (RESTORED LOGIC) ---
                const CommonText(text: "Choose your grocery delivery partner", fontWeight: FontWeight.bold),
                const CommonText(text: "Order groceries for your booking", color: Colors.grey, fontSize: 12),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      _partnerIcon(
                        label: "Instacart",
                        iconPath: "assets/images/intacart.png",
                        isSelected: controller.selectedPartner.value == "Instacart",
                        onTap: () {
                          controller.selectedPartner.value = "Instacart";
                          controller.createInstacartLink(); // CALLS API IMMEDIATELY
                        },
                      ),
                      SizedBox(width: 20.w),
                      _partnerIcon(
                        label: "Get your own\ngroceries",
                        icon: Icons.directions_walk,
                        isSelected: controller.selectedPartner.value == "Self",
                        onTap: () => controller.selectedPartner.value = "Self",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // --- 3. GROCERY BASKET ---
                const CommonText(text: "Edit your grocery basket", fontWeight: FontWeight.bold),
                SizedBox(height: 12.h),

                if (controller.isIngredientsLoading.value)
                  const Center(child: CircularProgressIndicator(color: Color(0xffFD713F)))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.basketItems.length,
                    itemBuilder: (context, index) => GroceryItemTile(
                      data: controller.basketItems[index],
                      onTap: () => controller.toggleBasketItem(index),
                    ),
                  ),

                SizedBox(height: 40.h),

                // --- 4. BOTTOM BUTTON ---
                if (controller.isInstacartLoading.value)
                  const Center(child: CircularProgressIndicator(color: Color(0xffFD713F)))
                else
                  CommonButton(
                    titleText: "Add to Cart",
                    onTap: () {
                      Get.to(()=>ConfirmedGroceryScreen());
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
    final order = controller.availableOrders.firstWhere((e) => e['_id'] == controller.initialOrderId, orElse: () => {});
    if (order.isEmpty) return const SizedBox();
    return _buildBookingCard(order: order, isSelected: true, onTap: () {});
  }

  Widget _buildFullListView(GroceryController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.availableOrders.length,
      itemBuilder: (context, index) {
        final order = controller.availableOrders[index];
        return _buildBookingCard(
          order: order,
          isSelected: controller.selectedOrderIds.contains(order['_id']),
          onTap: () => controller.toggleOrderSelection(order['_id']),
        );
      },
    );
  }

  Widget _buildBookingCard({required Map<String, dynamic> order, required bool isSelected, required VoidCallback onTap}) {
    final chef = order['chef'] ?? {};
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected ? Border.all(color: const Color(0xffFD713F), width: 1.5) : null,
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? const Color(0xffFD713F) : Colors.grey[400], size: 22),
            SizedBox(width: 12.w),
            CircleAvatar(radius: 20.r, backgroundImage: NetworkImage(chef['image'] ?? "")),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(text: chef['name'] ?? "", fontWeight: FontWeight.bold, fontSize: 14),
                  CommonText(text: "Order ID: ${order['order_id'] ?? ''}", color: Colors.grey, fontSize: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _partnerIcon({required String label, String? iconPath, IconData? icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xffFD713F).withOpacity(0.1) : const Color(0xffF5F5F5),
              border: isSelected ? Border.all(color: const Color(0xffFD713F), width: 2) : null,
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, color: isSelected ? const Color(0xffFD713F) : Colors.grey)
                  : (iconPath != null ? Image.asset(iconPath, width: 30.w) : const SizedBox()),
            ),
          ),
          SizedBox(height: 8.h),
          CommonText(text: label, fontSize: 11, textAlign: TextAlign.center, color: isSelected ? Colors.black : Colors.grey),
        ],
      ),
    );
  }
}