class TopMenuModel {
  final bool success;
  final String message;
  final List<TopMenuItem> data;

  TopMenuModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TopMenuModel.fromJson(Map<String, dynamic> json) {
    return TopMenuModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => TopMenuItem.fromJson(e))
          .toList(),
    );
  }
}

class TopMenuItem {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final int totalBooking;
  final double avgRating;

  TopMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.totalBooking,
    required this.avgRating,
  });

  factory TopMenuItem.fromJson(Map<String, dynamic> json) {
    return TopMenuItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      totalBooking: json['total_booking'] ?? 0,
      avgRating: (json['avg_rating'] as num).toDouble(),
    );
  }
}