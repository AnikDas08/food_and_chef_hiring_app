import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../controller/chef_profile_controller.dart';
import 'custom_TimePicker.dart';

class ChefProfileAllFiled extends StatelessWidget {
  const ChefProfileAllFiled({super.key, required this.controller});

  final ChefProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _gap(),
        CommonTextField(
          controller: controller.firstNameController,
          validator: OtherHelper.validator,
          hintText: 'First Name',
          borderRadius: 12,
        ),
        const _FieldLabel(text: 'Last Name', top: 16),
        _gap(),
        CommonTextField(
          controller: controller.lastNameController,
          validator: OtherHelper.validator,
          hintText: 'Last Name',
          borderRadius: 12,
        ),
        const _FieldLabel(text: 'Cooking Area', top: 20),
        const SizedBox(height: 4),
        CommonText(
          text:
              'Accept orders within ${controller.distanceController.text}km of your location',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xff999999),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        _AddressAutocompleteField(controller: controller),

        const _FieldLabel(text: 'Chef Experience', top: 20),
        _gap(),
        _DropdownStyleField(
          controller: controller.experienceController,
          hintText: 'Years of experience',
          keyboardType: TextInputType.number,
        ),

        const _FieldLabel(text: 'Cuisines', top: 20),
        _gap(),
        _CuisineSelector(controller: controller),

        const _FieldLabel(text: AppString.about, top: 20),
        _gap(),
        CommonTextField(
          controller: controller.aboutController,
          validator: OtherHelper.validator,
          hintText: AppString.about,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          borderRadius: 12,
        ),

        const SizedBox(height: 28),
        const _SectionLabel(text: 'PRICING'),
        const _FieldLabel(text: 'Set Amount', top: 14),
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
            child: CommonText(
              text: '/h',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xff999999),
            ),
          ),
        ),

        _ToggleCard(
          title: 'Offer discounted rate during specific hours on weekdays',
          isEnabled: controller.isDiscount,
          onToggle: () => controller.onChangeDiscount(null),
          child:
              controller.isDiscount
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
                              onTap: () {
                                SetAvailabilityPicker.show(
                                  context,
                                  initialFromTime: _parseTime(
                                    controller.fromController.text,
                                  ),
                                  initialToTime: _parseTime(
                                    controller.toController.text,
                                  ),
                                  onApply: (from, to) {
                                    controller.fromController.text =
                                        _formatTime(from);
                                    controller.toController.text = _formatTime(
                                      to,
                                    );
                                  },
                                );
                              },
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
                              onTap: () {
                                SetAvailabilityPicker.show(
                                  context,
                                  initialFromTime: _parseTime(
                                    controller.fromController.text,
                                  ),
                                  initialToTime: _parseTime(
                                    controller.toController.text,
                                  ),
                                  onApply: (from, to) {
                                    controller.fromController.text =
                                        _formatTime(from);
                                    controller.toController.text = _formatTime(
                                      to,
                                    );
                                  },
                                );
                              },
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
                          child: CommonText(
                            text: '/h',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff999999),
                          ),
                        ),
                      ),
                    ],
                  )
                  : null,
        ),

        _ToggleCard(
          title: 'Ask for higher rate on weekends',
          isEnabled: controller.isWeekend,
          onToggle: controller.weekendToggle,
          child:
              controller.isWeekend
                  ? CommonTextField(
                    controller: controller.weekendRateController,
                    prefixText: '\$  ',
                    keyboardType: TextInputType.number,
                    fillColor: Colors.white,
                    borderRadius: 12,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(14),
                      child: CommonText(
                        text: '/h',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff999999),
                      ),
                    ),
                  )
                  : null,
        ),

        _ToggleCard(
          title: 'Enable Auto-Accept',
          isEnabled: controller.isAutoAccept,
          onToggle: controller.autoAcceptToggle,
          subtitle: controller.isAutoAccept ? 'Activated' : null,
          child: null,
        ),

        const SizedBox(height: 28),
        const _SectionLabel(text: 'MINIMUM BOOKING DURATION'),
        const SizedBox(height: 12),
        const CommonText(
          text: 'Set shortest session length you accept',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
          textAlign: TextAlign.start,
        ),
        _gap(),
        CommonTextField(
          controller: controller.minBookingController,
          validator: OtherHelper.validator,
          hintText: '1.0',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          borderRadius: 12,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(14),
            child: CommonText(
              text: 'h',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xff999999),
            ),
          ),
        ),

        20.height,
      ],
    );
  }

  Widget _gap() => const SizedBox(height: 8);
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final double top;

  const _FieldLabel({required this.text, this.top = 0});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      top: top,
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xff272727),
      textAlign: TextAlign.start,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text: text,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: const Color(0xff999999),
      textAlign: TextAlign.start,
    );
  }
}

