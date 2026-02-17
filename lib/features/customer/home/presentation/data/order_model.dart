class OrderAgainModel {
  bool? success;
  String? message;
  List<OrderAgainData>? data;

  OrderAgainModel({this.success, this.message, this.data});

  OrderAgainModel.fromJson(Map<dynamic, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderAgainData>[];
      json['data'].forEach((v) {
        data!.add(OrderAgainData.fromJson(v));
      });
    }
  }
}

class OrderAgainData {
  String? id;
  OrderUser? user;
  OrderChef? chef;
  String? strTime;
  List<OrderStaticItem>? staticItems;
  double? userPaid;
  double? totalPrice;
  String? formattedAddress;
  String? formattedDate;
  String? duration;
  String? status;
  String? paymentStatus;
  double? rating;
  String? review;
  String? dateStr;
  String? orderId;

  OrderAgainData({
    this.id,
    this.user,
    this.chef,
    this.strTime,
    this.staticItems,
    this.userPaid,
    this.totalPrice,
    this.formattedAddress,
    this.formattedDate,
    this.duration,
    this.status,
    this.paymentStatus,
    this.rating,
    this.review,
    this.dateStr,
    this.orderId,
  });

  OrderAgainData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'] != null ? OrderUser.fromJson(json['user']) : null;
    chef = json['chef'] != null ? OrderChef.fromJson(json['chef']) : null;
    strTime = json['strTime'];
    if (json['static_items'] != null) {
      staticItems = <OrderStaticItem>[];
      json['static_items'].forEach((v) {
        staticItems!.add(OrderStaticItem.fromJson(v));
      });
    }
    userPaid = (json['user_paid'] as num?)?.toDouble();
    totalPrice = (json['total_price'] as num?)?.toDouble();
    formattedAddress = json['formatted_address'];
    formattedDate = json['formatted_date'];
    duration = json['duration'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    rating = (json['rating'] as num?)?.toDouble();
    review = json['review'];
    dateStr = json['dateStr'];
    orderId = json['order_id'];
  }
}

class OrderUser {
  String? id;
  String? name;
  String? image;

  OrderUser({this.id, this.name, this.image});

  OrderUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    image = json['image'];
  }
}

class OrderChef {
  String? id;
  String? name;
  String? image;

  OrderChef({this.id, this.name, this.image});

  OrderChef.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    image = json['image'];
  }
}

class OrderStaticItem {
  String? id;
  OrderMenu? menu;
  int? quantity;
  double? unitPrice;
  double? totalPrice;

  OrderStaticItem({
    this.id,
    this.menu,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  OrderStaticItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    menu = json['menu'] != null ? OrderMenu.fromJson(json['menu']) : null;
    quantity = json['quantity'];
    unitPrice = (json['unit_price'] as num?)?.toDouble();
    totalPrice = (json['total_price'] as num?)?.toDouble();
  }
}

class OrderMenu {
  String? id;
  String? name;
  List<String>? images;

  OrderMenu({this.id, this.name, this.images});

  OrderMenu.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
  }
}