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
    return SizedBox(
      width: double.infinity, // নিশ্চিত করে যে এটি পুরো জায়গা নিচ্ছে
      child: LayoutBuilder(
        builder: (context, constraints) {
          // টেক্সট Painter দিয়ে চেক করা হচ্ছে লাইন কয়টি
          final span = TextSpan(
            text: text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          );

          final tp = TextPainter(
            text: span,
            maxLines: 2,
            textDirection: TextDirection.ltr,
          );

          tp.layout(maxWidth: constraints.maxWidth);
          final bool isOverflowing = tp.didExceedMaxLines;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // কলামের সবকিছু বামে রাখবে
            children: [
              // মূল টেক্সট
              CommonText(
                text: text,
                fontSize: 12,
                maxLines: isExpanded ? 100 : 2,
                fontWeight: FontWeight.w400,
                color: const Color(0xff272727),
                textAlign: TextAlign.start, // টেক্সট নিজের ভেতর বামে থাকবে
                top: 16,
              ),

              // যদি ২ লাইনের বেশি হয় তবেই বাটন দেখাবে
              if (isOverflowing)
                Align(
                  alignment: Alignment.centerLeft, // বাটনটি বামে রাখার জন্য
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CommonText(
                        text: isExpanded ? 'Read less' : 'Read more',
                        color: const Color(0xffFD713F),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}