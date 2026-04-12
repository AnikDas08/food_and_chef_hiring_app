import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/my_grocerires_controller.dart';

class ConfirmedGroceryScreen extends StatelessWidget {
  const ConfirmedGroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller - it will automatically pick up the arguments
    final controller = Get.put(ConfirmedGroceryController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
                text: "My groceries",
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
            SizedBox(height: 12.h),
            const CommonText(
              text: "Your groceries will appear here once you have a confirmed upcoming booking with a chef",
              maxLines: 2,
              color: Colors.grey,
              fontSize: 14,
              textAlign: TextAlign.start,
            ),

            // --- UI Note: Showing the IDs for your reference ---
            if (controller.receivedOrderIds.isNotEmpty) ...[
              SizedBox(height: 10.h),
              CommonText(
                text: "Selected Orders: ${controller.receivedOrderIds.length}",
                color: const Color(0xffFD713F),
                fontWeight: FontWeight.w600,
              ),
            ],

            SizedBox(height: 32.h),
            const CommonText(
              text: "Choose your grocery delivery partner",
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            SizedBox(height: 4.h),
            const CommonText(
                text: "Order groceries for your booking",
                color: Colors.grey,
                fontSize: 12
            ),
            SizedBox(height: 24.h),

            Obx(() => _buildPartnerIcon(
              name: "Instacart",
              imagePath: "assets/images/intacart.png", // Corrected path to match your asset
              isSelected: controller.selectedPartner.value == "Instacart",
              controller: controller,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerIcon({
    required String name,
    required String imagePath,
    required bool isSelected,
    required ConfirmedGroceryController controller,
  }) {
    return GestureDetector(
      onTap: () {
        controller.selectedPartner.value = name;
        controller.showConfirmationDialog(Get.context!);
      },
      child: Column(
        children: [
          Container(
            width: 75.w,
            height: 75.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffF5F5F5),
              border: isSelected ? Border.all(color: const Color(0xffFD713F), width: 2) : null,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 40.w,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.shopping_cart, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          CommonText(
            text: name,
            fontSize: 12,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ],
      ),
    );
  }
}