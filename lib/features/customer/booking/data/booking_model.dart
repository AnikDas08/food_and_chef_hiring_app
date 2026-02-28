// lib/features/booking_history/model/booking_history_model.dart

class BookingHistoryModel {
  final String id;
  final UserModel user;
  final ChefModel chef;
  final String strTime;
  final String status;
  final String formattedAddress;
  final String formattedDate;
  final String formattedDeliveryDate;
  final String duration;
  final double userPaid;
  final double totalPrice;
  final String orderId;
  final String paymentStatus;
  final double rating;
  final PriceBreakdown priceBreakdown;
  final List<StaticItem> staticItems;
  final String? changeSchedule;
  final String? cancelBy;
  final String? cancelReason;
  final String? review;
  final String? invoiceUrl;

  BookingHistoryModel({
    required this.id,
    required this.user,
    required this.chef,
    required this.strTime,
    required this.status,
    required this.formattedAddress,
    required this.formattedDate,
    required this.formattedDeliveryDate,
    required this.duration,
    required this.userPaid,
    required this.totalPrice,
    required this.orderId,
    required this.paymentStatus,
    required this.rating,
    required this.priceBreakdown,
    required this.staticItems,
    this.changeSchedule,
    this.cancelBy,
    this.cancelReason,
    this.review,
    this.invoiceUrl,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingHistoryModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      chef: ChefModel.fromJson(json['chef'] ?? {}),
      strTime: json['strTime'] ?? '',
      status: json['status'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      formattedDate: json['formatted_date'] ?? '',
      formattedDeliveryDate: json['formatted_delivery_date'] ?? '',
      duration: json['duration'] ?? '',
      userPaid: (json['user_paid'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      orderId: json['order_id'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      priceBreakdown: PriceBreakdown.fromJson(json['price_breakdown'] ?? {}),
      staticItems: (json['static_items'] as List<dynamic>? ?? [])
          .map((e) => StaticItem.fromJson(e))
          .toList(),
      changeSchedule: json['change_schedule'],
      cancelBy: json['cancel_by'],
      cancelReason: json['cancel_reason'],
      review: json['review'],
      invoiceUrl: json['invoice_url'],
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String image;

  UserModel({required this.id, required this.name, required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ChefModel {
  final String id;
  final String name;
  final String image;

  ChefModel({required this.id, required this.name, required this.image});

  factory ChefModel.fromJson(Map<String, dynamic> json) {
    return ChefModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
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
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      taxs: (json['taxs'] ?? 0).toDouble(),
      serviceFee: (json['service_fee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class StaticItem {
  final String id;
  final MenuModel menu;
  final int quantity;
  final List<String> customizations;
  final double unitPrice;
  final double totalPrice;
  final String unitTimeStr;

  StaticItem({
    required this.id,
    required this.menu,
    required this.quantity,
    required this.customizations,
    required this.unitPrice,
    required this.totalPrice,
    required this.unitTimeStr,
  });

  factory StaticItem.fromJson(Map<String, dynamic> json) {
    return StaticItem(
      id: json['_id'] ?? '',
      menu: MenuModel.fromJson(json['menu'] ?? {}),
      quantity: json['quantity'] ?? 1,
      customizations: List<String>.from(json['customizations'] ?? []),
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      unitTimeStr: json['unit_time_str'] ?? '',
    );
  }
}

class MenuModel {
  final String id;
  final String name;
  final List<String> images;

  MenuModel({required this.id, required this.name, required this.images});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class BookingHistoryResponse {
  final bool success;
  final String message;
  final PaginationModel pagination;
  final List<BookingHistoryModel> data;

  BookingHistoryResponse({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory BookingHistoryResponse.fromJson(Map<dynamic, dynamic> json) {
    return BookingHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BookingHistoryModel.fromJson(e))
          .toList(),
    );
  }
}

class PaginationModel {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  PaginationModel({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}