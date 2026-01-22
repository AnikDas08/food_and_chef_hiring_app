import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_string.dart';
import '../widgets/filter.dart';
import '../widgets/search_item.dart';
import '../widgets/search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool value = false;

  onChange() {
    value = !value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        centerTitle: false,
        flexibleSpace: appBarOpacity(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: LiquidGlassLayer(
              child: LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 30.r),
                child: CommonTextField(
                  hintText: AppString.searchForFoodChefEtc,
                  borderRadius: 30,
                  paddingHorizontal: 20,
                  fillColor: Color(0xffFAFAFA).withValues(alpha: 0.7),
                  borderColor: Colors.grey.withValues(alpha: 0.3),
                  suffixIcon: InkWell(
                    onTap: () {
                      filterPanel();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: CommonImage(
                        imageSrc: AppIcons.fliter,
                        imageColor: Color(0xff636363),
                      ),
                    ),
                  ),
                  prefixIcon: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 20),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xff272727),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ).copyWith(top: kToolbarHeight + 16 + 60),
        child:
            value
                ? SearchItem()
                : InkWell(onTap: onChange, child: searchResult()),
      ),
    );
  }
}
