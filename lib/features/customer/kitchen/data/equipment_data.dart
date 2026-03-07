class EquipmentItemModel {
  final String id;
  final String name;
  bool isSelected;

  EquipmentItemModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory EquipmentItemModel.fromJson(Map<String, dynamic> json) {
    return EquipmentItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class EquipmentCategoryModel {
  final String category;
  final List<EquipmentItemModel> items;

  EquipmentCategoryModel({
    required this.category,
    required this.items,
  });

  factory EquipmentCategoryModel.fromJson(Map<String, dynamic> json) {
    return EquipmentCategoryModel(
      category: json['category'] ?? '',
      items: (json['items'] as List<dynamic>)
          .map((e) => EquipmentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  int get selectedCount => items.where((e) => e.isSelected).length;
}