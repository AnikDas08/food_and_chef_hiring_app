import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/image/common_image.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_icons.dart';
import '../../../../../utils/helpers/other_helper.dart';
import '../controller/request_change_chef_controller.dart';

class RequestChangeChefScreen extends StatelessWidget {
  const RequestChangeChefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map order = (Get.arguments as Map?) ?? {};

    debugPrint('🔑 order keys = ${order.keys.toList()}');
    debugPrint("🔑 orderId = ${order['_id']}");

    final ctrl = Get.put(RequestChangeChefController());

    final user = (order['user'] as Map?) ?? {};
    final chef = (order['chef'] as Map?) ?? {};
    final String chefName = (chef['name'] ?? 'Chef').toString();
    final String chefImageRaw = (chef['image'] ?? '').toString();
    final String chefImage = chefImageRaw.startsWith('http')
        ? chefImageRaw
        : 'http://10.10.7.9:5014$chefImageRaw';
    final String address = (order['formatted_address'] ?? 'No address').toString();
    final String strTime = (order['strTime'] ?? '').toString();
    final String formattedDate = _formatDate(order['formatted_date']?.toString());
    final List staticItems = (order['static_items'] as List?) ?? [];
    final double total = _toDouble(order['user_paid']);
    final double orderTotal = _toDouble(order['total_price']);
    final String orderId = (order['_id'] ?? '').toString();
    final String addressId = (order['address_id'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff1A1A1A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Request a Change',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff272727)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reservation Details',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727))),
            8.height,

            CommonTextField(
              controller: ctrl.dateController,
              keyboardType: TextInputType.none,
              hintText: '$formattedDate at $strTime',
              onTap: () => OtherHelper.openDatePickerDialog(ctrl.dateController),
              suffixIcon: InkWell(
                onTap: () => OtherHelper.openDatePickerDialog(ctrl.dateController),
                child: const Icon(Icons.calendar_today, color: Color(0xffFD713F)),
              ),
            ),

            16.height,

            CommonTextField(
              controller: ctrl.timeController,
              keyboardType: TextInputType.none,
              hintText: 'Select time',
              onTap: () => OtherHelper.openTimePickerDialog(ctrl.timeController),
              suffixIcon: InkWell(
                onTap: () => OtherHelper.openTimePickerDialog(ctrl.timeController),
                child: const Icon(Icons.access_time, color: Color(0xffFD713F)),
              ),
            ),

            16.height,

            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CommonImage(
                    imageSrc: AppIcons.location,
                    imageColor: Color(0xffFD713F),
                    size: 24,
                  ),
                  8.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((user['name'] ?? 'Customer').toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff272727))),
                        Text(address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xff777777))),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Color(0xff777777)),
                ],
              ),
            ),

            40.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Details',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272727))),
                Text(
                  "${staticItems.length} item${staticItems.length != 1 ? 's' : ''}",
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xff777777)),
                ),
              ],
            ),

            20.height,

            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: chefImage.isNotEmpty
                      ? Image.network(chefImage,
                      width: 40, height: 40, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackAvatar())
                      : _fallbackAvatar(),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chefName,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff272727))),
                      Text('\$${orderTotal.toStringAsFixed(0)} total',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xff777777))),
                    ],
                  ),
                ),
              ],
            ),

            24.height,

            if (staticItems.isEmpty)
              const Text('No items',
                  style: TextStyle(color: Color(0xff999999)))
            else
              ...staticItems.map((item) {
                final name = (item['menu']?['name'] ?? '').toString();
                final qty = (item['quantity'] ?? 1);
                final price = _toDouble(item['unit_price']);
                final List customs = (item['customizations'] as List?) ?? [];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
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
                                    color: Color(0xff272727))),
                            Text(
                              "$qty item${qty > 1 ? 's' : ''}"
                                  "${customs.isNotEmpty ? ' + ${customs.join(', ')}' : ''}",
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff777777)),
                            ),
                          ],
                        ),
                      ),
                      Text('\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xff272727))),
                    ],
                  ),
                );
              }),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffFFF3EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('This will update your order total',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffFD713F),
                          fontWeight: FontWeight.w500)),
                  Text('\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xffFD713F),
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            28.height,

            const Text('Notes to the Chef',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff272727))),
            8.height,
            CommonTextField(
              controller: ctrl.noteController,
              hintText: 'Enter here',
            ),

            20.height,
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: SafeArea(
          child: Obx(() => CommonButton(
            titleText: ctrl.isLoading.value
                ? 'Requesting...'
                : 'Request and Checkout',
            onTap: ctrl.isLoading.value
                ? null
                : () => ctrl.submitRequest(
              orderId: orderId,
              addressId: addressId,
            ),
          )),
        ),
      ),
    );
  }

  Widget _fallbackAvatar() => Container(
    width: 40,
    height: 40,
    color: const Color(0xffF2F2F2),
    child: const Icon(Icons.person, color: Color(0xffAAAAAA)),
  );

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(iso);
      const m = ['', 'January', 'February', 'March', 'April', 'May',
        'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      return '${dt.day} ${m[dt.month]}, ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}