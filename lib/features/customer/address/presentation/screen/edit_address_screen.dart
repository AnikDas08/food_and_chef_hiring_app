// lib/features/address/view/edit_address_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/google_map/google_map.dart';
import '../../../../../component/text/common_text.dart';
import '../../data/address_model.dart';
import '../controller/address_controller.dart';

class EditAddressScreen extends StatelessWidget {
  const EditAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Get passed address + trigger load on first build ──
    final address = Get.arguments as AddressModel;
    final controller = Get.find<AddressController>();

    // Load only if not already loading this address
    if (controller.editingAddress?.id != address.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadAddressForEdit(address);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Address'), ),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          // ── Full screen loader while fetching ────────────
          if (controller.isLoadingEdit) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Edit Address',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 24,
                  ),

                  // ── MAP (centered on existing location) ──────────
                  SizedBox(
                    height: 324,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ShowGoogleMap(
                            latitude: controller.selectedLatitude ?? 0,
                            longitude: controller.selectedLongitude ?? 0,
                            onTapLatLong: (LatLng latLng) {
                              controller.selectedLatitude = latLng.latitude;
                              controller.selectedLongitude = latLng.longitude;
                              controller.update();
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: GetBuilder<AddressController>(
                              builder: (ctrl) {
                                return CommonButton(
                                  buttonHeight: 48,
                                  titleText:
                                      ctrl.isLoadingCurrentLocation
                                          ? 'Getting Location...'
                                          : AppString.useCurrentLocation,
                                  isLoading: ctrl.isLoadingCurrentLocation,
                                  onTap:
                                      ctrl.isLoadingCurrentLocation
                                          ? null
                                          : () {
                                            // Same method as AddAddressScreen —
                                            // gets GPS, reverse geocodes, and
                                            // fills address + details fields
                                            ctrl.getCurrentLocationAndFillAddress();
                                          },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  CommonText(
                    text: AppString.addressDetails.toUpperCase(),
                    fontSize: 12,
                    color: const Color(0xff777777),
                    bottom: 12,
                    top: 24,
                  ),

                  // ── ADDRESS LABEL ────────────────────────────────
                  const CommonText(
                    text: AppString.addressLabel,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonTextField(
                    hintText: 'Enter Address Label',
                    keyboardType: TextInputType.name,
                    controller: controller.addressLabelController,
                    suffixIcon: PopUpMenu(
                      items: controller.addressTypeList,
                      selectedItem: [controller.addressLabelController.text],
                      onTap: controller.onChangeAddressType,
                    ),
                  ),

                  // ── ADDRESS (with suggestions) ───────────────────
                  const CommonText(
                    text: AppString.address,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: 'Enter Address',
                    controller: controller.addressController,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: CommonImage(
                        imageSrc: AppImages.house,
                        imageColor: Colors.black,
                      ),
                    ),
                  ),
                  if (controller.showAddressSuggestions)
                    _SuggestionList(
                      suggestions: controller.addressSuggestions,
                      isLoading: controller.isLoadingSuggestions,
                      onTap: controller.onAddressSuggestionSelected,
                    ),

                  // ── DETAILS ADDRESS ──────────────────────────────
                  const CommonText(
                    text: AppString.detailedAddress,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: 'Enter Detailed Address',
                    controller: controller.detailsAddressController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),

                  // ── ADDITIONAL ADDRESS (optional) ────────────────
                  const CommonText(
                    text: AppString.additionalAddress,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: '${AppString.additionalAddress} (Optional)',
                    controller: controller.additionalAddressController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                  if (controller.showAdditionalSuggestions)
                    _SuggestionList(
                      suggestions: controller.additionalSuggestions,
                      isLoading: controller.isLoadingAdditionalSuggestions,
                      onTap: controller.onAdditionalSuggestionSelected,
                    ),

                  // ── OWNER ────────────────────────────────────────
                  const CommonText(
                    text: AppString.owner,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: AppString.owner,
                    controller: controller.ownerNameController,
                  ),

                  // ── PHONE ────────────────────────────────────────
                  const CommonText(
                    text: AppString.phoneNumber,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                    top: 16,
                  ),
                  CommonTextField(
                    hintText: AppString.phoneNumber,
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.phone,
                  ),

                  // ── DEFAULT CHECKBOX ─────────────────────────────
                  Row(
                    children: [
                      Checkbox(
                        activeColor: const Color(0xffFD713F),
                        value: controller.isDefault,
                        onChanged: controller.onChangeDefaultAddress,
                      ),
                      const Expanded(
                        child: CommonText(
                          text: AppString.makeAsActiveAddress,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),

                  20.height,
                ],
              ),
            ),
          );
        },
      ),

      // ── FOOTER BUTTON ──────────────────────────────────────
      persistentFooterButtons: [
        SafeArea(
          child: GetBuilder<AddressController>(
            builder:
                (controller) => Column(
                  children: [
                    10.height,
                    controller.isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : CommonButton(
                          titleText: AppString.editAddress,
                          onTap: controller.updateAddress,
                        ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}

// ── Suggestion Dropdown ─────────────────────────────────────────────────────
class _SuggestionList extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;
  final bool isLoading;
  final Function(Map<String, dynamic>) onTap;

  const _SuggestionList({
    required this.suggestions,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          isLoading
              ? const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
              : suggestions.isEmpty
              ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'No results found',
                  style: TextStyle(color: Color(0xff777777)),
                ),
              )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final s = suggestions[i];
                  return ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xffFD713F),
                      size: 18,
                    ),
                    title: Text(
                      s['main_text'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                    ),
                    subtitle: Text(
                      s['secondary_text'] ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xff777777),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => onTap(s),
                  );
                },
              ),
    );
  }
}
