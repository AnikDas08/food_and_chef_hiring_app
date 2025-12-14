import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../config/route/app_routes.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              CommonTextField(
                hintText: AppString.searchForFoodChefEtc,
                onTap: () => Get.toNamed(AppRoutes.homeSearch),
                borderRadius: 30,
                suffixIcon: InkWell(
                  onTap: () {
                    filterPanel();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CommonImage(imageSrc: AppIcons.fliter),
                  ),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: Get.back,
                    child: Icon(Icons.arrow_back_outlined),
                  ),
                ),
              ),
              value
                  ? Expanded(child: SearchItem())
                  : Expanded(
                    child: InkWell(onTap: onChange, child: searchResult()),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
