import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/component/image/common_image.dart';
import 'package:new_untitled/component/text/common_text.dart';
import 'package:new_untitled/utils/constants/app_images.dart';
import 'package:new_untitled/utils/constants/app_string.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../chef_booking_control/Cooking_OrderItem_page/Cooking_OrderItem.dart';
import '../../../chef_booking_control/widgets/BookingDetailsSheet.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';
import '../../../home/presentation/widgets/request_item.dart';
import '../controller/chef_booking_controller.dart';
import 'booking_details_popup.dart';
import 'confirmation_booking_pop_up.dart';
import 'decline_pop_up.dart';
import 'upcoming_pop_up.dart';

Widget chefBookingItem({required Map order}) {

  final controller = Get.find<ChefBookingController>();

  final String orderId = order['order_id'] ?? '';
  final String userName = order['user']?['name'] ?? '';
  final String userImageRaw = order['user']?['image'] ?? '';
  final String userImage = userImageRaw.startsWith('http')
      ? userImageRaw
      : 'http://10.10.7.9:5014$userImageRaw';  final String status = order['status'] ?? '';
  final String address = order['formatted_address'] ?? '';
  final String strTime = order['strTime'] ?? '';
  final double totalPrice = (order['user_paid'] ?? 0).toDouble();
  final double rating = (order['rating'] ?? 0).toDouble();
  final String review = order['review'] ?? '';
  final String deadline = order['deadline'] ?? '';
  final String cookingTime = order['duration'] ?? '';

  final List staticItems = order['static_items'] ?? [];
  final String itemsText = staticItems.map((item) {
    final String name = item['menu']?['name'] ?? '';
    final int qty = item['quantity'] ?? 1;
    return '$qty× $name';
  }).join(', ');
  final String itemsLabel = "${staticItems.length} item${staticItems.length > 1 ? 's' : ''} ($itemsText)";

  final String formattedDate = _formatDate(order['formatted_date']);
  final String dateLabel = '$formattedDate at $strTime';
  final String timeLeft = _timeLeft(deadline);

  return InkWell(
    onTap: () {
      bookingDetailsPopup(
        Get.context!,
        order: order,
        selectedTab: controller.selectedBookingHistory,
      );
    },
    child: Container(
      padding: EdgeInsets.all(12.sp).copyWith(right: 0),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonImage(
                imageSrc: userImage.isNotEmpty ? userImage : AppImages.image3,
                size: 40,
                borderRadius: 50,
                fill: BoxFit.fill,
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: userName,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff272727),
                    ),
                    CommonText(
                      text: orderId,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff777777),
                    ),
                  ],
                ),
              ),

              _statusBadge(controller.selectedBookingHistory),

              if (controller.selectedBookingHistory != 'Completed')
                PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  menuPadding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    if (value == 1) {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );

                      try {
                        final c = Get.find<ChefBookingController>();
                        final orderData = await c.fetchSingleOrder(order['_id'] ?? '');

                        if (Get.isDialogOpen == true) Navigator.pop(Get.context!);

                        if (orderData != null) {
                          upcomingPopUp(orderData: orderData);
                        } else {
                          Get.snackbar('Error', 'Could not load order details');
                        }
                      } catch (e) {
                        if (Get.isDialogOpen == true) Navigator.pop(Get.context!);
                        Get.snackbar('Error', 'Something went wrong');
                      }
                    }

                    if (value == 2) {
                      cancelBookingPopUp(
                        orderId: order['_id']?.toString() ?? '',
                        onSuccess: () {
                          controller.fetchOrders();
                          Get.snackbar('Success', 'Booking cancelled');
                        },
                      );
                    }
                  },
                  itemBuilder: (context) {
                    final isUpcoming = controller.selectedBookingHistory == 'Upcoming';

                    return [
                      if (isUpcoming)
                        const PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20, color: Colors.black),
                              SizedBox(width: 10),
                              CommonText(text: 'Request a Change'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.close, size: 20, color: Colors.red),
                            SizedBox(width: 10),
                            CommonText(
                              text: 'Cancel Booking',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
            ],
          ),

          24.height,

          Row(
            children: [
              const CommonImage(
                imageSrc: AppIcons.date,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              Expanded(
                child: CommonText(
                  text: dateLabel,
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          15.height,

          Row(
            children: [
              const CommonImage(
                imageSrc: AppIcons.ingredients,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              Expanded(
                child: CommonText(
                  text: itemsLabel,
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start, // ✅ add
                ),
              ),
            ],
          ),
          8.height,


          Row(
            children: [
              const CommonImage(
                imageSrc: AppIcons.location,
                size: 16,
                imageColor: Color(0xff777777),
              ),
              Expanded(
                child: CommonText(
                  text: address,
                  fontSize: 12,
                  left: 4,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start, // ✅ add
                ),
              ),
            ],
          ),
          8.height,

          if (cookingTime.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.time,
                    size: 16,
                    color: Color(0xff777777),
                  ),
                  const SizedBox(width: 4),
                  CommonText(
                    text: 'Estimated cooking time: $cookingTime',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff272727),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          8.height,

          if (controller.selectedBookingHistory != 'Completed')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.info, color: Color(0xffFD713F), size: 16),
                  CommonText(
                    text: timeLeft.isNotEmpty
                        ? 'You have $timeLeft left to confirm the order'
                        : 'Deadline passed',
                    fontSize: 12,
                    left: 4,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffFD713F),
                  ),
                ],
              ),
            ),

          if (controller.selectedBookingHistory == 'Completed' && review.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Review',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727),
                    bottom: 8,
                  ),
                  CommonText(
                    text: review,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff272727),
                    maxLines: 3,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),

          20.height,

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Hourly rate',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777777),
                  ),
                  CommonText(
                    text: '\$${totalPrice.toStringAsFixed(2)}',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff272727),
                    top: 2,
                  ),
                ],
              ),
              const Spacer(),

              // ✅ Unconfirmed: Decline + Accept
              if (controller.selectedBookingHistory == 'Unconfirmed') ...[
                InkWell(
                  onTap: () {
                    declineBookingPopUp(
                      orderId: order['_id'] ?? '',
                      onSuccess: () {
                        controller.fetchOrders();
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: const CommonText(
                      text: AppString.decline,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFF3C3C),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    confirmBookingPopUp(orderMongoId: order['_id']?.toString() ?? '');                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    margin: EdgeInsets.only(left: 8.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xff272727),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: const CommonText(
                      text: AppString.accept,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                12.width,
              ],
              if (controller.selectedBookingHistory == 'Upcoming') ...[

                // ✅ Chat with Customer
                InkWell(
                  onTap: () async {
                    try {
                      final userId = order['user']?['_id']?.toString() ?? '';
                      if (userId.isEmpty) return;

                      final response = await ApiService.post('chat/$userId', body: {});

                      if (response.statusCode == 200 || response.statusCode == 201) {
                        final chatData = response.data['data'];
                        final chatId = chatData['_id']?.toString() ?? '';
                        Get.toNamed(AppRoutes.message, parameters: {
                          'chatId': chatId,
                          'name': order['user']?['name'] ?? 'User',
                          'image': order['user']?['image'] ?? '',
                        });
                      } else {
                        Get.snackbar('Error', 'Failed to open chat');
                      }
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min, // ✅ এটা যোগ করুন
                      children: [
                        CommonImage(
                          imageSrc: AppIcons.chat,
                          size: 16,
                          imageColor: Color(0xff272727),
                        ),
                        CommonText(
                          text: AppString.chatWithCustomer,
                          fontSize: 12,
                          left: 6,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () async {
                    final realOrderId = order['_id']?.toString() ?? '';
                    if (realOrderId.isEmpty) {
                      Get.snackbar('Error', 'Order ID not found');
                      return;
                    }

                    final homeC = Get.find<ChefHomeController>();

                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      final orderData = await homeC.fetchSingleOrder(realOrderId); // ✅ real ID দিয়ে
                      Navigator.pop(Get.context!);

                      if (orderData != null) {
                        final user = orderData['user'] ?? {};
                        final staticItems = orderData['static_items'] as List? ?? [];
                        final breakdown = orderData['price_breakdown'] ?? {};

                        BookingDetailsSheet.show(
                          Get.context!,
                          booking: BookingDetailsModel(
                            chefName: user['name'] ?? '',
                            bookingId: orderData['order_id'] ?? '',
                            chefImage: user['image'] ?? '',
                            status: orderData['status'] ?? '',
                            customerName: user['name'] ?? '',
                            address: orderData['formatted_address'] ?? '',
                            date: _formatDate(orderData['formatted_date']),
                            time: orderData['strTime'] ?? '',
                            orderItems: staticItems.map((item) => OrderItem(
                              name: item['menu']?['name'] ?? '',
                              description: '${item['quantity']} Items + ${(item['customizations'] as List?)?.join(', ') ?? ''}',
                            )).toList(),
                            estimatedTime: orderData['duration'] ?? '',
                            hourlyRate: (breakdown['subtotal'] ?? 0).toDouble(),
                            estimatedTaxes: (breakdown['taxs'] ?? 0).toDouble(),
                            onStartCooking: () {
                              Navigator.pop(Get.context!);
                              Get.to(() => CookingStopwatchScreen(
                                orderId: realOrderId, // ✅ real ID
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
                      if (Get.isDialogOpen == true) Navigator.pop(Get.context!);
                      Get.snackbar('Error', 'Something went wrong');
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xff272727),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.flame, size: 16, color: Colors.white),
                        CommonText(
                          text: 'Start Cooking',
                          fontSize: 12,
                          left: 6,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

              ],

              if (controller.selectedBookingHistory == 'Completed') ...[





                Container(
                  margin: EdgeInsets.only(right: 5.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  child: Row(
                    children: [

                      CommonText(
                        text: "${AppString.rating} ${rating > 0 ? rating.toStringAsFixed(1) : 'N/A'}",
                        fontSize: 12,
                        right: 6,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff272727),
                      ),
                      if (rating > 0)
                        const Icon(
                          Icons.star_rate_rounded,
                          size: 12,
                          color: Color(0xffFD713F),
                        ),
                    ],
                  ),
                ),




                InkWell(
                  onTap: () {
                    reviewPopUp(
                      orderId: order['_id']?.toString() ?? '',
                      onSuccess: () => controller.fetchOrders(),
                    );
                  },

                  child: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                    child: const Row(
                      children: [


                        CommonText(
                          text: 'Rate Customer',
                          fontSize: 12,
                          right: 6,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff272727),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _statusBadge(String selectedTab) {
  switch (selectedTab) {
    case 'Unconfirmed':
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: const Color(0xffF5EDDD),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const CommonText(
          text: 'Requested',
          fontSize: 10,
          color: Color(0xffE39400),
        ),
      );
    case 'Upcoming':
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: const Color(0xffE3ECFD),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: const CommonText(
          text: 'Upcoming',
          fontSize: 10,
          color: Color(0xff4285F4),
        ),
      );
    default:
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        decoration: BoxDecoration(
          color: const Color(0xffDFF5E0),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: const CommonText(
          text: 'Completed',
          fontSize: 10,
          color: Color(0xff2F8328),
        ),
      );
  }
}

String _formatDate(String? isoDate) {
  if (isoDate == null) return '';
  try {
    final DateTime dt = DateTime.parse(isoDate);
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${dt.day} ${months[dt.month]}, ${dt.year}';
  } catch (_) {
    return isoDate;
  }
}

String _timeLeft(String? deadlineIso) {
  if (deadlineIso == null || deadlineIso.isEmpty) return '';
  try {
    final DateTime deadline = DateTime.parse(deadlineIso);
    final Duration diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return '';
    final int hours = diff.inHours;
    final int minutes = diff.inMinutes % 60;
    if (hours > 0) return '${hours}h${minutes}m';
    return '${minutes}m';
  } catch (_) {
    return '';
  }
}

void reviewPopUp({
  required String orderId,
  required VoidCallback onSuccess,
}) {
  double kitchenRating = 0;
  double communicationRating = 0;
  final reviewController = TextEditingController();

  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        final avg = (kitchenRating + communicationRating) / 2;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Leave a Review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),

                // Kitchen Readiness
                const Text('Kitchen readiness',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _StarRatingRow(
                  rating: kitchenRating,
                  onChanged: (v) => setState(() => kitchenRating = v),
                ),
                const SizedBox(height: 16),

                // Communication
                const Text('Communication',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _StarRatingRow(
                  rating: communicationRating,
                  onChanged: (v) => setState(() => communicationRating = v),
                ),
                const SizedBox(height: 16),

                // Average
                Row(
                  children: [
                    const Text('Average Rating',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    ...List.generate(5, (i) => Icon(
                      i < avg.floor()
                          ? Icons.star_rounded
                          : (i < avg && avg % 1 >= 0.5)
                          ? Icons.star_half_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xffFD713F),
                      size: 20,
                    )),
                    const SizedBox(width: 4),
                    Text(avg > 0 ? avg.toStringAsFixed(1) : '0.0',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 20),

                // Review text
                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write your review...',
                    filled: true,
                    fillColor: const Color(0xffF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1A1A1A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: kitchenRating == 0 || communicationRating == 0
                        ? null
                        : () async {
                      try {
                        final response = await ApiService.post(
                          ApiEndPoint.ChefReview,
                          body: {
                            'order_id': orderId,
                            'communication': communicationRating,
                            'kitchen_readiness': kitchenRating,
                            'review': reviewController.text.trim(),
                          },
                        );
                        if (response.statusCode == 200 &&
                            response.data['success'] == true) {
                          Navigator.pop(Get.context!);
                          onSuccess();
                          Get.snackbar('Success', 'Review submitted!',
                              backgroundColor: Colors.green,
                              colorText: Colors.white);
                        } else {
                          Get.snackbar(
                            'Error',
                            response.data['message'] ?? 'Something went wrong',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (e) {
                        Get.snackbar('Error', e.toString(),
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    child: const Text('Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}

class _StarRatingRow extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  const _StarRatingRow({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(5, (i) {
          return GestureDetector(
            onTap: () => onChanged((i + 1).toDouble()),
            child: Icon(
              i < rating ? Icons.star_rounded : Icons.star_border_rounded,
              color: const Color(0xffFD713F),
              size: 32,
            ),
          );
        }),
      ),
    );
  }
}