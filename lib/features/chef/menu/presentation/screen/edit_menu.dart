import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/pop_up/common_pop_menu.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/features/chef/menu/presentation/controller/add_menu_screen.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../widgets/dish.dart';

class EditMenu extends StatelessWidget {
  const EditMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AddMenuController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: "Edit Item",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    top: 24,
                    color: Color(0xff272727),
                  ),
                  CommonText(
                    text:
                    "Add your menu and items to showcase what you can cook for customers.",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    top: 8,
                  ),
                  CommonText(
                    text: "Previews",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 20,
                    bottom: 8,
                  ),

                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.add),
                  ),
                  const CommonText(
                    text: AppString.menuSection,
                    fontWeight: FontWeight.w600,
                    bottom: 8,
                    top: 16,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    validator: OtherHelper.validator,
                    hintText: AppString.menuSection,
                    keyboardType: TextInputType.none,
                    controller: controller.menuController,
                    suffixIcon: PopUpMenu(
                      items: controller.menuOption,
                      selectedItem: [controller.menuController.text],
                      onTap: controller.onChangeMenu,
                    ),
                  ),

                  const CommonText(
                    text: AppString.itemName,
                    fontWeight: FontWeight.w600,
                    bottom: 8,
                    top: 16,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    validator: OtherHelper.validator,
                    hintText: AppString.itemName,
                    keyboardType: TextInputType.text,
                  ),

                  const CommonText(
                    text: AppString.description,
                    fontWeight: FontWeight.w600,
                    bottom: 8,
                    top: 16,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    validator: OtherHelper.validator,
                    hintText: AppString.description,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),

                  const CommonText(
                    text: AppString.dietType,
                    fontWeight: FontWeight.w600,
                    bottom: 8,
                    top: 16,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    validator: OtherHelper.validator,
                    hintText: AppString.dietType,
                    keyboardType: TextInputType.none,
                    controller: controller.dietTypeController,
                    suffixIcon: PopUpMenu(
                      items: controller.dietOption,
                      selectedItem: [controller.dietTypeController.text],
                      onTap: controller.onChangeDiet,
                    ),
                  ),

                  const CommonText(
                    text: AppString.allergens,
                    fontWeight: FontWeight.w600,
                    bottom: 8,
                    top: 16,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    validator: OtherHelper.validator,
                    hintText: AppString.allergens,
                    keyboardType: TextInputType.none,
                    controller: controller.allergensController,
                    suffixIcon: PopUpMenu(
                      items: controller.allergensOption,
                      selectedItem: [controller.allergensController.text],
                      onTap: controller.onChangeAllergens,
                    ),
                  ),

                  const CommonText(
                    text: AppString.estCookingTime,
                    fontWeight: FontWeight.w600,
                    bottom: 8,
                    top: 16,
                    color: Color(0xff272727),
                  ),
                  CommonTextField(
                    validator: OtherHelper.validator,
                    hintText: AppString.estCookingTime,
                    keyboardType: TextInputType.number,
                  ),

                  Divider(color: Color(0xffF1F1F1)),
                  Row(
                    children: [
                      CommonText(
                        text: AppString.customizeTheDish,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 16),
                            CommonText(
                              text: "Add",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      16.width,
                      Icon(Icons.keyboard_arrow_up_rounded),
                    ],
                  ),
                  Divider(color: Color(0xffF1F1F1)),
                  12.height,
                  dish("Without onions"),
                  24.height,

                  dish("Without iceberg lettuce"),
                  24.height,

                  dish("Without cheese"),
                  24.height,

                  dish("Without Tomato"),
                  24.height,

                  dish("Without Bacon"),
                  24.height,

                  Row(
                    children: [
                      CommonText(
                        text: "Ingredients",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 16),
                            CommonText(
                              text: "Add",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      16.width,
                      Icon(Icons.keyboard_arrow_up_rounded),
                    ],
                  ),
                  Divider(color: Color(0xffF1F1F1), height: 30),

                  Row(
                    children: [
                      CommonText(
                        text: "Special Equipment",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 16),
                            CommonText(
                              text: "Add",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      16.width,
                      Icon(Icons.keyboard_arrow_up_rounded),
                    ],
                  ),
                  16.height,

                  CommonButton(
                    titleText: AppString.saveItem,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
