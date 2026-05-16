import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: appBarOpacity(),
        title: const CommonText(
          text: "My groceries",
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            const CommonText(
              text: 'Your groceries will appear here once you have a confirmed upcoming booking with a chef',
              maxLines: 2,
              color: Color(0xff777777),
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),

            // --- UI Note: Showing the IDs for your reference ---
            if (controller.receivedOrderIds.isNotEmpty) ...[
              SizedBox(height: 10.h),
              CommonText(
                text: 'Selected Orders: ${controller.receivedOrderIds.length}',
                color: const Color(0xffFD713F),
                fontWeight: FontWeight.w600,
              ),
            ],

            SizedBox(height: 32.h),
            const CommonText(
              text: 'Choose your grocery delivery partner',
              color: Color(0xff272727),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            SizedBox(height: 4.h),
            const CommonText(
                text: 'Order groceries for your booking',
                color: Color(0xff777777),
                fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 24.h),

            Obx(() => _buildPartnerIcon(
              name: 'Instacart',
              imagePath: 'assets/images/intacart.png', // Corrected path to match your asset
              isSelected: controller.selectedPartner.value == 'Instacart',
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
              border: isSelected ? Border.all(color: const Color(0xff272727), width: 2) : null,
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
            color: isSelected ? Color(0xff272727) : Color(0xff777777),
          ),
        ],
      ),
    );
  }
}