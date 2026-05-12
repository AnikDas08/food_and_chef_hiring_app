class ChefDetailModel {
  bool? success;
  String? message;
  ChefDetailData? data;

  ChefDetailModel({this.success, this.message, this.data});

  ChefDetailModel.fromJson(Map<dynamic, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ChefDetailData.fromJson(json['data'])
        : null;
  }
}

class ChefDetailData {
  String? id;
  String? image;
  String? about;
  int? experience;
  String? name;
  String? address;
  double? pricing;
  double? avgRating;
  int? totalRating;
  List<String>? menuSections;
  double? priceWithFee;
  String? estCookingTime;
  bool? isFavorite;
  CookingArea? cookingArea;

  ChefDetailData({
    this.id,
    this.image,
    this.about,
    this.experience,
    this.name,
    this.address,
    this.pricing,
    this.avgRating,
    this.totalRating,
    this.menuSections,
    this.priceWithFee,
    this.estCookingTime,
    this.isFavorite,
    this.cookingArea,
  });

  ChefDetailData.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    image = json['image']?.toString();
    about = json['about']?.toString() ?? '';
    experience = json['experience'] as int?;
    name = json['name']?.toString();
    address = json['address']?.toString();
    pricing = (json['pricing'] as num?)?.toDouble();
    avgRating = (json['avg_rating'] as num?)?.toDouble();
    totalRating = json['total_rating'] as int?;
    
    // Handle menu_sections with proper null safety and type conversion
    if (json['menu_sections'] != null) {
      try {
        menuSections = List<String>.from(
          json['menu_sections'].map((item) => item?.toString() ?? '')
        );
      } catch (e) {
        menuSections = <String>[];
      }
    } else {
      menuSections = <String>[];
    }
    
    priceWithFee = (json['price_with_fee'] as num?)?.toDouble();
    estCookingTime = json['est_cooking_time']?.toString();
    isFavorite = json['isFavorite'] as bool?;
    cookingArea = json['cooking_area'] != null
        ? CookingArea.fromJson(json['cooking_area'])
        : null;
  }
}

class CookingArea {
  String? address;
  double? latitude;
  double? longitude;
  String? id;

  CookingArea({this.address, this.latitude, this.longitude, this.id});

  CookingArea.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    id = json['_id'];
  }
}