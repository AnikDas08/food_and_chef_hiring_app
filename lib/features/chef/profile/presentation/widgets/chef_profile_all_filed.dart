import 'dart:async';

import 'package:flutter/material.dart';
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

        // ── Full Name ──────────────────────────────────────────────────────
        _FieldLabel(text: AppString.fullName),
        _gap(),
        CommonTextField(
          controller: controller.nameController,
          validator: OtherHelper.validator,
          hintText: AppString.fullName,
          keyboardType: TextInputType.text,
          borderRadius: 12,
        ),

        // ── Cooking Area ───────────────────────────────────────────────────
        _FieldLabel(text: 'Cooking Area', top: 20),
        SizedBox(height: 4),
        Text(
          'Accept orders within ${controller.distanceController.text}km of your location',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff999999),
          ),
        ),
        SizedBox(height: 8),
        _AddressAutocompleteField(controller: controller),

        _FieldLabel(text: 'Chef Experience', top: 20),
        _gap(),
        _DropdownStyleField(
          controller: controller.experienceController,
          hintText: 'Years of experience',
          keyboardType: TextInputType.number,
          suffix: null,
        ),

        _FieldLabel(text: 'Cuisines', top: 20),
        _gap(),
        _CuisineSelector(controller: controller),

        _FieldLabel(text: AppString.about, top: 20),
        _gap(),
        CommonTextField(
          controller: controller.aboutController,
          validator: OtherHelper.validator,
          hintText: AppString.about,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          borderRadius: 12,
        ),

        SizedBox(height: 28),
        _SectionLabel(text: 'PRICING'),
        _FieldLabel(text: 'Set Amount', top: 14),
        _gap(),
        CommonTextField(
          controller: controller.pricingController,
          validator: OtherHelper.validator,
          hintText: '0',
          keyboardType: TextInputType.number,
          borderRadius: 12,
          prefixText: '\$  ',
          suffixIcon: const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              '/hr',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xff999999),
              ),
            ),
          ),
        ),

        // ── Weekday Discount Toggle ────────────────────────────────────────
        _ToggleCard(
          title: 'Offer discounted rate during specific hours on weekdays',
          isEnabled: controller.isDiscount,
          onToggle: () => controller.onChangeDiscount(null),
          child: controller.isDiscount
              ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonTextField(
                      fillColor: Colors.white,
                      prefixText: 'From: ',
                      hintText: 'From',
                      controller: controller.fromController,
                      paddingHorizontal: 4,
                      paddingVertical: 14,
                      fontSize: 12,
                      keyboardType: TextInputType.none,
                      borderRadius: 12,
                      onTap: () => OtherHelper.openTimePickerDialog(
                          controller.fromController),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CommonTextField(
                      fillColor: Colors.white,
                      prefixText: 'To: ',
                      hintText: 'To',
                      paddingHorizontal: 10,
                      fontSize: 12,
                      paddingVertical: 14,
                      keyboardType: TextInputType.none,
                      controller: controller.toController,
                      borderRadius: 12,
                      onTap: () => OtherHelper.openTimePickerDialog(
                          controller.toController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CommonTextField(
                controller: controller.weekdayRateController,
                prefixText: '\$  ',
                keyboardType: TextInputType.number,
                fillColor: Colors.white,
                borderRadius: 12,
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    '/hr',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff999999)),
                  ),
                ),
              ),
            ],
          )
              : null,
        ),

        // ── Weekend Rate Toggle ────────────────────────────────────────────
        _ToggleCard(
          title: 'Ask for higher rate on weekends',
          isEnabled: controller.isWeekend,
          onToggle: controller.weekendToggle,
          child: controller.isWeekend
              ? CommonTextField(
            controller: controller.weekendRateController,
            prefixText: '\$  ',
            keyboardType: TextInputType.number,
            fillColor: Colors.white,
            borderRadius: 12,
            suffixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                '/hr',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff999999)),
              ),
            ),
          )
              : null,
        ),

        // ── Auto Accept Toggle ─────────────────────────────────────────────
        _ToggleCard(
          title: 'Enable Auto-Accept',
          isEnabled: controller.isAutoAccept,
          onToggle: controller.autoAcceptToggle,
          subtitle: controller.isAutoAccept ? 'Activated' : null,
          subtitleColor: const Color(0xff4CAF50),
          child: null,
        ),

        // ── Minimum Booking Duration ───────────────────────────────────────
        SizedBox(height: 28),
        _SectionLabel(text: 'MINIMUM BOOKING DURATION'),
        const SizedBox(height: 12),
        const Text(
          'Set shortest session length you accept',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff272727),
          ),
        ),
        _gap(),
        CommonTextField(
          controller: controller.minBookingController,
          validator: OtherHelper.validator,
          hintText: '1.0',
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
          borderRadius: 12,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'hr',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff999999)),
            ),
          ),
        ),

        20.height,
      ],
    );
  }

  Widget _gap() => const SizedBox(height: 8);
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final double top;
  const _FieldLabel({required this.text, this.top = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xff999999),
        letterSpacing: 0.8,
      ),
    );
  }
}

