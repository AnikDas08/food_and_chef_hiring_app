class MenuModel {
  bool? success;
  String? message;
  MenuPagination? pagination;
  List<MenuData>? data;

  MenuModel({this.success, this.message, this.pagination, this.data});

  MenuModel.fromJson(Map<dynamic, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? MenuPagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <MenuData>[];
      json['data'].forEach((v) => data!.add(MenuData.fromJson(v)));
    }
  }
}

class MenuPagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  MenuPagination({this.total, this.limit, this.page, this.totalPage});

  MenuPagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['totalPage'];
  }
}

class MenuData {
  String? id;
  List<String>? images;
  String? name;
  String? description;
  String? menuSection;
  List<String>? dietTypes;
  List<String>? alergens;
  String? estCookingTime;
  String? estPrepTime;
  List<String>? customizations;
  List<MenuIngredient>? ingredients;
  List<MenuEquipment>? specialEquipment;
  String? user;
  String? status;
  int? totalBooking;
  double? avgRating;
  String? kitchenStatus;
  String? createdAt;

  MenuData({
    this.id,
    this.images,
    this.name,
    this.description,
    this.menuSection,
    this.dietTypes,
    this.alergens,
    this.estCookingTime,
    this.estPrepTime,
    this.customizations,
    this.ingredients,
    this.specialEquipment,
    this.user,
    this.status,
    this.totalBooking,
    this.avgRating,
    this.kitchenStatus,
    this.createdAt,
  });

  MenuData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    name = json['name'];
    description = json['description'];
    menuSection = json['menu_section'];
    dietTypes = json['diet_types'] != null
        ? List<String>.from(json['diet_types'])
        : [];
    alergens =
    json['alergens'] != null ? List<String>.from(json['alergens']) : [];
    estCookingTime = json['est_cooking_time'];
    estPrepTime = json['est_prep_time'];
    customizations = json['customizations'] != null
        ? List<String>.from(json['customizations'])
        : [];
    if (json['ingradients'] != null) {
      ingredients = <MenuIngredient>[];
      json['ingradients']
          .forEach((v) => ingredients!.add(MenuIngredient.fromJson(v)));
    }
    if (json['special_equipment'] != null) {
      specialEquipment = <MenuEquipment>[];
      json['special_equipment']
          .forEach((v) => specialEquipment!.add(MenuEquipment.fromJson(v)));
    }
    user = json['user'];
    status = json['status'];
    totalBooking = json['total_booking'];
    avgRating = (json['avg_rating'] as num?)?.toDouble();
    kitchenStatus = json['kitchen_status'];
    createdAt = json['createdAt'];
  }
}

class MenuIngredient {
  String? id;
  String? name;
  String? quantity;
  String? unit;

  MenuIngredient({this.id, this.name, this.quantity, this.unit});

  MenuIngredient.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    quantity = json['quantity'];
    unit = json['unit'];
  }
}

class MenuEquipment {
  String? id;
  String? name;
  List<String>? images;
  String? status;

  MenuEquipment({this.id, this.name, this.images, this.status});

  MenuEquipment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    status = json['status'];
  }
}