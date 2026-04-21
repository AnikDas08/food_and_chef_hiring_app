import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';

Widget buildSearchSection() {
  return CommonTextField(
    hintText: 'Search....',
    borderRadius: 12,
    borderColor: const Color(0xffF2F2F2),
    prefixIcon: const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Icon(Icons.search),
    ),
    paddingHorizontal: 20.w,
  );
}
