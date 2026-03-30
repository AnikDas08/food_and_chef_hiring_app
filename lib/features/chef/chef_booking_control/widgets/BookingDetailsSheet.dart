import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsSheet {
  static void show(BuildContext context, {required BookingDetailsModel booking}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingDetailsContent(booking: booking),
    );
  }
}

// ── Data Models ──
class BookingDetailsModel {
  final String chefName;
  final String bookingId;
  final String? chefImage;
  final String status;
  final String customerName;
  final String address;
  final String date;
  final String time;
  final List<OrderItem> orderItems;
  final String estimatedTime;
  final double hourlyRate;
  final double estimatedTaxes;
  final VoidCallback? onStartCooking;

  const BookingDetailsModel({
    required this.chefName,
    required this.bookingId,
    this.chefImage,
    required this.status,
    required this.customerName,
    required this.address,
    required this.date,
    required this.time,
    required this.orderItems,
    required this.estimatedTime,
    required this.hourlyRate,
    required this.estimatedTaxes,
    this.onStartCooking,
  });

  double get hourlyTotal => hourlyRate + estimatedTaxes;
}

class OrderItem {
  final String name;
  final String description;

  const OrderItem({required this.name, required this.description});
}

// ── Main Content Widget ──
class _BookingDetailsContent extends StatelessWidget {
  final BookingDetailsModel booking;

  const _BookingDetailsContent({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChefHeader(),
                  SizedBox(height: 20.h),
                  _buildDivider(),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    iconColor: const Color(0xFFE84325),
                    title: booking.customerName,
                    subtitle: booking.address,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    icon: Icons.calendar_month_outlined,
                    iconColor: const Color(0xFFE84325),
                    title: booking.date,
                    subtitle: booking.time,
                  ),
                  SizedBox(height: 20.h),
                  _buildDivider(),
                  SizedBox(height: 16.h),
                  _buildOrderDetails(),
                  SizedBox(height: 20.h),
                  _buildDivider(),
                  SizedBox(height: 16.h),
                  _buildOrderSummary(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          _buildStartCookingButton(context),
        ],
      ),
    );
  }

  Widget _buildChefHeader() {
    return Row(
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: ClipOval(
            child: booking.chefImage != null
                ? Image.network(
              booking.chefImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.person_rounded, color: Colors.grey[400], size: 28.r),
            )
                : Icon(Icons.person_rounded, color: Colors.grey[400], size: 28.r),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.chefName,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                booking.bookingId,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // Status badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF3FF),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            booking.status,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF3D5AFE),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: iconColor, size: 18.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Details',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 12.h),
        ...booking.orderItems.map(
              (item) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 12.h),

        // Estimated cooking time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estimated cooking time:',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            Text(
              booking.estimatedTime,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'For scheduling only: Billing reflects time worked.',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 14.h),

        _buildSummaryRow('Hourly rate', '\$${booking.hourlyRate.toStringAsFixed(2)}'),
        SizedBox(height: 8.h),
        _buildSummaryRow('Estimated taxes', '\$${booking.estimatedTaxes.toStringAsFixed(2)}'),
        SizedBox(height: 12.h),
        _buildDivider(),
        SizedBox(height: 12.h),
        _buildSummaryRow(
          'Hourly total',
          '\$${booking.hourlyTotal.toStringAsFixed(2)}',
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[150]);
  }

  Widget _buildStartCookingButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, MediaQuery.of(context).padding.bottom + 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          booking.onStartCooking?.call();
        },
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Text(
              'Start Cooking',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}