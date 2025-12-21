import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/image/common_image.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/constants/app_images.dart';
import '../controller/chef_detail_controller.dart';
import 'exten_text.dart';

String text =
    "For making Chopped Burrito, you'll need 2 cups of cold, cooked jasmine rice (preferably day-old) and 2 tablespoons of vegetable oil for stir-frying. Use 3 large eggs, lightly beaten, along with a small onion finely chopped and 2 cloves of garlic minced. Add 1 cup of mixed vegetables such as peas, carrots, and corn, and 1/2 cup of finely diced cooked ham or shrimp for added protein if desired. Season with 3 tablespoons of soy sauce (preferably low sodium), 1 tablespoon of oyster sauce, and 1 teaspoon of sesame oil. Include 2 thinly sliced green onions (including the green parts), and adjust the flavor with salt and pepper to taste. For extra spice, add 1/2 teaspoon of white pepper, and enhance the aroma with 1 teaspoon of finely grated ginger. Optionally, you can include 1 tablespoon of fish sauce for added umami flavor. For garnishes, consider fresh chopped cilantro, lime wedges, and Sriracha or chili sauce for added heat.";

void itemDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<ChefDetailsController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonImage(
                    imageSrc: AppImages.image6,
                    borderRadius: 8,
                    height: 232,
                    width: Get.width,
                    fill: BoxFit.fill,
                  ),
                  CommonText(
                    text: "Quesadilla",
                    color: Color(0xff272727),
                    fontSize: 16,
                    top: 16,
                    fontWeight: FontWeight.w600,
                  ),
            
                  8.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F2),
                          border: Border.all(color: Color(0xffF2F2F2), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonImage(
                              imageSrc: AppIcons.time,
                              size: 16,
                              imageColor: Color(0xff777777),
                            ),
                            4.width,
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Cooking Time:",
                                    style: TextStyle(
                                      color: Color(0xff777777),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "40 minutes",
                                    style: TextStyle(
                                      color: Color(0xff272727),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffDBEBD9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CommonText(
                            text: "Special Equipment Required",
                            color: Color(0xff2F8328),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
            
                  ExtendText(
                    text: text,
                    isExpanded: controller.isExpanded,
                    onTap: controller.onChangeExpand,
                  ),
                  8.height,
                  Divider(),
                  12.height,
                  CommonText(
                    text: "Customize the Dish",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
            
                  ...List.generate(controller.dish.length, (index) {
                    var isSelected = controller.dish[index]["isSelected"];
                    return InkWell(
                      onTap: () {
                        controller.onChangeDish(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Container(
                              height: 15.sp,
                              width: 15.sp,
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? Colors.black : Color(0xffF1F1F1),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  !isSelected
                                      ? null
                                      : Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12.sp,
                                      ),
                            ),
                            CommonText(
                              text: controller.dish[index]["name"],
                              color: Color(0xff272727),
                              fontSize: 12,
                              left: 8,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            
                  CommonText(
                    text: "List of Ingredients",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 16,
                    bottom: 8,
                  ),
                  CommonText(
                    text:
                        "Jasmine Rice, Vegetable Oil, Eggs, White Onion, Garlic",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff272727),
                  ),
            
                  CommonText(
                    text: "Special Equipment",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    top: 16,
                    bottom: 8,
                  ),
                  CommonText(
                    text: "Baking sheet, Skillet, Pots",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff272727),
                  ),
            
                  Divider(),
            
                  16.height,
                  CommonButton(
                    titleText: AppString.addToOrder,
                    onTap: () {
                      controller.addToCart({"name": "Quesadilla", "price": "10"});
                    },
                  ),
                  16.height,
                ],
              ),
            ),
          );
        },
      );
    },
    constraints: BoxConstraints(maxHeight: Get.height - 100),
  );
}
