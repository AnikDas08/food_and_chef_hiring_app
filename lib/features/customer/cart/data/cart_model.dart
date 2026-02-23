/// Models for GET cart?chefId=... response

class CartResponseModel {
  bool? success;
  String? message;
  CartResponseData? data;

  CartResponseModel({this.success, this.message, this.data});

  CartResponseModel.fromJson(Map<dynamic, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? CartResponseData.fromJson(json['data'])
        : null;
  }
}

class CartResponseData {
  List<CartChefGroup>? data;
  PriceBreakdown? priceBreakdown;
  String? estimatedTime;

  CartResponseData({this.data, this.priceBreakdown, this.estimatedTime});

  CartResponseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CartChefGroup>[];
      json['data'].forEach((v) => data!.add(CartChefGroup.fromJson(v)));
    }
    priceBreakdown = json['price_breakdown'] != null
        ? PriceBreakdown.fromJson(json['price_breakdown'])
        : null;
    estimatedTime = json['estimated_time'];
  }
}

class CartChefGroup {
  List<CartMenuItem>? menus;
  CartChefInfo? chef;

  CartChefGroup({this.menus, this.chef});

  CartChefGroup.fromJson(Map<String, dynamic> json) {
    if (json['menus'] != null) {
      menus = <CartMenuItem>[];
      json['menus'].forEach((v) => menus!.add(CartMenuItem.fromJson(v)));
    }
    chef = json['chef'] != null ? CartChefInfo.fromJson(json['chef']) : null;
  }
}

class CartMenuItem {
  String? id;
  String? user;
  List<CartMenuDetail>? menu;
  String? chef;
  int? quantity;
  List<String>? customizations;
  String? unitTimeStr;
  double? unitHour;
  double? unitPrice;
  double? totalPrice;
  String? unitPrepTime;
  String? cartId;

  CartMenuItem({
    this.id,
    this.user,
    this.menu,
    this.chef,
    this.quantity,
    this.customizations,
    this.unitTimeStr,
    this.unitHour,
    this.unitPrice,
    this.totalPrice,
    this.unitPrepTime,
    this.cartId,
  });

  CartMenuItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'];
    if (json['menu'] != null) {
      menu = <CartMenuDetail>[];
      json['menu'].forEach((v) => menu!.add(CartMenuDetail.fromJson(v)));
    }
    chef = json['chef'];
    quantity = json['quantity'];
    customizations = json['customizations'] != null
        ? List<String>.from(json['customizations'])
        : [];
    unitTimeStr = json['unit_time_str'];
    unitHour = (json['unit_hour'] as num?)?.toDouble();
    unitPrice = (json['unit_price'] as num?)?.toDouble();
    totalPrice = (json['total_price'] as num?)?.toDouble();
    unitPrepTime = json['unit_prep_time'];
    cartId = json['cart_id'];
  }
}

class CartMenuDetail {
  String? id;
  List<String>? images;
  String? name;

  CartMenuDetail({this.id, this.images, this.name});

  CartMenuDetail.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    name = json['name'];
  }
}

class CartChefInfo {
  String? id;
  String? image;
  String? name;
  double? pricing;

  CartChefInfo({this.id, this.image, this.name, this.pricing});

  CartChefInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    image = json['image'];
    name = json['name'];
    pricing = (json['pricing'] as num?)?.toDouble();
  }
}

class PriceBreakdown {
  double? subtotal;
  double? tax;
  double? fee;
  double? total;

  PriceBreakdown({this.subtotal, this.tax, this.fee, this.total});

  PriceBreakdown.fromJson(Map<String, dynamic> json) {
    subtotal = (json['subtotal'] as num?)?.toDouble();
    tax = (json['tax'] as num?)?.toDouble();
    fee = (json['fee'] as num?)?.toDouble();
    total = (json['total'] as num?)?.toDouble();
  }
}