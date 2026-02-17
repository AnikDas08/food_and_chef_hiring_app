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
  double? pricing;
  double? avgRating;
  int? totalRating;
  List<String>? menuSections;
  double? priceWithFee;
  String? estCookingTime;

  ChefDetailData({
    this.id,
    this.image,
    this.about,
    this.experience,
    this.name,
    this.pricing,
    this.avgRating,
    this.totalRating,
    this.menuSections,
    this.priceWithFee,
    this.estCookingTime,
  });

  ChefDetailData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    image = json['image'];
    about = json['about'];
    experience = json['experience'];
    name = json['name'];
    pricing = (json['pricing'] as num?)?.toDouble();
    avgRating = (json['avg_rating'] as num?)?.toDouble();
    totalRating = json['total_rating'];
    menuSections = json['menu_sections'] != null
        ? List<String>.from(json['menu_sections'])
        : [];
    priceWithFee = (json['price_with_fee'] as num?)?.toDouble();
    estCookingTime = json['est_cooking_time'];
  }
}