import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../controller/Chef_Order_History_Controller.dart';
import '../widgets/chef_Booking_Details.dart';

class ChefOrderHistoryScreen extends StatelessWidget {
  const ChefOrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ChefOrderHistoryController>()
        ? Get.find<ChefOrderHistoryController>()
        : Get.put(ChefOrderHistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Booking History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xff272727), size: 18),
        ),
      ),
      body: Column(
        children: [
          // ===== Status Tabs =====
          _buildTabs(controller),

          // ===== Order List =====
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xffFD713F)),
                );
              }

              if (controller.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 60.sp, color: Colors.grey[300]),
                      16.height,
                      Text(
                        'No orders found',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    controller.fetchOrders(loadMore: true);
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: controller.orders.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.orders.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                              color: Color(0xffFD713F)),
                        ),
                      );
                    }
                    final order = controller.orders[index];
                    return _buildCard(context, order, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===== Tabs =====
  Widget _buildTabs(ChefOrderHistoryController controller) {
    return Container(
      color: Colors.white,
      child: Obx(
            () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: controller.statusTabs.map((tab) {
              final isSelected = controller.selectedStatus.value == tab;
              return GestureDetector(
                onTap: () => controller.changeTab(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xffFD713F)
                        : const Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xff777777),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ===== Order Card =====
  Widget _buildCard(
      BuildContext context,
      Map<String, dynamic> order,
      ChefOrderHistoryController controller,
      ) {
    final status = order['status'] ?? '';
    final statusStyle = controller.getStatusStyle(status);
    final user = order['user'] as Map<String, dynamic>? ?? {};
    final items = order['static_items'] as List? ?? [];
    final priceBreakdown = order['price_breakdown'] as Map<String, dynamic>? ?? {};
    final cancelReason = order['cancel_reason'];
    final declineReason = order['decline_reason'];

    return GestureDetector(
      onTap: () {
        controller.selectOrder(order);
        chefBookingDetailsSheet(context, order, controller);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== Header =====
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user['image'] ?? '',
                    width: 44.w,
                    height: 44.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44.w,
                      height: 44.w,
                      color: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.grey[400]),
                    ),
                  ),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff272727),
                        ),
                      ),
                      Text(
                        order['order_id'] ?? '',
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xff777777)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusStyle['bg'],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: statusStyle['color'],
                    ),
                  ),
                ),
              ],
            ),

            12.height,
            Divider(color: Colors.grey[100], height: 1),
            12.height,

            // ===== Date & Time =====
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Color(0xffFD713F)),
                6.width,
                Text(
                  controller.formatDate(order['formatted_date']),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff272727)),
                ),
                16.width,
                const Icon(Icons.access_time, size: 14, color: Color(0xffFD713F)),
                6.width,
                Text(
                  order['strTime'] ?? '',
                  style: TextStyle(
                      fontSize: 12.sp, color: const Color(0xff777777)),
                ),
              ],
            ),

            8.height,

            // ===== Address =====
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Color(0xffFD713F)),
                6.width,
                Expanded(
                  child: Text(
                    order['formatted_address'] ?? '',
                    style: TextStyle(
                        fontSize: 12.sp, color: const Color(0xff777777)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            8.height,

            // ===== Items =====
            if (items.isNotEmpty)
              Text(
                '${items.length} item${items.length > 1 ? 's' : ''}: ${(items.first['menu'] as Map?)?['name'] ?? ''}${items.length > 1 ? '...' : ''}',
                style: TextStyle(
                    fontSize: 12.sp, color: const Color(0xff777777)),
              ),

            8.height,

            // ===== Total =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff272727)),
                ),
                Text(
                  controller.formatPrice(priceBreakdown['total'] ?? order['total_price']),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffFD713F),
                  ),
                ),
              ],
            ),

            // ===== Reason =====
            if (cancelReason != null) ...[
              8.height,
              _reasonChip('Reason: $cancelReason', const Color(0xffF44336),
                  const Color(0xffFFEBEE)),
            ],
            if (declineReason != null) ...[
              8.height,
              _reasonChip('Reason: $declineReason', const Color(0xff9E9E9E),
                  const Color(0xffF5F5F5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _reasonChip(String text, Color color, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 12.sp, color: color),
          6.width,
          Text(
            text,
            style: TextStyle(fontSize: 11.sp, color: color),
          ),
        ],
      ),
    );
  }
}