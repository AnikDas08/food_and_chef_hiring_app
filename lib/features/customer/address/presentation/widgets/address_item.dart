// lib/features/address/widgets/address_item.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/route/app_routes.dart';
import '../../data/address_model.dart';
import '../controller/address_controller.dart';

Widget addressItem(
    AddressModel address,
    AddressController controller, {
      bool fromCheckout = false,
      String? selectedAddressId, // Pass controller.defaultAddressid here
      bool isLoading = false,
    }) {
  final bool isActive = address.status.toLowerCase() == "active";

  // Logic: Check if this specific address ID matches the user's default ID
  final bool isDefaultSelected = selectedAddressId == address.id;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 26),
    decoration: BoxDecoration(
      color: const Color(0xffF2F2F2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon based on label (Home, Office, Work)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                address.label.toLowerCase() == "home"
                    ? CupertinoIcons.house
                    : address.label.toLowerCase() == "office" ||
                    address.label.toLowerCase() == "work"
                    ? CupertinoIcons.building_2_fill
                    : CupertinoIcons.location,
                color: Colors.red,
                size: 20,
              ),
            ),

            12.width,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "${address.label} - ${address.ownerName}",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                            CommonText(
                              text: address.phoneNumber,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff777777),
                              top: 2,
                            ),
                          ],
                        ),
                      ),

                      // Top-right status badge (always show if not checkout)
                      if (!fromCheckout)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xffDBEBD9)
                                : const Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CommonText(
                            text: address.status,
                            color: isActive
                                ? const Color(0xff2F8328)
                                : const Color(0xff777777),
                          ),
                        ),

                      // Checkout-specific Radio button placement
                      if (fromCheckout)
                        Icon(
                          isDefaultSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 22,
                          color: isDefaultSelected
                              ? const Color(0xffFD713F)
                              : const Color(0xffC0C0C0),
                        ),
                    ],
                  ),

                  // Full Address Details
                  CommonText(
                    text: "${address.address} - ${address.detailsAddress}, ${address.additionalDetails}",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff272727),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    top: 12,
                  ),

                  12.height,

                  // Action Row (Edit, Delete, and the Radio Button)
                  if (!fromCheckout)
                    Row(
                      children: [
                        // Edit Button
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.edit_address,
                              arguments: address,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CommonText(
                              text: AppString.editAddress,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                            ),
                          ),
                        ),

                        // Delete Button
                        InkWell(
                          onTap: () => _showDeleteDialog(address, controller),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffFF3C3C).withOpacity(0.20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CommonText(
                              text: AppString.delete,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffFF3C3C),
                            ),
                          ),
                        ),

                        const Spacer(), // Pushes the radio button to the far right

                        // --- THE RADIO BUTTON (ALWAYS SHOWS) ---
                        // It checks if address.id matches the profile's default ID
                        if(isLoading)
                        Icon(
                          isDefaultSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 22,
                          color: isDefaultSelected
                              ? const Color(0xffFD713F)
                              : const Color(0xffC0C0C0),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void _showDeleteDialog(AddressModel address, AddressController controller) {
  Get.dialog(
    AlertDialog(
      title: const Text("Delete Address"),
      content: const Text("Are you sure you want to delete this address?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            controller.deleteAddress(address.id);
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}