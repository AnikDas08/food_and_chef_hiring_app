import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';
import '../../../home/presentation/widgets/request_item.dart';
import '../screen/ChefBooking_Detail_Controller.dart';
import '../screen/Request_Change_ChefScreen.dart';
import 'confirmation_booking_pop_up.dart';
import 'decline_pop_up.dart';


class ChefBookingDetailPage extends StatelessWidget {
  final String orderId;
  const ChefBookingDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChefBookingDetailController());
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.fetchOrder(orderId));

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff1A1A1A), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Booking Details",
          style: TextStyle(
            color: Color(0xff1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final order = ctrl.order.value;
        if (order == null) {
          return const Center(child: Text("No data"));
        }
        return _Body(order: order, ctrl: ctrl);
      }),
    );
  }
}


class _Body extends StatelessWidget {
  final Map<String, dynamic> order;
  final ChefBookingDetailController ctrl;
  const _Body({required this.order, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final user = order['user'] as Map? ?? {};
    final String userName = user['name'] ?? "Unknown";
    String userImageRaw = user['image'] ?? "";
    final String userImage = userImageRaw.startsWith('http')
        ? userImageRaw
        : "http://10.10.7.9:5014$userImageRaw";

    final String orderId = order['order_id'] ?? "";
    final String address = order['formatted_address'] ?? "";
    final String strTime = order['strTime'] ?? "";
    final String formattedDate = _formatDate(order['formatted_date']);
    final List staticItems = order['static_items'] ?? [];
    final Map breakdown = order['price_breakdown'] ?? {};
    final double subtotal = (breakdown['subtotal'] ?? 0).toDouble();
    final double tax = (breakdown['taxs'] ?? 0).toDouble();
    final double serviceFee = (breakdown['service_fee'] ?? 0).toDouble();
    final double total = (order['user_paid'] ?? breakdown['total'] ?? 0).toDouble();
    final bool hasDiscount = order['has_discount'] ?? false;
    final double discountAmt = (order['discount_amount'] ?? 0).toDouble();
    final String status = order['status'] ?? "";

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── User card ──
          _card(
            child: Row(
              children: [
                _avatar(userImage),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1A1A1A))),
                      Text(orderId,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xff999999))),
                    ],
                  ),
                ),
                _statusBadge(status),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          _card(
            child: Column(
              children: [
                _infoRow(Icons.location_on_outlined, const Color(0xffFD713F),
                    "Delivery Address", address),
                Divider(height: 20.h, color: const Color(0xffF0F0F0)),
                _infoRow(Icons.calendar_today_outlined, const Color(0xffFD713F),
                    formattedDate, "at $strTime"),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Status",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1A1A1A))),
                SizedBox(height: 20.h),
                _OrderStatusTracker(currentStep: ctrl.currentStep),
                SizedBox(height: 8.h),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          _ExpandableOrderDetails(
            staticItems: staticItems,
            subtotal: subtotal,
            tax: tax,
            serviceFee: serviceFee,
            total: total,
            hasDiscount: hasDiscount,
            discountAmt: discountAmt,
          ),

          SizedBox(height: 20.h),

          _ActionButtons(status: status, order: order),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _avatar(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: url.isNotEmpty
          ? Image.network(url,
          width: 44, height: 44, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackAvatar())
          : _fallbackAvatar(),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      width: 44,
      height: 44,
      color: const Color(0xffF2F2F2),
      child: const Icon(Icons.person, color: Color(0xffAAAAAA)),
    );
  }

  Widget _infoRow(
      IconData icon, Color iconColor, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1A1A1A))),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xff999999))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case "Awaiting Confirmation":
        bg = const Color(0xffF5EDDD);
        fg = const Color(0xffE39400);
        label = "Requested";
        break;
      case "Confirm":
      case "Upcoming":
        bg = const Color(0xffE3ECFD);
        fg = const Color(0xff4285F4);
        label = "Upcoming";
        break;
      case "Completed":
        bg = const Color(0xffDFF5E0);
        fg = const Color(0xff2F8328);
        label = "Completed";
        break;
      default:
        bg = const Color(0xffF2F2F2);
        fg = const Color(0xff777777);
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null) return "N/A";
    try {
      final dt = DateTime.parse(iso);
      const m = [
        '',
        'January','February','March','April','May','June',
        'July','August','September','October','November','December'
      ];
      return "${dt.day} ${m[dt.month]}, ${dt.year}";
    } catch (_) {
      return iso;
    }
  }
}

class _OrderStatusTracker extends StatelessWidget {
  final int currentStep; // 0-based
  const _OrderStatusTracker({required this.currentStep});