class _DropdownStyleField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const _DropdownStyleField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12),
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
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTime(TimeOfDay time) {
  final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final m = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '${h.toString().padLeft(2, '0')}:$m $period';
}

TimeOfDay _parseTime(String text) {
  try {
    final parts = text.trim().split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  } catch (_) {
    return const TimeOfDay(hour: 9, minute: 0);
  }
}

class _ToggleCard extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final VoidCallback onToggle;
  final Widget? child;
  final String? subtitle;

  const _ToggleCard({
    required this.title,
    required this.isEnabled,
    required this.onToggle,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CommonText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff272727),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
              CupertinoSwitch(
                value: isEnabled,
                onChanged: (_) => onToggle(),
                activeColor: const Color(0xFF1C1C1C),
              )
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: CommonText(
                text: subtitle!,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: ctrl.addressController,
            onChanged: _onChanged,
            style: const TextStyle(fontSize: 14, color: Color(0xff272727)),
            decoration: InputDecoration(
              hintText: 'Search your address...',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xffAAAAAA),
              ),
              suffixIcon:
                  ctrl.isSearchingAddress
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
                            icon: const Icon(
                              Icons.clear,
                              color: Color(0xff999999),
                              size: 16,
                            ),
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
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xffFF6B35),
                              size: 20,
                            ),
                          ),
                        ],
                      )
                      : const Padding(
                        padding: EdgeInsets.only(right: 14),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xffFF6B35),
                          size: 20,
                        ),
                      ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
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
                children:
                    ctrl.addressSuggestions.map((item) {
                      return InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          ctrl.selectAddress(item);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xffFF6B35),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: item['title'] ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff272727),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 2),
                                    CommonText(
                                      text: item['sub'] ?? '',
                                      fontSize: 12,
                                      color: const Color(0xff999999),
                                      textAlign: TextAlign.start,
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

        if (ctrl.selectedLat != null && ctrl.addressSuggestions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 2),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Color(0xff4CAF50),
                  size: 14,
                ),
                SizedBox(width: 4),
                CommonText(
                  text: 'Location selected',
                  fontSize: 12,
                  color: Color(0xff4CAF50),
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
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
    return Obx(() {
      final hasSelected = controller.selectedCuisineNames.isNotEmpty;

      return GestureDetector(
        onTap: () => _showCuisineBottomSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child:
                    hasSelected
                        ? Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children:
                              controller.selectedCuisineNames.map((name) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CommonText(
                                    text: name,
                                    fontSize: 13,
                                    color: const Color(0xff272727),
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.start,
                                  ),
                                );
                              }).toList(),
                        )
                        : const CommonText(
                          text: 'Select cuisines',
                          fontSize: 14,
                          color: Color(0xffAAAAAA),
                          textAlign: TextAlign.start,
                        ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Color(0xff272727),
                size: 22,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showCuisineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => _CuisineBottomSheet(controller: controller),
    );
  }
}

// ─── Cuisine Bottom Sheet ─────────────────────────────────────────────────────

class _CuisineBottomSheet extends StatefulWidget {
  const _CuisineBottomSheet({required this.controller});

  final ChefProfileController controller;

  @override
  State<_CuisineBottomSheet> createState() => _CuisineBottomSheetState();
}

class _CuisineBottomSheetState extends State<_CuisineBottomSheet> {
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.controller.selectedCuisineIds);
  }

  @override
  Widget build(BuildContext context) {
    final allCuisines = widget.controller.allCuisines;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              child: CommonText(
                text: 'Select Cuisines',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Flexible(
            child:
                allCuisines.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : SingleChildScrollView(
                      child: Column(
                        children:
                            allCuisines.map((cuisine) {
                              final isSelected = _selectedIds.contains(
                                cuisine.id,
                              );
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                title: CommonText(
                                  text: cuisine.name,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.start,
                                ),
                                trailing: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isSelected
                                            ? const Color(0xff272727)
                                            : const Color(0xffF2F2F2),
                                  ),
                                  child:
                                      isSelected
                                          ? const Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                          : null,
                                ),
                                onTap: () {
                                  setState(() {
                                    isSelected
                                        ? _selectedIds.remove(cuisine.id)
                                        : _selectedIds.add(cuisine.id);
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                onPressed: () {
                  widget.controller.selectedCuisineIds.value = _selectedIds;
                  Navigator.pop(context);
                },
                child: const CommonText(
                  text: 'Done',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
