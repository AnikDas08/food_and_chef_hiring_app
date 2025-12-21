import 'package:flutter/material.dart';

import '../../../../../component/text/common_text.dart';

class ExtendText extends StatelessWidget {
  const ExtendText({
    super.key,
    required this.text,
    this.isExpanded = false,
    this.onTap,
  });

  final String text;

  final bool isExpanded;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: text,
          fontSize: 12,
          maxLines: isExpanded ? 10 : 2,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400,
          color: Color(0xff272727),
          textAlign: TextAlign.start,
          top: 16,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: CommonText(
            text: isExpanded ? "Read less" : "Read more",
            color: Color(0xffFD713F),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
