import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import 'chef_item.dart';

List _list = ["Recommended", "Distance", "Rating", "Next Available"];

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
    await Future.delayed(Duration(seconds: 1));
    selectedValue = value;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonText(
          text: AppString.sortBy,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
          bottom: 10,
        ).start,
        SizedBox(
          height: 32,
          child: ListView.builder(
            itemCount: _list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              String value = _list[index];
              return InkWell(
                onTap: () => onChangeValue(value),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color:
                        value == selectedValue
                            ? Color(0xffFD713F)
                            : Color(0xffF8F4F1),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child:
                      CommonText(
                        text: value,
                        color:
                            value == selectedValue
                                ? Colors.white
                                : Color(0xffFD713F),
                      ).center,
                ),
              );
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
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
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
