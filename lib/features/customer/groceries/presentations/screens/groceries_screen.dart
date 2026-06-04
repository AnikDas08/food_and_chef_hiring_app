import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/button/icon_button.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/features/customer/groceries/presentations/screens/my_groceries_screen.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../services/api/api_service.dart';
import '../controller/grocerie_controller.dart';
import '../widgets/groceries_item.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroceryController());

    // Check if coming from booking history (has arguments)
    final bool fromBookingHistory = Get.arguments != null;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: fromBookingHistory,
        flexibleSpace: appBarOpacity(),
        actions: [
          LiquidGlassLayer(
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
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Color(0xff272727),
              ),
            );
          }

          final bool hasInitialId = controller.initialOrderId != null &&
              controller.initialOrderId!.isNotEmpty;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16.w,
              (fromBookingHistory && !hasInitialId) ? 10.h : 16.h,
              16.w,
              fromBookingHistory ? 30.h : 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. BOOKING LIST ---
                const CommonText(
                  text: '1. Select bookings for grocery delivery',
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

                SizedBox(height: 12.h),

                if (controller.basketItems.isNotEmpty)
                  const CommonText(
                    text: '2. Buy Ingredients',
                    color: Color(0xff272727),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),

                SizedBox(height: 12.h),

                // --- 3. GROCERY BASKET ---
                if (controller.basketItems.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.12),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                          text: 'Ingredients your chef needs',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff777777),
                          fontSize: 14,
                        ),
                        SizedBox(height: 12.h),
                        if (controller.isIngredientsLoading.value)
                          const Center(
                            child: CupertinoActivityIndicator(
                              color: Color(0xff272727),
                            ),
                          )
                        else
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.basketItems.length,
                            itemBuilder: (context, index) => GroceryItemTile(
                              data: controller.basketItems[index],
                              onTap: () => controller.toggleBasketItem(index),
                              isLast:
                                  index == controller.basketItems.length - 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 12.h),

                // --- Other personal groceries section ---
                if (controller.personalItems.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.12),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CommonText(
                              text: "Other personal groceries",
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xff777777),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await controller.clearPersonalItems();
                              },
                              child: Icon(
                                CupertinoIcons.delete,
                                color: const Color(0xff777777),
                                size: 18.r,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.personalItems.length,
                          itemBuilder: (context, index) {
                            final item = controller.personalItems[index];
                            return GroceryItemTile(
                              data: item,
                              onTap: () => controller.togglePersonalItem(index),
                              isLast:
                                  index == controller.personalItems.length - 1,
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: () =>
                              _showAddGroceryPopup(context, controller),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: const Icon(Icons.add,
                                    color: Color(0xff272727), size: 24),
                              ),
                              SizedBox(width: 12.w),
                              const CommonText(
                                text: 'Add groceries',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonText(
                        text: "Other personal groceries",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff777777),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => _showAddGroceryPopup(context, controller),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: const Icon(Icons.add,
                                  color: Color(0xff272727), size: 24),
                            ),
                            SizedBox(width: 12.w),
                            const CommonText(
                              text: 'Add groceries',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 12.h),

                if (controller.basketItems.isNotEmpty) ...[
                  CustomButtonIcon(
                    titleText: "Buy groceries online",
                    prefixImage: "assets/images/groceries_image.png",
                    buttonColor: const Color(0xff108910),
                    onTap: () => controller.createInstacartLink(),
                  ),
                  SizedBox(height: 12.h),
                  const CommonText(
                    text: '3. Confirm purchase of ingredients',
                    color: Color(0xff272727),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 12.h),
                  CommonButton(
                    titleText: "I’m ready for my chef visit",
                    onTap: () => controller.showConfirmationDialog(context),
                  ),
                ],

                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
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
          color: isSelected ? const Color(0xff272727) : const Color(0xffF2F2F2),
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

  void _showAddGroceryPopup(BuildContext context, GroceryController controller) {
    final TextEditingController ingredientController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    String selectedUnit = 'ounces';
    List<String> units = ['ounces'];
    bool isUnitsLoading = true;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            if (isUnitsLoading) {
              ApiService.get('menu/units').then((response) {
                if (response.statusCode == 200 &&
                    response.data['success'] == true) {
                  final List<String> fetchedUnits =
                  List<String>.from(response.data['data'] ?? []);
                  setState(() {
                    units = fetchedUnits;
                    selectedUnit = fetchedUnits.contains('ounces')
                        ? 'ounces'
                        : fetchedUnits.first;
                    isUnitsLoading = false;
                  });
                }
              }).catchError((_) {
                setState(() => isUnitsLoading = false);
              });
              isUnitsLoading = false;
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CommonText(
                          text: 'Add Items',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close,
                              color: Color(0xff272727), size: 22),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Ingredient field
                    TextField(
                      controller: ingredientController,
                      decoration: InputDecoration(
                        hintText: 'Ingredient',
                        hintStyle: TextStyle(
                            color: const Color(0xff777777), fontSize: 14.sp),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Quantity field
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Quantity (e.g. 200)',
                        hintStyle: TextStyle(
                            color: const Color(0xff777777), fontSize: 14.sp),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Unit dropdown
                    isUnitsLoading
                        ? Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xff272727)),
                          ),
                          SizedBox(width: 12),
                          CommonText(
                              text: 'Loading units...',
                              fontSize: 14,
                              color: Color(0xff777777)),
                        ],
                      ),
                    )
                        : DropdownButtonFormField<String>(
                      value: selectedUnit,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Color(0xff272727)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                      ),
                      style: TextStyle(
                          color: const Color(0xff272727), fontSize: 14.sp),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 250.h,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                      items: units
                          .map((unit) => DropdownMenuItem(
                          value: unit, child: Text(unit)))
                          .toList(),
                    ),

                    SizedBox(height: 20.h),

                    // Add button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = ingredientController.text.trim();
                          final quantity = quantityController.text.trim();

                          if (name.isEmpty || quantity.isEmpty) {
                            // show simple validation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Color(0xff272727),
                              ),
                            );
                            return;
                          }

                          // Save to Hive via controller
                          await controller.addPersonalItem(
                            name: name,
                            quantity: quantity,
                            unit: selectedUnit,
                          );

                          Navigator.pop(context); // close popup
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff272727),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r)),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                        ),
                        child: const CommonText(
                          text: 'Add',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
                color: isSelected ? const Color(0xffFD713F) : Colors.grey,
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