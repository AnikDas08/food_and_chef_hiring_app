// lib/features/orders/view/past_order_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import '../controller/past_order_controller.dart';
import '../widgets/past_item.dart';

class PastOrderScreen extends StatelessWidget {
  const PastOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: AppString.pastBookings,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: const Color(0xff272727),
                bottom: 8,
              ),

              Expanded(
                child: GetBuilder<PastOrderController>(
                  init: PastOrderController(),
                  builder: (controller) {

                    // ── Loading ────────────────────────────
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // ── Empty ──────────────────────────────
                    if (controller.orderList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Color(0xff777777),
                            ),
                            const SizedBox(height: 12),
                            CommonText(
                              text: "No past orders found",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff777777),
                            ),
                          ],
                        ),
                      );
                    }

                    // ── List ───────────────────────────────
                    return RefreshIndicator(
                      onRefresh: controller.fetchOrders,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        // +1 for pagination footer
                        itemCount: controller.orderList.length + 1,
                        itemBuilder: (context, index) {
                          // Pagination footer
                          if (index == controller.orderList.length) {
                            if (controller.isFetchingMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                           /* if (!controller.hasMorePages) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    "No more orders",
                                    style: TextStyle(
                                      color: Color(0xff777777),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }*/
                            return const SizedBox.shrink();
                          }

                          return pastItem(
                            context,
                            controller.orderList[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}