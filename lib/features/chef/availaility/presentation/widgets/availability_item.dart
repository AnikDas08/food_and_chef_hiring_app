import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/button/switch_button.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/helpers/other_helper.dart';

class AvailabilityItem extends StatefulWidget {
  const AvailabilityItem({super.key});

  @override
  State<AvailabilityItem> createState() => _AvailabilityItemState();
}

class _AvailabilityItemState extends State<AvailabilityItem> {
  bool value = false;

  onChange() {
    value = !value;
    setState(() {});
  }

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Monday",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff272727),
              ),
              switchButton(value: value, onTap: onChange),
            ],
          ),
          if (value) ...[
            16.height,
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    fillColor: Colors.white,
                    prefixText: "From: ",
                    hintText: "From",
                    controller: fromController,
                    paddingHorizontal: 4,
                    paddingVertical: 14,
                    fontSize: 12,
                    keyboardType: TextInputType.none,
                    borderRadius: 12,
                    onTap:
                        () => OtherHelper.openTimePickerDialog(fromController),
                  ),
                ),
                12.width,
                Expanded(
                  child: CommonTextField(
                    fillColor: Colors.white,
                    prefixText: "To: ",
                    hintText: "To",
                    paddingHorizontal: 10,
                    fontSize: 12,
                    paddingVertical: 14,
                    keyboardType: TextInputType.none,
                    controller: toController,
                    borderRadius: 12,
                    onTap: () => OtherHelper.openTimePickerDialog(toController),
                  ),
                ),
              ],
            ),
            16.height,
            Row(
              children: [
                Icon(CupertinoIcons.add, size: 16),
                CommonText(
                  text: AppString.addAdditionalTime,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff272727),
                  left: 4,
                ),
              ],
            ),
          ],
        ],
      ),
    );
    ;
  }
}
