import 'package:hive_flutter/hive_flutter.dart';

class PersonalGroceryService {
  static const String _boxName = 'personal_groceries';

  /// Call once in main.dart before runApp()
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
  }

  static Box<Map> get _box => Hive.box<Map>(_boxName);

  /// Add a new grocery item
  static Future<void> addItem({
    required String name,
    required String quantity,
    required String unit,
  }) async {
    final item = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'items': quantity,
      'unit': unit,
      'isSelected': true,
    };
    await _box.add(item);
  }

  /// Get all stored items
  static List<Map<String, dynamic>> getItems() {
    return _box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Toggle isSelected for an item by box index
  static Future<void> toggleItem(int index) async {
    final item = Map<String, dynamic>.from(_box.getAt(index)!);
    item['isSelected'] = !(item['isSelected'] as bool);
    await _box.putAt(index, item);
  }

  /// Delete an item by box index
  static Future<void> deleteItem(int index) async {
    await _box.deleteAt(index);
  }

  /// Clear all items
  static Future<void> clearAll() async {
    await _box.clear();
  }
}