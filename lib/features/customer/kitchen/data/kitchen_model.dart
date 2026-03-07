class KitchenPresetModel {
  final String kitchen;
  final String name;
  final String items;
  final String? image; // nullable — may not exist in response

  KitchenPresetModel({
    required this.kitchen,
    required this.name,
    required this.items,
    this.image,
  });

  factory KitchenPresetModel.fromJson(Map<dynamic, dynamic> json) {
    return KitchenPresetModel(
      kitchen: json['kitchen'] ?? '',
      name: json['name'] ?? '',
      items: json['items'] ?? '',
      image: json['image'], // null if absent
    );
  }

  Map<String, dynamic> toJson() => {
    'kitchen': kitchen,
    'name': name,
    'items': items,
    if (image != null) 'image': image,
  };
}