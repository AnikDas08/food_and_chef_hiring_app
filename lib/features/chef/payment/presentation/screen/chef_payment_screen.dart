import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/common_button.dart';
import 'package:new_untitled/component/button/switch_button.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/extensions/extension.dart';

import '../../../../../component/text/common_text.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../analytics/presentation/widgets/earning.dart';
import '../controller/chef_payment_controller.dart';

class ChefPaymentScreen extends StatelessWidget {
  const ChefPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: 'Payment',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xff272727),
        ),
      ),
      body: GetBuilder<ChefPaymentController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // const CommonImage(
                  //   imageSrc: AppImages.paymentCard,
                  //   height: 180,
                  //   fill: BoxFit.fill,
                  // ),
                  //
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       activeColor: const Color(0xffFD713F),
                  //       value: controller.isMainAccount,
                  //       onChanged: controller.onChangeMainAccount,
                  //     ),
                  //     const CommonText(
                  //       text: 'Make it the main account',
                  //       fontSize: 12,
                  //       color: Color(0xff272727),
                  //     ),
                  //   ],
                  // ),

                  8.height,

                  CommonButton(

                    titleText: 'Add New Account',

                    onTap: () => Get.toNamed(AppRoutes.addPaymentMethod),

                  ),

                  12.height,

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Get.toNamed(AppRoutes.withdraw),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonImage(
                                  imageSrc: AppIcons.download,
                                  height: 20,
                                  width: 20,
                                ),
                                CommonText(
                                  text: 'Withdraw',
                                  left: 8,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff272727),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      12.width,

                      Expanded(
                        child: InkWell(
                          onTap: () => Get.toNamed(AppRoutes.history),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonImage(
                                  imageSrc: AppIcons.clock,
                                  height: 20,
                                  width: 20,
                                ),
                                CommonText(
                                  text: 'History',
                                  left: 8,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff272727),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  earning(),

                  36.height,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CommonText(
                        text: 'Enable automatic payments',
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727),
                      ),

                      Obx(
                            () => switchButton(
                          value: controller.isAutoPayment.value,
                          onTap: () => controller.autoPaymentToggle(),
                          color: const Color(0xffFD713F),
                        ),
                      ),
                    ],
                  ),

                  24.height,

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xffFD713F)),
                        Expanded(
                          child: CommonText(
                            text:
                                'The process will be done automatically once the amount reaches \$100.',
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFD713F),
                            fontSize: 12,
                            left: 12,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