  static const _steps = [
    _Step(icon: Icons.calendar_today_outlined, label: "Booking\nOrdered"),
    _Step(icon: Icons.restaurant_outlined, label: "Chef\nConfirmed"),
    _Step(icon: Icons.shopping_cart_outlined, label: "Groceries\nOrdered"),
    _Step(icon: Icons.check_circle_outline_rounded, label: "Booking\nComplete"),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector
          final stepIdx = i ~/ 2;
          final isDone = stepIdx < currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    color: isDone
                        ? const Color(0xff4CAF50)
                        : const Color(0xffE0E0E0),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 8,
                    color: isDone
                        ? const Color(0xff4CAF50)
                        : const Color(0xffE0E0E0)),
                Expanded(
                  child: Container(
                    height: 2,
                    color: isDone
                        ? const Color(0xff4CAF50)
                        : const Color(0xffE0E0E0),
                  ),
                ),
              ],
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final isDone = stepIdx < currentStep;
        final isActive = stepIdx == currentStep;
        return _StepDot(
          step: _steps[stepIdx],
          isDone: isDone,
          isActive: isActive,
        );
      }),
    );
  }
}

class _Step {
  final IconData icon;
  final String label;
  const _Step({required this.icon, required this.label});
}

class _StepDot extends StatelessWidget {
  final _Step step;
  final bool isDone;
  final bool isActive;
  const _StepDot(
      {required this.step, required this.isDone, required this.isActive});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color iconColor;
    if (isDone) {
      bg = const Color(0xff4CAF50);
      iconColor = Colors.white;
    } else if (isActive) {
      bg = const Color(0xffFD713F).withOpacity(0.15);
      iconColor = const Color(0xffFD713F);
    } else {
      bg = const Color(0xffF2F2F2);
      iconColor = const Color(0xffCCCCCC);
    }

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: isActive
                ? Border.all(color: const Color(0xffFD713F), width: 2)
                : null,
          ),
          child: isDone
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
              : Icon(step.icon, color: iconColor, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          step.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? const Color(0xffFD713F)
                : isDone
                ? const Color(0xff4CAF50)
                : const Color(0xffAAAAAA),
          ),
        ),
      ],
    );
  }
}


class _ExpandableOrderDetails extends StatefulWidget {
  final List staticItems;
  final double subtotal, tax, serviceFee, total, discountAmt;
  final bool hasDiscount;

  const _ExpandableOrderDetails({
    required this.staticItems,
    required this.subtotal,
    required this.tax,
    required this.serviceFee,
    required this.total,
    required this.hasDiscount,
    required this.discountAmt,
  });

  @override
  State<_ExpandableOrderDetails> createState() =>
      _ExpandableOrderDetailsState();
}

