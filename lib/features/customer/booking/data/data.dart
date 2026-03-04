class OrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  OrderResponse({required this.success, required this.message, this.data});

  factory OrderResponse.fromJson(Map<dynamic, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final String id;
  final User user;
  final Chef chef;
  final String strTime;
  final String status;
  final List<StaticItem> staticItems;
  final double userPaid;
  final String formattedAddress;
  final String formattedDate;
  final PriceBreakdown priceBreakdown;
  final List<OrderHistory> history;
  final String orderId;
  final String? invoiceUrl;
  final String? cancelReason;

  OrderData({
    required this.id,
    required this.user,
    required this.chef,
    required this.strTime,
    required this.status,
    required this.staticItems,
    required this.userPaid,
    required this.formattedAddress,
    required this.formattedDate,
    required this.priceBreakdown,
    required this.history,
    required this.orderId,
    this.invoiceUrl,
    this.cancelReason,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user']),
      chef: Chef.fromJson(json['chef']),
      strTime: json['strTime'] ?? '',
      status: json['status'] ?? '',
      staticItems: (json['static_items'] as List)
          .map((i) => StaticItem.fromJson(i))
          .toList(),
      userPaid: (json['user_paid'] as num).toDouble(),
      formattedAddress: json['formatted_address'] ?? '',
      formattedDate: json['formatted_date'] ?? '',
      priceBreakdown: PriceBreakdown.fromJson(json['price_breakdown']),
      history: (json['history'] as List)
          .map((i) => OrderHistory.fromJson(i))
          .toList(),
      orderId: json['order_id'] ?? '',
      invoiceUrl: json['invoice_url'],
      cancelReason: json['cancel_reason'],
    );
  }
}

class User {
  final String id;
  final String name;
  final String image;

  User({required this.id, required this.name, required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Chef {
  final String id;
  final String name;
  final String image;

  Chef({required this.id, required this.name, required this.image});

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class StaticItem {
  final String id;
  final String menuName;
  final List<String> images;
  final int quantity;
  final List<String> customizations;
  final double totalPrice;

  StaticItem({
    required this.id,
    required this.menuName,
    required this.images,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
  });

  factory StaticItem.fromJson(Map<String, dynamic> json) {
    return StaticItem(
      id: json['_id'] ?? '',
      menuName: json['menu']['name'] ?? '',
      images: List<String>.from(json['menu']['images'] ?? []),
      quantity: json['quantity'] ?? 0,
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

class OrderHistory {
  final String type;
  final String date;

  OrderHistory({required this.type, required this.date});

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      type: json['type'] ?? '',
      date: json['date'] ?? '',
    );
  }
}