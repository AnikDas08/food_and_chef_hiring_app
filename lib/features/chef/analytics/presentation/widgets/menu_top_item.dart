import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

class MenuTopItem extends StatefulWidget {
  const MenuTopItem({super.key, required this.value});

  final int value;

  @override
  State<MenuTopItem> createState() => _MenuTopItemState();
}

class _MenuTopItemState extends State<MenuTopItem> {
  final int count = 3;
  final double size = 16;
  final double overlap = 8;
  bool isExpanded = true;

  onChange() {
    isExpanded = !isExpanded;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffF1F1F1)),
              shape: BoxShape.circle,
            ),
            child:
                CommonText(
                  text: "${widget.value}",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,

                ).center,
          ),
          12.width,
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    CommonImage(
                      imageSrc: AppImages.image6,
                      size: 32,
                      borderRadius: 4,
                    ),
                    CommonText(
                      text: "Chopped Burrito",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff272727),
                      left: 12,
                    ),
                    Spacer(),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: onChange,
                      child: Icon(
                        !isExpanded
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_down_outlined,
                        color: Color(0xff777777),
                      ),
                    ),
                  ],
                ),
                if (isExpanded)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: "Number of Orders",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff777777),
                            ),
                            CommonText(
                              text: "12 times",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff272727),
                            ),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: "Item Ratings",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff777777),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rate_rounded,
                                  color: Color(0xffFD713F),
                                ),
                                CommonText(
                                  text: "4,1",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff272727),
                                ),
                              ],
                            ),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: "Frequently Order With",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff777777),
                            ),
                            SizedBox(
                              width: size + (count - 1) * overlap + 30,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: List.generate(count, (index) {
                                  final bool isLast = index == count - 1;
                                  if (isLast) {
                                    return Container(
                                      height: size,
                                      width: size + (count - 1) * overlap + 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CommonText(
                                        text: "3 more",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff777777),
                                      ),
                                    );
                                  }
                                  return Positioned(
                                    top: 0,
                                    left: index * overlap - 20,
                                    child: CommonImage(
                                      imageSrc: AppImages.image6,
                                      size: size,
                                      borderRadius: 50,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        16.height,
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
