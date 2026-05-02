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
    total = json['total'] as int?;
    limit = json['limit'] as int?;
    page = json['page'] as int?;
    totalPage = json['totalPage'] as int?;
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
    description = json['description']?.toString();
    menuSection = json['menu_section']?.toString();
    
    // Handle diet_types with proper null safety
    if (json['diet_types'] != null) {
      try {
        dietTypes = List<String>.from(
          json['diet_types'].map((item) => item?.toString() ?? '')
        );
      } catch (e) {
        dietTypes = <String>[];
      }
    } else {
      dietTypes = <String>[];
    }
    
    // Handle alergens with proper null safety
    if (json['alergens'] != null) {
      try {
        alergens = List<String>.from(
          json['alergens'].map((item) => item?.toString() ?? '')
        );
      } catch (e) {
        alergens = <String>[];
      }
    } else {
      alergens = <String>[];
    }
    
    estCookingTime = json['est_cooking_time']?.toString();
    estPrepTime = json['est_prep_time']?.toString();
    
    // Handle customizations with proper null safety
    if (json['customizations'] != null) {
      try {
        customizations = List<String>.from(
          json['customizations'].map((item) => item?.toString() ?? '')
        );
      } catch (e) {
        customizations = <String>[];
      }
    } else {
      customizations = <String>[];
    }
    
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
    user = json['user']?.toString();
    status = json['status']?.toString();
    totalBooking = json['total_booking'] as int?;
    avgRating = (json['avg_rating'] as num?)?.toDouble();
    kitchenStatus = json['kitchen_status']?.toString();
    createdAt = json['createdAt']?.toString();
  }
}

class MenuIngredient {
  String? id;
  String? name;
  String? quantity;
  String? unit;

  MenuIngredient({this.id, this.name, this.quantity, this.unit});

  MenuIngredient.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    name = json['name']?.toString();
    quantity = json['quantity']?.toString();
    unit = json['unit']?.toString();
  }
}

class MenuEquipment {
  String? id;
  String? name;
  List<String>? images;
  String? status;

  MenuEquipment({this.id, this.name, this.images, this.status});

  MenuEquipment.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    name = json['name']?.toString();
    
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
    
    status = json['status']?.toString();
  }
}