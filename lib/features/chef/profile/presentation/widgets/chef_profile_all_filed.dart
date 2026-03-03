import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../controller/chef_profile_controller.dart';

class ChefProfileAllFiled extends StatelessWidget {
  const ChefProfileAllFiled({super.key, required this.controller});

  final ChefProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Full Name
        const CommonText(
          text: AppString.fullName,
          fontWeight: FontWeight.w600,
          bottom: 8,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.nameController,
          validator: OtherHelper.validator,
          hintText: AppString.fullName,
          keyboardType: TextInputType.text,
          borderRadius: 12,
        ),

        /// Cooking Area
        const CommonText(
          text: 'Cooking Area',
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 4,
          color: Color(0xff272727),
        ),
        CommonText(
          text: 'Accept orders within ${controller.distanceController.text}km of your location',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          bottom: 8,
          color: const Color(0xff777777),
        ),

        /// Address with Autocomplete
        _AddressAutocompleteField(controller: controller),

        /// Chef Experience
        const CommonText(
          text: 'Chef Experience',
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.experienceController,
          validator: OtherHelper.validator,
          hintText: 'Enter your years of experience',
          keyboardType: TextInputType.number,
          borderRadius: 12,
        ),

        /// Cuisines
        const CommonText(
          text: 'Cuisines',
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 12,
          color: Color(0xff272727),
        ),
        _CuisineSelector(controller: controller),

        /// About
        const CommonText(
          text: AppString.about,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 8,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.aboutController,
          validator: OtherHelper.validator,
          hintText: AppString.about,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          borderRadius: 12,
        ),

        /// Price
        CommonText(
          text: 'PRICE',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: const Color(0xff777777),
          top: 28,
          bottom: 12,
        ),
        const CommonText(
          text: 'Set Amount',
          fontWeight: FontWeight.w600,
          bottom: 8,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.pricingController,
          validator: OtherHelper.validator,
          hintText: '0',
          keyboardType: TextInputType.number,
          borderRadius: 12,
          prefixText: '\$  ',
          suffixIcon: const Padding(
            padding: EdgeInsets.all(14),
            child: CommonText(
              text: '/hr',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff777777),
            ),
          ),
        ),

        // Obx(
        //       () => _DiscountCard(
        //     title: 'Offer discounted rate during specific hours on weekdays',
        //     isEnabled: controller.isNotification.value,
        //     onToggle: () => controller.notification(),
        //     showTimePicker: true,
        //     fromController: controller.fromController,
        //     toController: controller.toController,
        //     rateController: controller.weekdayRateController,
        //   ),
        // ),
        /// Weekend Rate
        ///
        ///
        _DiscountCard(
          title: 'Ask for higher rate on weekends',
          isEnabled: controller.isWeekend,
          onToggle: controller.weekendToggle,
          showTimePicker: false,
          rateController: controller.weekendRateController,
        ),

        /// Auto Accept
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Expanded(
                child: CommonText(
                  text: 'Enable Auto-Accept',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                  textAlign: TextAlign.start,
                ),
              ),
              _AutoAcceptToggle(controller: controller),
            ],
          ),
        ),
        if (controller.isAutoAccept)
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 4),
            child: CommonText(
              text: 'Activated',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff4CAF50),
            ),
          ),

        /// Minimum Booking Duration
        CommonText(
          text: 'MINIMUM BOOKING DURATION',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: const Color(0xff777777),
          top: 28,
          bottom: 12,
        ),
        const CommonText(
          text: 'Set shortest session length you accept',
          fontWeight: FontWeight.w600,
          bottom: 8,
          color: Color(0xff272727),
        ),
        CommonTextField(
          controller: controller.minBookingController,
          validator: OtherHelper.validator,
          hintText: '1.0',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          borderRadius: 12,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(14),
            child: CommonText(
              text: 'hr',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff777777),
            ),
          ),
        ),

        20.height,
      ],
    );
  }
}


class _AddressAutocompleteField extends StatefulWidget {
  const _AddressAutocompleteField({required this.controller});
  final ChefProfileController controller;

  @override
  State<_AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState
    extends State<_AddressAutocompleteField> {
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.controller.fetchAddressSuggestions(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;
    return Column(
      children: [
        /// Search Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffE0E0E0)),
          ),
          child: TextField(
            controller: ctrl.addressController,
            onChanged: _onChanged,
            style: const TextStyle(fontSize: 14, color: Color(0xff272727)),
            decoration: InputDecoration(
              hintText: 'Search your address...',
              hintStyle: const TextStyle(
                  fontSize: 14, color: Color(0xffAAAAAA)),
              prefixIcon: ctrl.isSearchingAddress
                  ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xff777777),
                  ),
                ),
              )
                  : const Icon(Icons.location_on_outlined,
                  color: Color(0xffFF6B35), size: 20),
              suffixIcon: ctrl.addressController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear,
                    color: Color(0xff777777), size: 18),
                onPressed: () {
                  ctrl.addressController.clear();
                  ctrl.clearAddressSuggestions();
                  ctrl.selectedLat = null;
                  ctrl.selectedLng = null;
                  ctrl.update();
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),

