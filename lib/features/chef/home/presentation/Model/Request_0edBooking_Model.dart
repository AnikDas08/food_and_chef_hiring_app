class RequestedBookingModel {

  final String id;
  final String status;
  final String scheduledAt;
  final String itemSummary;
  final double total;
  final String customerName;
  final String customerImage;
  final String address;
  final String orderId;

  RequestedBookingModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    required this.itemSummary,
    required this.total,
    required this.customerName,
    required this.customerImage,
    required this.address,
    required this.orderId,
  });

  factory RequestedBookingModel.fromJson(Map<String, dynamic> json) {

    final user = json['user'] as Map<String, dynamic>? ?? {};
    final staticItems = json['static_items'] as List? ?? [];
    final priceBreakdown =
        json['price_breakdown'] as Map<String, dynamic>? ?? {};

    String scheduledAt = '';

    final formattedDate = json['formatted_date'] as String? ?? '';
    final strTime = json['strTime'] as String? ?? '';
    if (formattedDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(formattedDate).toLocal();
        scheduledAt = '${dt.day} ${_month(dt.month)}, ${dt.year} | $strTime';
      } catch (_) {
        scheduledAt = strTime;
      }
    } else {
      scheduledAt = strTime;
    }

    String itemSummary = '0 items';

    if (staticItems.isNotEmpty) {
      final firstName =
          (staticItems[0]['menu'] as Map<String, dynamic>?)?['name']
              ?.toString() ??
              '';
      if (staticItems.length == 1) {
        itemSummary = '1 item ($firstName)';
      } else {
        itemSummary =
        '${staticItems.length} items ($firstName, and ${staticItems.length - 1} more)';
      }
    }

    return RequestedBookingModel(
      id: json['_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      scheduledAt: scheduledAt,
      itemSummary: itemSummary,
      total: ((priceBreakdown['chef_price_breakdown']
      as Map<String, dynamic>?)?['total'] as num?)?.toDouble() ?? 0.0,
      customerName: user['name']?.toString() ?? '',
      customerImage: user['image']?.toString() ?? '',
      address: json['formatted_address']?.toString() ?? '',
    );
  }

  static String _month(int m) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return months[m - 1];
  }
}