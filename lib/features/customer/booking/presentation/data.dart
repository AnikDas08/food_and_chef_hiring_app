class BookingDetailModel {
  final bool success;
  final String message;
  final BookingDetailData data;

  BookingDetailModel({required this.success, required this.message, required this.data});

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BookingDetailData.fromJson(json['data']),
    );
  }
}

class BookingDetailData {
  final String id;
  final BookingUser user;
  final String orderId;
  final String status;
  final String strTime;
  final String formattedAddress;
  final String formattedDate;
  final String duration;
  final PriceBreakdown priceBreakdown;
  final List<StaticItem> staticItems;
  final List<BookingHistory> history;

  BookingDetailData({
    required this.id,
    required this.user,
    required this.orderId,
    required this.status,
    required this.strTime,
    required this.formattedAddress,
    required this.formattedDate,
    required this.duration,
    required this.priceBreakdown,
    required this.staticItems,
    required this.history,
  });

  factory BookingDetailData.fromJson(Map<String, dynamic> json) {
    return BookingDetailData(
      id: json['_id'] ?? '',
      user: BookingUser.fromJson(json['user']),
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? '',
      strTime: json['strTime'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      formattedDate: json['formatted_date'] ?? '',
      duration: json['duration'] ?? '',
      priceBreakdown: PriceBreakdown.fromJson(json['price_breakdown']),
      staticItems: (json['static_items'] as List)
          .map((e) => StaticItem.fromJson(e))
          .toList(),
      history: (json['history'] as List)
          .map((e) => BookingHistory.fromJson(e))
          .toList(),
    );
  }
}

class BookingUser {
  final String name;
  final String image;

  BookingUser({required this.name, required this.image});

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class StaticItem {
  final String menuName;
  final int quantity;
  final List<String> customizations;
  final double totalPrice;

  StaticItem({
    required this.menuName,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
  });

  factory StaticItem.fromJson(Map<String, dynamic> json) {
    return StaticItem(
      menuName: json['menu']['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      customizations: List<String>.from(json['customizations'] ?? []),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}

class PriceBreakdown {
  final double subtotal;
  final double taxs;
  final double serviceFee;
  final double total;

  PriceBreakdown({
    required this.subtotal,
    required this.taxs,
    required this.serviceFee,
    required this.total,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) {
    return PriceBreakdown(
      subtotal: (json['subtotal'] as num).toDouble(),
      taxs: (json['taxs'] as num).toDouble(),
      serviceFee: (json['service_fee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class BookingHistory {
  final String type;
  final String date;

  BookingHistory({required this.type, required this.date});

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      type: json['type'] ?? '',
      date: json['date'] ?? '',
    );
  }
}