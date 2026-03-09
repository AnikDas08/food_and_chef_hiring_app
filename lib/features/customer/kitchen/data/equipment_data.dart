class EquipmentItemModel {
  final String id;
  final String name;
  bool isSelected;
  int quantity; // dynamic quantity, min 1

  EquipmentItemModel({
    required this.id,
    required this.name,
    this.isSelected = false,
    this.quantity = 1,
  });

  factory EquipmentItemModel.fromJson(Map<String, dynamic> json) {
    return EquipmentItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  // Payload format the backend expects
  Map<String, dynamic> toPayload() => {
    '_id': id,
    'quantity': quantity,
  };
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