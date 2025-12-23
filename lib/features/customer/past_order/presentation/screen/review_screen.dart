import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_string.dart';
import '../../../cart/presentation/widgets/order_summary.dart';
import '../widgets/review_success_pop_up.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({super.key});

  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: "Leave Chef Rating",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                12.width,
                CommonImage(
                  imageSrc: AppImages.image3,
                  size: 40,
                  borderRadius: 50,
                  fill: BoxFit.fill,
                ),

                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                        text: "Javier A.",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                        bottom: 2,
                        left: 3,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Color(0xffFD713F)),
                          CommonText(
                            text: "4.5  (482 Reviews)",
                            fontSize: 12,
                            left: 2,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff777777),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                    vertical: 5.sp,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffDBEBD9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CommonText(
                    text: "Completed",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff2F8328),
                  ),
                ),
              ],
            ),

            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: AppString.orderDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff272727),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Color(0xff777777),
                ),
              ],
            ),
            28.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Chopped Burrito",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4E4E4E),
                    ),
                    CommonText(
                      text: "2 Items + Without Onions",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                CommonText(
                  text: "\$45.00",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
            12.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Chopped Burrito",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4E4E4E),
                    ),
                    CommonText(
                      text: "2 Items + Without Onions",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff777777),
                    ),
                  ],
                ),
                CommonText(
                  text: "\$45.00",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff272727),
                ),
              ],
            ),
            32.height,
            orderSummary(),
            28.height,

            CommonText(
              text: "Reviews",
              bottom: 16,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),

            CommonTextField(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              controller: TextEditingController(
                text:
                    "Javier was awesome! The food was so delicious! Everything was well done, and it made the experience great. I’d love to work with Javier again!",
              ),
            ),
            CommonText(
              text: "Ratings",
              bottom: 16,
              top: 16,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727),
            ),
            _ratingItem("Quality and Taste"),
            _ratingItem("Cleanliness"),
            _ratingItem("Timeliness"),
            _ratingItem("Friendliness"),
            _ratingItem("Communication"),
            8.height,
            Container(
              padding: EdgeInsets.all(12),
              width: Get.width,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: "Average Rating",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                  Spacer(),
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    wrapAlignment: WrapAlignment.spaceEvenly,
                    itemBuilder:
                        (context, _) => Icon(
                          Icons.star_rounded,
                          color: Color(0xffFD713F),
                          size: 20,
                        ),
                    onRatingUpdate: (rating) {},
                  ),

                  CommonText(
                    text: "4.5",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: CommonButton(
              titleText: AppString.submit,
              onTap: reviewSuccessPopUp,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _ratingItem(String title) {
  return Container(
    padding: EdgeInsets.all(12),
    width: Get.width,
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Color(0xffF2F2F2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        CommonText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xff272727),
          bottom: 4,
        ).start,
        RatingBar.builder(
          initialRating: 4,
          minRating: 1,
          direction: Axis.horizontal,

          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          wrapAlignment: WrapAlignment.center,
          itemPadding: EdgeInsets.symmetric(horizontal: 10),
          itemBuilder:
              (context, _) =>
                  Icon(Icons.star_rounded, color: Color(0xffFD713F), size: 40),
          onRatingUpdate: (rating) {},
        ),
      ],
    ),
  );
}
