import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_untitled/component/text/common_text.dart';

class AvailabilityItem extends StatefulWidget {
  const AvailabilityItem({super.key});

  @override
  State<AvailabilityItem> createState() => _AvailabilityItemState();
}

class _AvailabilityItemState extends State<AvailabilityItem> {
  bool value = false;

  onChange(v) {
    value = v;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CommonText(text: "Monday"),
              Switch(
                activeThumbColor: Colors.white,
                activeTrackColor: Color(0xff272727),
                value: value,
                onChanged: onChange,
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
