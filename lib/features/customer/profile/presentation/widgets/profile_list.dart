import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_colors.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
    this.height = 30,
    this.selectedColor = AppColors.primaryColor,
    this.unselectedColor = const Color(0xffF1F1F1),
    this.style,
    this.isContainer = false,
    this.iconColor = AppColors.black,
    this.iconData = Icons.keyboard_arrow_down_outlined,
  });

  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> selectedItem;
  final Color selectedColor;
  final Color iconColor;
  final Color unselectedColor;
  final double height;
  final Function(int index) onTap;
  final TextStyle? style;
  final bool isContainer;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: const BorderSide(color: Color(0xffF1F1F1)),
        ),
        offset: const Offset(1, 1),
        padding: EdgeInsets.zero,
        color: Colors.white,
        itemBuilder:
            (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'option1',
                child: Column(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    return InkWell(
                      onTap: () async {
                        onTap(index);
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.all(12.0),
                        width: Get.width - 100,
                        child: Row(
                          children: [
                            CommonImage(imageSrc: item['image'], size: 30),
                            CommonText(
                              text: item['name'].toString(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff272727),
                              left: 8,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color:
                                      selectedItem == item
                                          ? Colors.transparent
                                          : const Color(0xffF1F1F1),
                                ),
                                color:
                                    selectedItem == item
                                        ? const Color(0xffFD713F)
                                        : unselectedColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
        icon: Padding(
          padding: EdgeInsets.only(left: isContainer ? 40 : 0),
          child: Icon(iconData, color: iconColor, size: height),
        ),
      ),
    );
  }
}
