// lib/features/orders/data/past_order_model.dart

class PastOrderListResponse {
  final bool success;
  final String message;
  final PastOrderPagination pagination;
  final List<PastOrderModel> data;

  PastOrderListResponse({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  // ✅ Fixed: Map<String, dynamic> not Map<dynamic, dynamic>
  factory PastOrderListResponse.fromJson(Map<dynamic, dynamic> json) {
    return PastOrderListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: PastOrderPagination.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map((e) => PastOrderModel.fromJson(e))
          .toList(),
    );
  }
}

class PastOrderPagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  PastOrderPagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory PastOrderPagination.fromJson(Map<String, dynamic> json) {
    return PastOrderPagination(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}

class PastOrderModel {
  final String id;
  final String orderId;
  final OrderUser user;
  final OrderChef chef;
  final String strTime;
  final String status;
  final String formattedAddress;
  final String formattedDate;
  final String formattedDeliveryDate;
  final double userPaid;
  final double totalPrice;
  final double rating;           // ✅ Fixed: double not int
  final String paymentStatus;
  final String invoiceUrl;
  final bool hasDiscount;
  final double discountAmount;
  final double discountPercent;  // ✅ Added
  final PriceBreakdown priceBreakdown;
  final List<StaticItem> staticItems;
  final List<OrderHistory> history;
  final String duration;
  final String? review;                                  // ✅ Added
  final Map<String, double> formattedAddressCoordinates; // ✅ Added

  PastOrderModel({
    required this.id,
    required this.orderId,
    required this.user,
    required this.chef,
    required this.strTime,
    required this.status,
    required this.formattedAddress,
    required this.formattedDate,
    required this.formattedDeliveryDate,
    required this.userPaid,
    required this.totalPrice,
    required this.rating,
    required this.paymentStatus,
    required this.invoiceUrl,
    required this.hasDiscount,
    required this.discountAmount,
    required this.discountPercent,
    required this.priceBreakdown,
    required this.staticItems,
    required this.history,
    required this.duration,
    this.review,
    required this.formattedAddressCoordinates,
  });

  factory PastOrderModel.fromJson(Map<String, dynamic> json) {
    // ✅ Safe coordinates parsing
    final coords = json['formatted_address_coordinates'];
    final Map<String, double> coordinates = {
      'lat': (coords?['lat'] ?? 0).toDouble(),
      'lng': (coords?['lng'] ?? 0).toDouble(),
    };

    return PastOrderModel(
      id: json['_id'] ?? '',
      orderId: json['order_id'] ?? '',
      user: OrderUser.fromJson(json['user'] ?? {}),
      chef: OrderChef.fromJson(json['chef'] ?? {}),
      strTime: json['strTime'] ?? '',
      status: json['status'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      formattedDate: json['formatted_date'] ?? '',
      formattedDeliveryDate: json['formatted_delivery_date'] ?? '',
      userPaid: (json['user_paid'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),          // ✅ Fixed
      paymentStatus: json['payment_status'] ?? '',
      invoiceUrl: json['invoice_url'] ?? '',
      hasDiscount: json['has_discount'] ?? false,
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      discountPercent: (json['discount_percent'] ?? 0).toDouble(), // ✅ Added
      priceBreakdown: PriceBreakdown.fromJson(json['price_breakdown'] ?? {}),
      staticItems: (json['static_items'] as List? ?? [])
          .map((e) => StaticItem.fromJson(e))
          .toList(),
      history: (json['history'] as List? ?? [])
          .map((e) => OrderHistory.fromJson(e))
          .toList(),
      duration: json['duration'] ?? '',
      review: json['review'],                            // ✅ Added (nullable)
      formattedAddressCoordinates: coordinates,          // ✅ Added
    );
  }

  String get itemNames => staticItems.map((e) => e.menuName).join(', ');
  String get itemCountLabel =>
      '${staticItems.length} item${staticItems.length > 1 ? 's' : ''}';
}

class OrderUser {
  final String id;
  final String name;
  final String image;

  OrderUser({required this.id, required this.name, required this.image});

  factory OrderUser.fromJson(Map<String, dynamic> json) => OrderUser(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}

class OrderChef {
  final String id;
  final String name;
  final String image;

  OrderChef({required this.id, required this.name, required this.image});

  factory OrderChef.fromJson(Map<String, dynamic> json) => OrderChef(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}

class StaticItem {
  final String id;
  final String menuId;
  final String menuName;
  final List<String> menuImages;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final List<String> customizations;
  final String unitTimeStr;   // ✅ Added
  final double unitHour;      // ✅ Added

  StaticItem({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.menuImages,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.customizations,
    required this.unitTimeStr,
    required this.unitHour,
  });

  factory StaticItem.fromJson(Map<String, dynamic> json) {
    final menu = json['menu'] ?? {};
    return StaticItem(
      id: json['_id'] ?? '',
      menuId: menu['_id'] ?? '',
      menuName: menu['name'] ?? '',
      menuImages: List<String>.from(menu['images'] ?? []),
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      customizations: List<String>.from(json['customizations'] ?? []),
      unitTimeStr: json['unit_time_str'] ?? '',           // ✅ Added
      unitHour: (json['unit_hour'] ?? 0).toDouble(),      // ✅ Added
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

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) => PriceBreakdown(
    subtotal: (json['subtotal'] ?? 0).toDouble(),
    taxs: (json['taxs'] ?? 0).toDouble(),
    serviceFee: (json['service_fee'] ?? 0).toDouble(),
    total: (json['total'] ?? 0).toDouble(),
  );
}

class OrderHistory {
  final String id;
  final String type;
  final String date;

  OrderHistory({required this.id, required this.type, required this.date});

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    id: json['_id'] ?? '',
    type: json['type'] ?? '',
    date: json['date'] ?? '',
  );
}