class _ExpandableOrderDetailsState extends State<_ExpandableOrderDetails> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header tap
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Order Details",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1A1A1A))),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xff777777),
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xffF0F0F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Items
                  if (widget.staticItems.isEmpty)
                    const Text("No items found",
                        style: TextStyle(color: Color(0xff999999)))
                  else
                    ...widget.staticItems.map((item) {
                      final name = item['menu']?['name'] ?? "";
                      final qty = item['quantity'] ?? 1;
                      final price = (item['unit_price'] ?? 0).toDouble();
                      final List customs = item['customizations'] ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff1A1A1A))),
                                  Text(
                                    "$qty item${qty > 1 ? 's' : ''}"
                                        "${customs.isNotEmpty ? ' + ${customs.join(', ')}' : ''}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff999999)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\$${price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1A1A1A)),
                            ),
                          ],
                        ),
                      );
                    }),

                  const Divider(color: Color(0xffF0F0F0)),
                  const SizedBox(height: 8),

                  // Order Summary
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Order Summary",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1A1A1A))),
                  ),
                  const SizedBox(height: 12),
                  _summaryRow("Subtotal",
                      "\$${widget.subtotal.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _summaryRow(
                      "Service Fee", "\$${widget.serviceFee.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _summaryRow(
                      "Estimated Taxes", "\$${widget.tax.toStringAsFixed(2)}"),
                  if (widget.hasDiscount) ...[
                    const SizedBox(height: 8),
                    _summaryRow(
                        "Discount",
                        "-\$${widget.discountAmt.toStringAsFixed(2)}",
                        valueColor: const Color(0xff2F8328)),
                  ],
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xffF0F0F0)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1A1A1A))),
                      Text("\$${widget.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1A1A1A))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13, color: Color(0xff777777))),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                color: valueColor ?? const Color(0xff1A1A1A))),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String status;
  final Map order;
  const _ActionButtons({required this.status, required this.order});

  Future<void> _openChat(Map order) async {
    try {
      final userId = order['user']?['_id']?.toString() ?? "";
      final userName = order['user']?['name']?.toString() ?? "User";
      final userImage = order['user']?['image']?.toString() ?? "";
      if (userId.isEmpty) return;

      final response = await ApiService.post("chat/$userId", body: {});

      if (response.statusCode == 200 && response.data != null) {
        final chatId = response.data['data']['_id']?.toString() ?? "";

        Get.toNamed(AppRoutes.message, parameters: {
          'chatId': chatId,
          'name': userName,
          'image': userImage,
        });
      } else {
        Get.snackbar("Error", "Failed to open chat");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    // Awaiting Confirmation
    if (status == "Awaiting Confirmation" || status == "Unconfirmed") {
      return Row(
        children: [
          Expanded(
            child: _btn(
              label: "Decline",
              color: const Color(0xffF2F2F2),
              textColor: const Color(0xffFF3C3C),
              onTap: () {
                declineBookingPopUp(
                  orderId: order['_id']?.toString() ?? "",
                  onSuccess: () {
                    final homeC = Get.find<ChefHomeController>();
                    homeC.fetchRequestedBookings();
                    Get.back();
                    Get.snackbar("Success", "Booking declined");
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _btn(
              label: "Accept",
              color: const Color(0xff1A1A1A),
              textColor: Colors.white,
              onTap: () {
                confirmBookingPopUp(
                    orderMongoId: order['_id']?.toString() ?? "");
              },


            ),
          ),
          const SizedBox(width: 10),
          _iconBtn(Icons.chat_bubble_outline_rounded, onTap: () => _openChat(order)),

        ],
      );
    }

    if (status == "Confirm" || status == "Upcoming") {
      return Row(
        children: [
          Expanded(
            child: _btn(
              label: "Cancel Booking",
              color: const Color(0xffF2F2F2),
              textColor: const Color(0xffFF3C3C),
              onTap: () {
                cancelBookingPopUp(
                  orderId: order['_id']?.toString() ?? "",
                  onSuccess: () {
                    final homeC = Get.find<ChefHomeController>();
                    homeC.fetchUpcomingBookings();
                    Get.back();
                    Get.snackbar("Success", "Booking cancelled successfully");
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _btn(
              label: "Request a Change",
              color: const Color(0xffF2F2F2),
              textColor: const Color(0xff1A1A1A),
              onTap: () {

                Get.to(() => RequestChangeChefScreen(), arguments: order);

              },
            ),
          ),
          const SizedBox(width: 10),
          _iconBtn(Icons.chat_bubble_outline_rounded, onTap: () => _openChat(order)),

        ],
      );
    }

    return Row(
      children: [

        Expanded(
          child: _btn(
            label: "Chat with Customer",
            color: const Color(0xff1A1A1A),
            textColor: Colors.white,
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () => _openChat(order),
          ),
        ),
        const SizedBox(width: 10),
        _iconBtn(Icons.edit_outlined, onTap: () {}),
      ],
    );
  }

  Widget _btn({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 18),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: const Color(0xff1A1A1A), size: 22),
      ),
    );
  }
}


void stopConfirmationPopUp({
  required Duration totalTime,
  required String orderId,
  required VoidCallback onSuccess,
}) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => _StopConfirmationDialog(
      totalTime: totalTime,
      orderId: orderId,
      onConfirm: () {
        Get.back(); // dialog বন্ধ
        onSuccess();
      },
      onCheckAgain: () => Get.back(),
    ),
  );
}
class _StopConfirmationDialog extends StatelessWidget {
  final Duration totalTime;
  final String orderId;
  final VoidCallback onConfirm;
  final VoidCallback onCheckAgain;

  const _StopConfirmationDialog({
    required this.totalTime,
    required this.orderId,
    required this.onConfirm,
    required this.onCheckAgain,
  });

  String _formatShort(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5A623),
              ),
              child: Icon(Icons.priority_high_rounded,
                  color: Colors.white, size: 28.r),
            ),
            SizedBox(height: 16.h),
            Text(
              "Are you sure you're done?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Are you sure that all recipes have been prepared and the kitchen is cleaned up?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Total cooking time: ${_formatShort(totalTime)}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 20.h),

            // I'm sure button
            GestureDetector(
              onTap: () async {
                try {
                  final timeString = _formatShort(totalTime);
                  final response = await ApiService.post(
                    "order/clearence/$orderId",
                    body: {"time": timeString},
                  );
                  if (response.statusCode == 200 || response.statusCode == 201) {
                    onConfirm(); // ← Get.back() না, onConfirm call করো
                  } else {
                    Get.snackbar("Error", "Failed to submit cooking time");
                  }
                } catch (e) {
                  Get.snackbar("Error", e.toString());
                }
              },
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    "I'm sure",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // Check again button
            GestureDetector(
              onTap: onCheckAgain,
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    'Check again',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void showChefBookingDetailPopup(BuildContext context, String orderId) {

  if (Get.isRegistered<ChefBookingDetailController>()) {
    Get.delete<ChefBookingDetailController>(force: true);
  }

  final ctrl = Get.put(ChefBookingDetailController());
  ctrl.fetchOrder(orderId);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    "Booking Details",
                    style: TextStyle(
                      color: const Color(0xff1A1A1A),
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final order = ctrl.order.value;
                if (order == null) {
                  return const Center(child: Text("No data"));
                }
                return _Body(order: order, ctrl: ctrl);
              }),
            ),
          ],
        ),
      );
    },
  );
}