import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/grocerie_controller.dart';
import '../widgets/groceries_item.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(GroceryController());

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
        // Global Loading State (Initial Fetch)
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffFD713F)));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const CommonText(text: "My groceries", fontSize: 24, fontWeight: FontWeight.bold),
              SizedBox(height: 8.h),
              const CommonText(text: "Select bookings for grocery delivery", color: Colors.grey),
              SizedBox(height: 16.h),

              // --- 1. LIST OF AVAILABLE ORDERS ---
              if (controller.availableOrders.isEmpty)
                _buildEmptyState("No confirmed bookings found", Icons.calendar_today_outlined)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.availableOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.availableOrders[index];
                    final String orderId = order['_id'] ?? "";
                    final bool isSelected = controller.selectedOrderIds.contains(orderId);

                    return _buildBookingCard(
                      order: order,
                      isSelected: isSelected,
                      onTap: () => controller.toggleOrderSelection(orderId),
                    );
                  },
                ),

              SizedBox(height: 24.h),

              // --- 2. PARTNER SELECTION ---
              const CommonText(text: "Choose your grocery delivery partner", fontWeight: FontWeight.bold),
              const CommonText(text: "Order groceries for your booking", color: Colors.grey, fontSize: 12),
              _buildPartnerSelection(controller),

              SizedBox(height: 24.h),

              // --- 3. DYNAMIC GROCERY BASKET ---
              const CommonText(text: "Edit your grocery basket", fontWeight: FontWeight.bold),
              SizedBox(height: 12.h),

              if (controller.isIngredientsLoading.value)
                const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Color(0xffFD713F)),
                ))
              else if (controller.selectedOrderIds.isEmpty)
                _buildEmptyState("Select an order above to see ingredients", Icons.shopping_cart_outlined)
              else if (controller.basketItems.isEmpty)
                  _buildEmptyState("No ingredients found for this order", Icons.info_outline)
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

              CommonButton(
                titleText: "Add to Cart",
                onTap: () {
                  // Filter only selected items to send to the next screen or API
                  final selectedIngs = controller.basketItems.where((e) => e['isSelected']).toList();
                  debugPrint("Adding to cart: ${selectedIngs.length} items");
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBookingCard({
    required Map<String, dynamic> order,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final chef = order['chef'] ?? {};
    final staticItems = order['static_items'] as List? ?? [];

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
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? const Color(0xffFD713F) : Colors.grey[400],
              size: 22,
            ),
            SizedBox(width: 12.w),
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(chef['image'] ?? ""),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(text: chef['name'] ?? "Unknown Chef", fontWeight: FontWeight.bold, fontSize: 14),
                  CommonText(text: "${staticItems.length} Recipes • ${order['order_id'] ?? ''}", color: Colors.grey, fontSize: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerSelection(GroceryController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Obx(() => Row(
        children: [
          _partnerIcon(
            label: "Instacart",
            iconPath: "assets/images/intacart.png",
            isSelected: controller.selectedPartner.value == "Instacart",
            onTap: () {
              controller.selectedPartner.value = "Instacart";
              controller.createInstacartLink(); // Trigger API Call
            },
          ),
          SizedBox(width: 20.w),
          _partnerIcon(
            label: "Get your own\ngroceries",
            icon: Icons.directions_walk,
            isSelected: controller.selectedPartner.value == "Self",
            onTap: () {
              controller.selectedPartner.value = "Self";
              // Handle self-shopping logic if needed
            },
          ),
        ],
      )),
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
                  : (iconPath != null ? Image.asset(iconPath, width: 30.w, errorBuilder: (c, e, s) => const Icon(Icons.shopping_cart)) : const SizedBox()),
            ),
          ),
          SizedBox(height: 8.h),
          CommonText(
            text: label,
            fontSize: 11,
            textAlign: TextAlign.center,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.grey[400]),
          SizedBox(height: 10.h),
          CommonText(text: message, color: Colors.grey, fontSize: 13, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}