/// TextField that looks like a dropdown (chevron icon on the right)
class _DropdownStyleField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffix;

  const _DropdownStyleField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff272727),
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xffAAAAAA),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
          ),
          if (suffix != null) suffix!,
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xff272727),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggle card matching screenshot style
class _ToggleCard extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final VoidCallback onToggle;
  final Widget? child;
  final String? subtitle;
  final Color subtitleColor;

  const _ToggleCard({
    required this.title,
    required this.isEnabled,
    required this.onToggle,
    required this.child,
    this.subtitle,
    this.subtitleColor = const Color(0xff4CAF50),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: (_) => onToggle(),
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff272727),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xffCCCCCC),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
            ),
          if (isEnabled && child != null) ...[
            const SizedBox(height: 10),
            child!,
          ],
        ],
      ),
    );
  }
}

// ─── Address Autocomplete ─────────────────────────────────────────────────────

class _AddressAutocompleteField extends StatefulWidget {
  const _AddressAutocompleteField({required this.controller});
  final ChefProfileController controller;

  @override
  State<_AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<_AddressAutocompleteField> {
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
        // Search field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffE8E8E8)),
          ),
          child: TextField(
            controller: ctrl.addressController,
            onChanged: _onChanged,
            style: const TextStyle(fontSize: 14, color: Color(0xff272727)),
            decoration: InputDecoration(
              hintText: 'Search your address...',
              hintStyle:
              const TextStyle(fontSize: 14, color: Color(0xffAAAAAA)),
              suffixIcon: ctrl.isSearchingAddress
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
                  : ctrl.addressController.text.isNotEmpty
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear,
                        color: Color(0xff999999), size: 16),
                    onPressed: () {
                      ctrl.addressController.clear();
                      ctrl.clearAddressSuggestions();
                      ctrl.selectedLat = null;
                      ctrl.selectedLng = null;
                      ctrl.update();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.location_on_outlined,
                        color: Color(0xffFF6B35), size: 20),
                  ),
                ],
              )
                  : const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(Icons.location_on_outlined,
                    color: Color(0xffFF6B35), size: 20),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Suggestions dropdown
        if (ctrl.addressSuggestions.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffE8E8E8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
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
                              color: Color(0xffFF6B35), size: 18),
                          const SizedBox(width: 10),
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
                                    color: Color(0xff999999),
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

        // Location confirmed badge
        if (ctrl.selectedLat != null && ctrl.addressSuggestions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 2),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline,
                    color: Color(0xff4CAF50), size: 14),
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

// ─── Cuisine Selector ─────────────────────────────────────────────────────────

class _CuisineSelector extends StatelessWidget {
  const _CuisineSelector({required this.controller});
  final ChefProfileController controller;

  @override
  Widget build(BuildContext context) {
    final hasSelected = controller.selectedCuisines.isNotEmpty;

    return GestureDetector(
      onTap: () => _showCuisineBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE8E8E8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: hasSelected
                  ? Wrap(
                spacing: 6,
                runSpacing: 4,
                children: controller.selectedCuisines
                    .map(
                      (c) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xffE0E0E0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          c,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff272727),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => controller.toggleCuisine(c),
                          child: const Icon(Icons.close,
                              size: 13,
                              color: Color(0xff999999)),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              )
                  : const Text(
                'Select cuisines',
                style: TextStyle(
                    fontSize: 14, color: Color(0xffAAAAAA)),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xff272727), size: 22),
          ],
        ),
      ),
    );
  }

  void _showCuisineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => _CuisineBottomSheet(controller: controller),
    );
  }
}

class _CuisineBottomSheet extends StatefulWidget {
  const _CuisineBottomSheet({required this.controller});
  final ChefProfileController controller;

  @override
  State<_CuisineBottomSheet> createState() => _CuisineBottomSheetState();
}

class _CuisineBottomSheetState extends State<_CuisineBottomSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.controller.selectedCuisines);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xffE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Cuisines',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: widget.controller.cuisineOptions.map((cuisine) {
                  final isSelected = _selected.contains(cuisine);
                  return ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(cuisine,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xff272727)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xff272727)
                              : const Color(0xffCCCCCC),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                          size: 13, color: Colors.white)
                          : null,
                    ),
                    onTap: () {
                      setState(() {
                        isSelected
                            ? _selected.remove(cuisine)
                            : _selected.add(cuisine);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff272727),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                onPressed: () {
                  widget.controller.selectedCuisines = _selected;
                  widget.controller.update();
                  Navigator.pop(context);
                },
                child: const Text('Done',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}