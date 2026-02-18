class ChefModel {
  bool? success;
  String? message;
  List<ChefData>? data;

  ChefModel({this.success, this.message, this.data});

  ChefModel.fromJson(Map<dynamic, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChefData>[];
      json['data'].forEach((v) {
        data!.add(ChefData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChefData {
  Location? location;
  String? id;
  String? image;
  int? experience;
  String? name;
  num? pricing;
  num? avgRating;
  int? totalRating;
  String? distance;
  num? priceWithFee;

  ChefData({
    this.location,
    this.id,
    this.image,
    this.experience,
    this.name,
    this.pricing,
    this.avgRating,
    this.totalRating,
    this.distance,
    this.priceWithFee,
  });

  ChefData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    id = json['_id'];
    image = json['image'];
    experience = json['experience'];
    name = json['name'];
    pricing = json['pricing'];
    avgRating = json['avg_rating'];
    totalRating = json['total_rating'];
    distance = json['distance'];
    priceWithFee = json['price_with_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = id;
    data['image'] = image;
    data['experience'] = experience;
    data['name'] = name;
    data['pricing'] = pricing;
    data['avg_rating'] = avgRating;
    data['total_rating'] = totalRating;
    data['distance'] = distance;
    data['price_with_fee'] = priceWithFee;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}