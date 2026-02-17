class SearchChefResponse {
  bool? success;
  String? message;
  Pagination? pagination;
  List<ChefData>? data;

  SearchChefResponse({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory SearchChefResponse.fromJson(Map<dynamic, dynamic> json) {
    return SearchChefResponse(
      success: json['success'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => ChefData.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'pagination': pagination?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({
    this.total,
    this.limit,
    this.page,
    this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }
}

class ChefData {
  String? id;
  Location? location;
  String? image;
  int? experience;
  num? pricing;
  String? name;
  String? distance;
  num? priceWithFee;
  num? avgRating;
  int? totalRating;

  ChefData({
    this.id,
    this.location,
    this.image,
    this.experience,
    this.pricing,
    this.name,
    this.distance,
    this.priceWithFee,
    this.avgRating,
    this.totalRating,
  });

  factory ChefData.fromJson(Map<String, dynamic> json) {
    return ChefData(
      id: json['_id'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      image: json['image'],
      experience: json['experience'],
      pricing: json['pricing'],
      name: json['name'],
      distance: json['distance'],
      priceWithFee: json['price_with_fee'],
      avgRating: json['avg_rating'],
      totalRating: json['total_rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'location': location?.toJson(),
      'image': image,
      'experience': experience,
      'pricing': pricing,
      'name': name,
      'distance': distance,
      'price_with_fee': priceWithFee,
      'avg_rating': avgRating,
      'total_rating': totalRating,
    };
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}