// lib/features/address/view/profile_address_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import '../../../../../config/route/app_routes.dart';
import '../controller/address_controller.dart';
import '../widgets/address_item.dart';

class ProfileAddressScreen extends StatelessWidget {
  const ProfileAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If navigated from checkout, this will be true
    final bool fromCheckout = Get.arguments?['fromCheckout'] == true;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GetBuilder<AddressController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppString.address,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                  ),
                  CommonText(
                    text: "ACTIVE ADDRESS",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff777777),
                    top: 24,
                    bottom: 12,
                  ),

                  Expanded(
                    child: controller.isLoading

                    // ── Loading State ──────────────────────────
                        ? const Center(child: CircularProgressIndicator())

                    // ── Empty State ────────────────────────────
                        : controller.addressList.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_off_outlined,
                              size: 64,
                              color: Color(0xff777777)),
                          const SizedBox(height: 12),
                          CommonText(
                            text: "No addresses found",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff777777),
                          ),
                        ],
                      ),
                    )

                    // ── Address List ───────────────────────────
                        : RefreshIndicator(
                      onRefresh: controller.fetchAddresses,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        // +1 for the footer loader item
                        itemCount: controller.addressList.length + 1,
                        // In the ListView.builder, replace the existing itemBuilder logic:
                        itemBuilder: (context, index) {
                          if (index == controller.addressList.length) {
                            return _PaginationFooter(
                              isFetchingMore: controller.isFetchingMore,
                              hasMorePages: controller.hasMorePages,
                            );
                          }

                          final address = controller.addressList[index];

                          if (fromCheckout) {
                            return GestureDetector(
                              onTap: () => Navigator.pop(context, address),
                              child: addressItem(
                                address,
                                controller,
                                fromCheckout: true,
                                selectedAddressId: Get.arguments?['selectedAddressId'],
                              ),
                            );
                          }

                          return addressItem(address, controller);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
          child: CommonButton(
            titleText: AppString.addNewAddress,
            onTap: () => Get.toNamed(AppRoutes.addAddress),
          ),
        ),
      ),
    );
  }
}

/// Footer shown at the bottom of the list
class _PaginationFooter extends StatelessWidget {
  final bool isFetchingMore;
  final bool hasMorePages;

  const _PaginationFooter({
    required this.isFetchingMore,
    required this.hasMorePages,
  });

  @override
  Widget build(BuildContext context) {
    if (isFetchingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const SizedBox.shrink();
  }
}