import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/other_widgets/common_loader.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import 'chef_item.dart';

List _list = ["Recommended", "Rating", "Price", "Next Available"];

class SearchItem extends StatefulWidget {
  const SearchItem({super.key});

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  String selectedValue = _list[0];

  bool isLoading = false;

  onChangeValue(value) async {
    isLoading = true;
    setState(() {});
    selectedValue = value;
    await Future.delayed(Duration(seconds: 1));

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonText(
          text: AppString.sortBy,
          top: 24,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
          bottom: 12,
        ).start,
        SizedBox(
          height: 36.h,
          child: ListView.builder(
            itemCount: _list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              String value = _list[index];
              return InkWell(
                onTap: () => onChangeValue(value),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color:
                        value == selectedValue
                            ? Color(0xff272727)
                            : Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: CommonText(
                      text: value,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          value == selectedValue
                              ? Colors.white
                              : Color(0xff272727),
                    ),
                  ),
                ),
              ).center;
            },
          ),
        ),

        CommonText(
          text: AppString.relatedResult,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
          top: 20,
        ).start,
        CommonText(
          text: AppString.showing28RelatedResults,
          fontSize: 12,
          color: Color(0xff777777),
          fontWeight: FontWeight.w400,
          top: 2,
          bottom: 16,
        ).start,

        Expanded(
          child:
              isLoading
                  ? CommonLoader()
                  : GridView.builder(
                    itemCount: 20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 260.h,
                      mainAxisSpacing: 10.h,
                    ),
                    itemBuilder: (context, index) {
                      return chefItem(height: 160);
                    },
                  ),
        ),
      ],
    );
  }
}
