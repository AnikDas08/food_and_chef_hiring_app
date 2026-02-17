import '../../../../../utils/constants/app_images.dart';

class CuisineModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<CuisineData>? data;

  CuisineModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CuisineModel.fromJson(Map<dynamic, dynamic> json) {
    return CuisineModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<CuisineData>.from(
        json["data"].map((x) => CuisineData.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class CuisineData {
  final String? id;
  final String? name;
  final String? image;

  CuisineData({
    this.id,
    this.name,
    this.image,
  });

  factory CuisineData.fromJson(Map<String, dynamic> json) {
    return CuisineData(
      id: json["_id"],
      name: json["name"],
      image: json["image"]??AppImages.noImage,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "image": image,
  };
}
