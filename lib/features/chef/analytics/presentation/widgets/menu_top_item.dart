import 'package:flutter/material.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../data/Top_Menu_Model.dart';

class MenuTopItem extends StatefulWidget {
  const MenuTopItem({super.key, required this.value, required this.item});

  final int value;
  final TopMenuItem item;

  @override
  State<MenuTopItem> createState() => _MenuTopItemState();
}

class _MenuTopItemState extends State<MenuTopItem> {
  bool isExpanded = true;

  void onChange() {
    isExpanded = !isExpanded;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String imageUrl = item.images.isNotEmpty ? item.images.first : '';

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xffF1F1F1)),
              shape: BoxShape.circle,
            ),
            child: CommonText(
              text: '${widget.value}',
              fontSize: 12,
            ).center,
          ),
          12.width,
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CommonImage(
                        imageSrc: AppImages.image6,
                        size: 32,
                        borderRadius: 4,
                      ),
                    )
                        : const CommonImage(
                      imageSrc: AppImages.image6,
                      size: 32,
                      borderRadius: 4,
                    ),
                    CommonText(
                      text: item.name,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                      left: 12,
                    ),
                    const Spacer(),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: onChange,
                      child: Icon(
                        !isExpanded
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_down_outlined,
                        color: const Color(0xff777777),
                      ),
                    ),
                  ],
                ),
                if (isExpanded)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CommonText(
                              text: 'Number of Orders',
                              fontSize: 12,
                              color: Color(0xff777777),
                            ),
                            CommonText(
                              text: '${item.totalBooking} times',
                              fontSize: 12,
                              color: const Color(0xff272727),
                            ),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CommonText(
                              text: 'Item Ratings',
                              fontSize: 12,
                              color: Color(0xff777777),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rate_rounded,
                                    color: Color(0xffFD713F)),
                                CommonText(
                                  text: item.avgRating.toStringAsFixed(1),
                                  fontSize: 12,
                                  color: const Color(0xff272727),
                                ),
                              ],
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