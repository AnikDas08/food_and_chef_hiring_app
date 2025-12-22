import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_string.dart';

class CommonPhoneNumberTextFiled extends StatelessWidget {
  const CommonPhoneNumberTextFiled({
    super.key,
    required this.controller,
    required this.countryChange,
  });

  final TextEditingController controller;
  final Function(Country value) countryChange;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      onCountryChanged: countryChange,
      pickerDialogStyle: PickerDialogStyle(backgroundColor: Color(0xffF2F2F2)),
      decoration: const InputDecoration(
        hintText: AppString.phoneNumber,
        fillColor: AppColors.filledColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      initialCountryCode: "BD",
      disableLengthCheck: false,
    );
  }
}
