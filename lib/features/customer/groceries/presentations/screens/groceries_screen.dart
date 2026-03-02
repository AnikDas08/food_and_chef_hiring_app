import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/groceries/presentations/controller/my_grocerires_controller.dart';
import 'package:new_untitled/features/customer/groceries/presentations/screens/my_groceries_screen.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/grocerie_controller.dart';
import '../widgets/groceries_item.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonText(text: "My groceries", fontSize: 24, fontWeight: FontWeight.bold),
              SizedBox(height: 16.h),
              const CommonText(text: "Select bookings for grocery delivery", color: Colors.grey),

              // Multi-Select Booking Cards
              Obx(() => Column(
                children: List.generate(controller.bookingList.length, (index) {
                  return _buildBookingCard(
                    index: index,
                    controller: controller,
                    data: controller.bookingList[index],
                  );
                }),
              )),

              SizedBox(height: 24.h),
              const CommonText(text: "Choose your grocery delivery partner", fontWeight: FontWeight.bold),
              const CommonText(text: "Order groceries for your booking", color: Colors.grey, fontSize: 12),

              _buildPartnerSelection(controller),

              SizedBox(height: 24.h),
              const CommonText(text: "Edit your grocery basket", fontWeight: FontWeight.bold),

              Obx(() => controller.basketItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.basketItems.length,
                itemBuilder: (context, index) => GroceryItemTile(
                  data: controller.basketItems[index],
                  onTap: () => controller.toggleBasketItem(index),
                ),
              )),

              SizedBox(height: 24.h),
              const CommonText(text: "Ingredients You Might Have", fontWeight: FontWeight.bold),
              Obx(() => controller.suggestedItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.suggestedItems.length,
                itemBuilder: (context, index) => GroceryItemTile(
                  data: controller.suggestedItems[index],
                  onTap: () => controller.toggleSuggestItem(index),
                ),
              )),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CommonButton(
                  titleText: "Add to Cart",
                  onTap: () {
                    Get.to(()=>ConfirmedGroceryScreen());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard({required int index, required GroceryController controller, required Map<String, dynamic> data}) {
    // Check if index exists in the list for multi-selection
    bool isSelected = controller.selectedBookingIndexes.contains(index);

    return GestureDetector(
      onTap: () => controller.toggleBookingSelection(index),
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected ? Border.all(color: Colors.black.withOpacity(0.15), width: 1) : null,
        ),
        child: Row(
          children: [
            // Icon changes based on multi-selection
            Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Colors.black : Colors.grey[400],
                size: 20
            ),
            SizedBox(width: 12.w),

            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(data['userImg']),
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(text: data['name'], fontWeight: FontWeight.bold, fontSize: 14),
                  CommonText(text: data['recipe'], color: Colors.grey, fontSize: 12),
                ],
              ),
            ),

            Row(
              children: [
                ...List.generate(data['images'].length, (i) => Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: _recipeThumb(data['images'][i]),
                )),
                CommonText(text: "${data['more']} more\nitems", fontSize: 10, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _recipeThumb(String url) {
    return Container(
      width: 35.w,
      height: 35.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
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
            onTap: () => controller.selectedPartner.value = "Instacart",
          ),
          SizedBox(width: 20.w),
          _partnerIcon(
            label: "Get your own\ngroceries",
            icon: Icons.directions_walk,
            isSelected: controller.selectedPartner.value == "Self",
            onTap: () => controller.selectedPartner.value = "Self",
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
              color: isSelected ? Colors.green.withOpacity(0.1) : const Color(0xffF5F5F5),
              border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, color: isSelected ? Colors.green : Colors.grey)
                  : (iconPath != null ? Image.asset(iconPath, width: 30.w) : const SizedBox()),
            ),
          ),
          SizedBox(height: 8.h),
          CommonText(
              text: label,
              fontSize: 11,
              textAlign: TextAlign.center,
              maxLines: 2,
              color: isSelected ? Colors.black : Colors.grey
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            const Icon(Icons.shopping_basket_outlined, size: 50, color: Colors.grey),
            const CommonText(text: "Your basket is empty", color: Colors.grey),
          ],
        ),
      ),
    );
  }
}