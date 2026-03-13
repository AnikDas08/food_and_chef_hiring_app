import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/button/switch_button.dart';
import 'package:new_untitled/component/text_field/common_text_field.dart';
import 'package:new_untitled/features/chef/home/presentation/screen/App_Information_Screen.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/other_widgets/app_bar_opacity.dart';
import '../../../../../component/other_widgets/item.dart';
import '../../../../../component/pop_up/common_pop_menu.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../../../../common/auth/signup_chef/presentation/screen/BankManagementPage.dart';
import '../../../../customer/profile/presentation/widgets/profile_list.dart';
import '../../../chef_booking_control/Cooking_OrderItem_page/Cooking_OrderItem.dart';
import '../../../chef_booking_control/widgets/BookingDetailsSheet.dart';
import '../../../chef_booking_control/widgets/Booking_Banner_Popup.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';
import '../controller/chef_profile_controller.dart';

class ChefProfileScreen extends StatelessWidget {
  const ChefProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: appBarOpacity(),
        title: const CommonText(
          text: AppString.myProfile,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Color(0xff272727),
        ),
      ),

      /// Body Section Starts here
      body: GetBuilder<ChefProfileController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView(
              children: [
                12.height,
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    border: Border.all(color: Color(0xffF1F1F1)),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        final profile = Get.find<ChefHomeController>().chefProfile.value;
                        return Row(
                          children: [
                            CommonImage(
                              imageSrc: profile?.image.isNotEmpty == true
                                  ? Uri.parse(ApiEndPoint.imageUrl).resolve(profile!.image).toString()
                                  : AppImages.image3,
                              size: 52,
                              fill: BoxFit.fill,
                              borderRadius: 50,
                            ),
                            12.width,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: profile?.name ?? 'Unknown',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff272727),
                                  ),
                                  CommonText(
                                    text: profile?.email ?? '',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff777777),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      //16.height,
                      // CommonTextField(
                      //   keyboardType: TextInputType.none,
                      //   borderColor: Color(0xffF1F1F1),
                      //   borderRadius: 8,
                      //   fillColor: Color(0xffFDFDFD),
                      //   paddingVertical: 14,
                      //   prefixIcon: Padding(
                      //     padding: const EdgeInsets.only(left: 8.0),
                      //     child: CommonImage(
                      //       imageSrc: controller.selectedProfile['image'],
                      //       size: 30,
                      //     ),
                      //   ),
                      //   hintText: controller.selectedProfile['name'],
                      //   hintTextColor: Color(0xff272727),
                      //   suffixIcon: ProfileList(
                      //     items: controller.profileOptions,
                      //     selectedItem: controller.selectedProfile,
                      //     onTap: controller.onChangeProfile,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  margin: EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.customers,
                        title: AppString.seePublicProfile,
                        onTap: () => {
                          print("id: 😊😊😊😊😊😊😊${LocalStorage.userId}"),
                          Get.toNamed(AppRoutes.chefDetails, arguments: LocalStorage.userId)
                        },
                      ),
                    ],
                  ),
                ),

                /// Edit Profile item here
                CommonText(
                  text: AppString.account,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 12,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      Item(
                        image: AppIcons.chefIcon,
                        title: AppString.profileSettings,
                        imageSize: 24,
                        onTap: () => Get.toNamed(AppRoutes.chefEditProfile),
                      ),

                      /// Setting item here
                      Item(
                        image: AppIcons.date,
                        title: AppString.availability,
                        imageSize: 24,
                        onTap: () => Get.toNamed(AppRoutes.availability),
                      ),
                      Item(
                        image: AppIcons.card,
                        icon: CupertinoIcons.creditcard,
                        title: AppString.paymentMethods,
                        onTap: () => Get.toNamed(AppRoutes.chefPayment),
                      ),

                      Item(
                        image: AppIcons.card,
                        icon: CupertinoIcons.arrow_swap,
                        title: AppString.bankManagement,
                        onTap: () {
                          final profile = Get.find<ChefHomeController>().chefProfile.value;
                          final stripeUrl = profile?.stripeLoginLink; // বা যে field নামে আছে

                          if (stripeUrl != null && stripeUrl.isNotEmpty) {
                            Get.to(() => StripeWebViewPage(url: stripeUrl));
                          } else {
                            Get.to(() => const BankManagementPage());
                          }
                        },
                      ),


                      Item(
                        image: AppIcons.kitchen,
                        title: AppString.menuItems,
                        onTap: () => Get.toNamed(AppRoutes.menu),
                      ),

                      Item(
                        icon: CupertinoIcons.person,
                        title: AppString.accountSettings,
                        onTap: () => Get.toNamed(AppRoutes.accountSetting),
                      ),
                      14.height,
                      Obx(
                            () => Row(
                          children: [
                            Icon(CupertinoIcons.bell),
                            CommonText(
                              text: AppString.notifications,
                              left: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727),
                            ),
                            Spacer(),
                            switchButton(
                              value: controller.isNotification.value,
                              onTap: () => controller.notification(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                CommonText(
                  text: AppString.other,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xff777777),
                  top: 28,
                  bottom: 12,
                ).start,

                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F2F2),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        child: Item(
                          icon: CupertinoIcons.question_circle,
                          title: AppString.contactSupport,
                          onTap: (){


                            // Aleart popup for chef



                            BookingBannerPopup.show(
                              context,
                              image: AppImages.profile, // অথবা null দিলে default icon
                              title: 'Your booking with Jimmy starts in 1 hour',
                              subtitle: 'Click here when you\'ve arrived to the customer and you\'re ready to start cooking!',
                              onTap: () {


                                BookingBannerPopup.show(
                                  context,
                                  image: AppImages.profile,
                                  title: 'Your booking with Jimmy starts in 1 hour',
                                  subtitle: 'Click here when you\'ve arrived...',
                                  onTap: () async {


                                    final homeC = Get.find<ChefHomeController>();

                                    Get.dialog(
                                      const Center(child: CircularProgressIndicator()),
                                      barrierDismissible: false,
                                    );

                                    try {
                                      final order = await homeC.fetchSingleOrder("69a66ebdf0507595e4636281");
                                      Get.back();

                                      if (order != null) {
                                        final user = order['user'] ?? {};
                                        final staticItems = order['static_items'] as List? ?? [];
                                        final breakdown = order['price_breakdown'] ?? {};

                                        BookingDetailsSheet.show(
                                          context,
                                          booking: BookingDetailsModel(
                                            chefName: user['name'] ?? '',
                                            bookingId: order['order_id'] ?? '',
                                            chefImage: user['image'] ?? '',
                                            status: order['status'] ?? '',
                                            customerName: user['name'] ?? '',
                                            address: order['formatted_address'] ?? '',
                                            date: order['formatted_date'] ?? '',
                                            time: order['strTime'] ?? '',
                                            orderItems: staticItems.map((item) => OrderItem(
                                              name: item['menu']?['name'] ?? '',
                                              description: '${item['quantity']} Items + ${(item['customizations'] as List?)?.join(', ') ?? ''}',
                                            )).toList(),
                                            estimatedTime: order['duration'] ?? '',
                                            hourlyRate: (breakdown['subtotal'] ?? 0).toDouble(),
                                            estimatedTaxes: (breakdown['taxs'] ?? 0).toDouble(),
                                            onStartCooking: () {
                                              Get.back();
                                              Get.to(() => CookingStopwatchScreen(
                                                orderId: order['_id']?.toString() ?? "",
                                                orderItems: staticItems.map((item) => CookingOrderItem(
                                                  name: '${item['menu']?['name']} (x${item['quantity']})',
                                                  description: (item['customizations'] as List?)?.join(', ') ?? '',
                                                )).toList(),
                                              ));
                                            },
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      Get.back();
                                      Get.snackbar("Error", "Something went wrong");
                                    }
                                  },
                                );

                              },
                            );

                          },
                        ),
                      ),

                      Item(
                        icon: CupertinoIcons.info,
                        title: AppString.appVersion,
                        onTap: (){

                          Get.to(AppInformationScreen());

                        },
                      ),
                    ],
                  ),
                ),

                Item(
                  image: AppIcons.logout,
                  color: Color(0xffFF0000),
                  imgColor: Color(0xffFF0000),
                  title: AppString.signOut,
                  onTap: logOutPopUp,
                  disableDivider: true,
                  disableIcon: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
