import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../text/common_text.dart';

// ignore: must_be_immutable
class CommonTextField extends StatelessWidget {
  CommonTextField({
    super.key,
    this.hintText,
    this.readOnly = false,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.mexLength,
    this.validator,
    this.prefixText,
    this.paddingHorizontal = 16,
    this.paddingVertical = 18,
    this.borderRadius = 20,
    this.fontSize = 14,
    this.hintTextSize = 12,
    this.inputFormatters,
    this.fillColor = const Color(0xffF2F2F2),
    this.hintTextColor = const Color(0xff777777),
    this.labelTextColor = const Color(0xff777777),
    this.textColor = AppColors.black,
    this.borderColor = AppColors.transparent,
    this.onSubmitted,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.isDense,
    this.suffixIcon,
    this.maxLines,
  });

  final String? hintText;
  final bool readOnly;
  final String? labelText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? labelTextColor;
  final Color? hintTextColor;
  final Color? textColor;
  final Color borderColor;
  final double paddingHorizontal;
  final double paddingVertical;
  final int? maxLines;
  final double borderRadius;
  final int? mexLength;
  final bool isPassword;
  final bool? isDense;
  final double fontSize;
  final double hintTextSize;
  RxBool obscureText = false.obs;
  final Function(String)? onSubmitted;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final FormFieldValidator? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        autovalidateMode: AutovalidateMode.onUnfocus,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly,
        focusNode: focusNode,
        obscureText: isPassword ? !obscureText.value : obscureText.value,
        textInputAction: textInputAction,

        maxLength: mexLength,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: TextStyle(fontSize: fontSize, color: textColor),
        onFieldSubmitted: onFieldSubmitted ?? onSubmitted,
        onTap: onTap,
        validator: validator,
        maxLines: isPassword ? 1 : maxLines,
        textAlignVertical: TextAlignVertical.center,

        cursorColor:
            keyboardType == TextInputType.none ? Colors.transparent : textColor,
        decoration: InputDecoration(
          errorMaxLines: 2,

          isDense: isDense,
          filled: true,
          prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 30),
          prefixIcon: prefixIcon,
          fillColor: fillColor,

          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal.w,
            vertical: paddingVertical.h,
          ),
          border: _buildBorder(),
          enabledBorder: _buildBorder(),
          focusedBorder: _buildBorder(),
          disabledBorder: _buildBorder(),
          errorBorder: _buildBorder(),
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(
            height: getLetterHeight(hintTextSize, FontWeight.w400),
            fontSize: hintTextSize.sp,
            fontWeight: FontWeight.w400,
            color: hintTextColor,
            letterSpacing: getLetterSpacing(fontSize, FontWeight.w400),
          ),
          labelStyle: TextStyle(
            height: getLetterHeight(hintTextSize, FontWeight.w400),
            fontSize: hintTextSize.sp,
            fontWeight: FontWeight.w400,
            color: hintTextColor,
            letterSpacing: getLetterSpacing(fontSize, FontWeight.w400),
          ),
          prefixText: prefixText,
          prefixStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),

          suffixIcon: isPassword ? _buildPasswordSuffixIcon() : suffixIcon,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius.r),
      borderSide:
          borderColor == Colors.transparent || borderColor == AppColors.transparent
              ? BorderSide.none
              : BorderSide(color: borderColor),
    );
  }

  Widget _buildPasswordSuffixIcon() {
    return GestureDetector(
      onTap: toggle,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w),
        child: Obx(
          () => Icon(
            obscureText.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20.sp,
            color: const Color(0xff777777),
          ),
        ),
      ),
    );
  }

  void toggle() {
    obscureText.value = !obscureText.value;
  }
}
