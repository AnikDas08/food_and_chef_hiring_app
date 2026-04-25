// lib/features/orders/view/past_order_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:new_untitled/component/text/common_text.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../controller/past_order_controller.dart';
import '../widgets/past_item.dart';

class PastOrderScreen extends StatelessWidget {
  const PastOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        flexibleSpace: LiquidGlassLayer(
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
        title: const CommonText(
          text: 'Booking History',
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: GetBuilder<PastOrderController>(
                  init: PastOrderController(),
                  builder: (controller) {
                    // ── Loading ────────────────────────────
                    if (controller.isLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    // ── Empty ──────────────────────────────
                    if (controller.orderList.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: AppColors.grey,
                            ),
                            SizedBox(height: 12),
                            CommonText(
                              text: 'No bookings',
                              color: AppColors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      );
                    }

                    // ── List ───────────────────────────────
                    return RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.black,
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
                                  child: CupertinoActivityIndicator(),
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

                          return pastItem(context, controller.orderList[index]);
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
