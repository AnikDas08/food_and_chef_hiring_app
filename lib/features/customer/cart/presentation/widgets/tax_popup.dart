import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_string.dart';

taxPopup() {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return AnimationPopUp(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          ),
          builder: (context, child) {
            return FadeTransition(
              opacity: ModalRoute.of(context)!.animation!,
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                backgroundColor: Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CommonText(
                              text:
                              AppString
                                  .pleaseSelectTheTaxDetailsYouWantToUse,
                              fontSize: 16,
                              top: 16,
                              bottom: 8,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              AnimationPopUpState.closeDialog();
                            },
                            child: Icon(
                              Icons.close,
                              color: Color(0xffABABAB),
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 15.sp,
                            width: 15.sp,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.sp,
                            ),
                          ),
                          12.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText(
                                  text: "Business tax profile",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff272727),
                                ),
                                CommonText(
                                  text: "Privae LLC (New York)",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff777777),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.businessTaxDetails);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CommonText(text: "Edit"),
                            ),
                          ),
                        ],
                      ),

                      30.height,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 15.sp,
                            width: 15.sp,
                            decoration: BoxDecoration(
                              color: Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          12.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText(
                                  text: "Personal tax profile",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff272727),
                                ),
                                CommonText(
                                  text: "Add tax details",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff777777),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.personalTaxDetails);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CommonText(text: "Add"),
                            ),
                          ),
                        ],
                      ),

                      16.height,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}