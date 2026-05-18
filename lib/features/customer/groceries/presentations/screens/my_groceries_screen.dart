import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../controller/my_grocerires_controller.dart';
import '../widgets/groceries_item.dart';

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
          text: "My shopping list",
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              const CommonText(
                text: 'Ingredients your chef needs',
                color: Color(0xff272727),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              SizedBox(height: 16.h),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.isIngredientsLoading.value)
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: const Center(child: CircularProgressIndicator(color: Color(0xffFD713F))),
                    )
                  else if (controller.basketItems.isNotEmpty) ...[
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.basketItems.length,
                      itemBuilder: (context, index) => GroceryItemTile(
                        data: controller.basketItems[index],
                        onTap: () => controller.toggleBasketItem(index),
                        isLast: index == controller.basketItems.length - 1,
                      ),
                    ),
                  ],
                ],
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.basketItems.isNotEmpty && !controller.isIngredientsLoading.value) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: CommonButton(
              titleText: "I got my groceries",
              onTap: () {
                controller.showConfirmationDialog(context);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      }),
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