        /// Suggestions List
        if (ctrl.addressSuggestions.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffE0E0E0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: ctrl.addressSuggestions.map((item) {
                  return InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      ctrl.selectAddress(item);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Color(0xffFF6B35), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['sub'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff777777),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        /// Location Confirmed Badge
        if (ctrl.selectedLat != null && ctrl.addressSuggestions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Color(0xff4CAF50), size: 14),
                SizedBox(width: 4),
                Text(
                  'Location selected',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


class _CuisineSelector extends StatelessWidget {
  const _CuisineSelector({required this.controller});
  final ChefProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.selectedCuisines.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: controller.selectedCuisines
                .map(
                  (c) => Chip(
                label:
                Text(c, style: const TextStyle(fontSize: 13)),
                backgroundColor:
                const Color(0xffFF6B35).withOpacity(0.1),
                side:
                const BorderSide(color: Color(0xffFF6B35)),
                deleteIcon:
                const Icon(Icons.close, size: 14),
                onDeleted: () => controller.toggleCuisine(c),
              ),
            )
                .toList(),
          ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showCuisineBottomSheet(context),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffE0E0E0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.selectedCuisines.isEmpty
                        ? 'Select cuisines'
                        : controller.selectedCuisines.join(', '),
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.selectedCuisines.isEmpty
                          ? const Color(0xffAAAAAA)
                          : const Color(0xff272727),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xff272727)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCuisineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CuisineBottomSheet(controller: controller),
    );
  }
}

class _CuisineBottomSheet extends StatefulWidget {
  const _CuisineBottomSheet({required this.controller});
  final ChefProfileController controller;

  @override
  State<_CuisineBottomSheet> createState() =>
      _CuisineBottomSheetState();
}

class _CuisineBottomSheetState
    extends State<_CuisineBottomSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        List.from(widget.controller.selectedCuisines);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Cuisines',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
            ],
          ),
        ),
        // Scrollable list
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: widget.controller.cuisineOptions.map((cuisine) {
                final selected = _selected.contains(cuisine);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(cuisine,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? const Color(0xff272727) : Colors.transparent,
                      border: Border.all(
                        color: selected ? const Color(0xff272727) : const Color(0xffCCCCCC),
                        width: 2,
                      ),
                    ),
                    child: selected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selected.remove(cuisine);
                      } else {
                        _selected.add(cuisine);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff272727),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                widget.controller.selectedCuisines = _selected;
                widget.controller.update();
                Navigator.pop(context);
              },
              child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}


class _DiscountCard extends StatelessWidget {
  const _DiscountCard({
    required this.title,
    required this.isEnabled,
    required this.onToggle,
    required this.showTimePicker,
    required this.rateController,
    this.fromController,
    this.toController,
  });

  final String title;
  final bool isEnabled;
  final VoidCallback onToggle;
  final bool showTimePicker;
  final TextEditingController rateController;
  final TextEditingController? fromController;
  final TextEditingController? toController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CommonText(
                  text: title,
                  maxLines: 3,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                  textAlign: TextAlign.start,
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: (_) => onToggle(),
                activeColor: const Color(0xff272727),
              ),
            ],
          ),
          if (isEnabled) ...[
            if (showTimePicker &&
                fromController != null &&
                toController != null)
              Row(
                children: [
                  Expanded(
                    child: CommonTextField(
                      fillColor: Colors.white,
                      prefixText: 'From: ',
                      hintText: 'From',
                      controller: fromController,
                      paddingHorizontal: 4,
                      paddingVertical: 14,
                      fontSize: 12,
                      keyboardType: TextInputType.none,
                      borderRadius: 12,
                      onTap: () => OtherHelper
                          .openTimePickerDialog(fromController!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonTextField(
                      fillColor: Colors.white,
                      prefixText: 'To: ',
                      hintText: 'To',
                      paddingHorizontal: 10,
                      fontSize: 12,
                      paddingVertical: 14,
                      keyboardType: TextInputType.none,
                      controller: toController,
                      borderRadius: 12,
                      onTap: () => OtherHelper
                          .openTimePickerDialog(toController!),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            CommonTextField(
              controller: rateController,
              prefixText: '\$  ',
              keyboardType: TextInputType.number,
              fillColor: Colors.white,
              borderRadius: 12,
              suffixIcon: const Padding(
                padding: EdgeInsets.all(14),
                child: CommonText(
                  text: '/hr',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff777777),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class _AutoAcceptToggle extends StatelessWidget {
  const _AutoAcceptToggle({required this.controller});
  final ChefProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: controller.isAutoAccept,
      onChanged: (_) => controller.autoAcceptToggle(),
      activeColor: Colors.white,
      activeTrackColor: const Color(0xff272727),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xffCCCCCC),
    );
  }
}