/// Models for GET cart?chefId=... response
library;

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
    id = json['_id']?.toString();
    user = json['user']?.toString();
    if (json['menu'] != null) {
      menu = <CartMenuDetail>[];
      json['menu'].forEach((v) => menu!.add(CartMenuDetail.fromJson(v)));
    }
    chef = json['chef']?.toString();
    quantity = json['quantity'] as int?;
    customizations = json['customizations'] != null
        ? List<String>.from(json['customizations'])
        : [];
    unitTimeStr = json['unit_time_str']?.toString();
    unitHour = (json['unit_hour'] as num?)?.toDouble();
    unitPrice = (json['unit_price'] as num?)?.toDouble();
    totalPrice = (json['total_price'] as num?)?.toDouble();
    unitPrepTime = json['unit_prep_time']?.toString();
    cartId = json['cart_id']?.toString();
  }
  String? get menuId => menu != null && menu!.isNotEmpty ? menu!.first.id : null;
}

class CartMenuDetail {
  String? id;
  List<String>? images;
  String? name;
  List<String>? customizations;

  CartMenuDetail({this.id, this.images, this.name, this.customizations});

  CartMenuDetail.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    
    // Handle images array with null safety
    if (json['images'] != null) {
      try {
        images = List<String>.from(
          json['images'].map((item) => item?.toString() ?? '')
        );
      } catch (e) {
        images = <String>[];
      }
    } else {
      images = <String>[];
    }
    
    name = json['name']?.toString();
    customizations = json['customizations'] != null
        ? List<String>.from(json['customizations'])
        : [];
  }
}

class CartChefInfo {
  String? id;
  String? image;
  String? name;
  double? pricing;

  CartChefInfo({this.id, this.image, this.name, this.pricing});

  CartChefInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    image = json['image']?.toString();
    name = json['name']?.toString();
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