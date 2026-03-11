import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/services/storage/storage_services.dart';

// ── Preset card model ──
class KitchenPreset {
  final String id;
  final String name;
  final String items;

  KitchenPreset({required this.id, required this.name, required this.items});

  factory KitchenPreset.fromJson(Map<String, dynamic> json) => KitchenPreset(
    id: json['kitchen'] ?? '',
    name: json['name'] ?? '',
    items: json['items'] ?? '',
  );
}

// ── Item inside a category ──
class KitchenDetailItem {
  final String name;
  final int quantity;
  final bool availability;

  KitchenDetailItem({
    required this.name,
    required this.quantity,
    required this.availability,
  });

  factory KitchenDetailItem.fromJson(Map<String, dynamic> json) =>
      KitchenDetailItem(
        name: json['name'] ?? '',
        quantity: json['quantity'] ?? 0,
        availability: json['availableity'] ?? false,
      );
}

// ── Selectable item from equipment?type=list ──
class EquipmentListItem {
  final String id;
  final String name;
  bool isSelected;
  int quantity; // 0 = not included in payload

  EquipmentListItem({
    required this.id,
    required this.name,
    this.isSelected = false,
    this.quantity = 0,
  });

  factory EquipmentListItem.fromJson(Map<String, dynamic> json) =>
      EquipmentListItem(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
      );
}

// ── Category with selectable items from equipment?type=list ──
class EquipmentListCategory {
  final String category;
  final List<EquipmentListItem> items;

  EquipmentListCategory({required this.category, required this.items});

  factory EquipmentListCategory.fromJson(Map<String, dynamic> json) =>
      EquipmentListCategory(
        category: json['category'] ?? '',
        items: (json['items'] as List<dynamic>)
            .map((e) => EquipmentListItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ── Category with items ──
class KitchenDetailCategory {
  final String category;
  final List<KitchenDetailItem> items;

  KitchenDetailCategory({required this.category, required this.items});

  factory KitchenDetailCategory.fromJson(Map<String, dynamic> json) =>
      KitchenDetailCategory(
        category: json['category'] ?? '',
        items: (json['items'] as List<dynamic>)
            .map((e) => KitchenDetailItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// Fixed category order — always show in this order
const List<String> kCategoryOrder = [
  'Cooking Appliances',
  'Pots & Pans',
  'Tools',
  'Special Equipment',
];

class KitchenEquipmentController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    // Both load in parallel on screen open
    fetchMyKitchen();
    fetchPresets();
    // Default all 4 categories expanded
    for (final cat in kCategoryOrder) {
      _expandedMap[cat] = true;
    }
    _expandedMap.refresh();
  }

  // ════════════════════════════════════════════════════
  // Collapse / expand — shared for both my kitchen & preset detail
  // ════════════════════════════════════════════════════
  final RxMap<String, bool> _expandedMap = <String, bool>{}.obs;

  bool isExpanded(String category) => _expandedMap[category] ?? true;

  void toggleCategory(String category) {
    _expandedMap[category] = !(_expandedMap[category] ?? true);
    _expandedMap.refresh();
  }

  // ════════════════════════════════════════════════════
  // Active data map — what's shown in the 4 sections
  // Key = category name, Value = items list
  // Starts from user's own kitchen, replaced on preset tap
  // ════════════════════════════════════════════════════
  final RxMap<String, List<KitchenDetailItem>> _activeItemsMap =
      <String, List<KitchenDetailItem>>{}.obs;

  // Returns items for a category in order — empty list if none
  List<KitchenDetailItem> itemsForCategory(String category) =>
      _activeItemsMap[category] ?? [];

  void _populateActiveMap(List<KitchenDetailCategory> categories) {
    final Map<String, List<KitchenDetailItem>> map = {};
    for (final cat in categories) {
      map[cat.category] = cat.items;
    }
    // Ensure all 4 keys exist (empty list if not in response)
    for (final name in kCategoryOrder) {
      map.putIfAbsent(name, () => []);
    }
    _activeItemsMap.value = map;
  }

  // Match percent — available items / total items
  double get matchPercent {
    int total = 0;
    int available = 0;
    for (final items in _activeItemsMap.values) {
      for (final item in items) {
        total++;
        if (item.availability) available++;
      }
    }
    if (total == 0) return 0;
    return available / total;
  }

  // ════════════════════════════════════════════════════
  // 1. GET equipment/kitchen/:userId — user's own kitchen
  //    Loaded on init, populates sections by default
  // ════════════════════════════════════════════════════
  final RxBool isLoadingMyKitchen = false.obs;
  final RxString myKitchenError = ''.obs;

  Future<void> fetchMyKitchen() async {
    try {
      isLoadingMyKitchen.value = true;
      myKitchenError.value = '';
      final String userId = LocalStorage.userId ?? '';
      final response = await ApiService.get('equipment/kitchen/$userId');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final data = json['data'] as Map<String, dynamic>;
          final rawItems = data['items'] as List<dynamic>? ?? [];
          final categories = rawItems
              .map((e) =>
              KitchenDetailCategory.fromJson(e as Map<String, dynamic>))
              .toList();
          // Collect item qty map for custom setup pre-checking
          _myItemQty.clear();
          for (final cat in categories) {
            for (final item in cat.items) {
              _myItemQty[item.name] = item.quantity > 0 ? item.quantity : 1;
            }
          }
          // Only populate sections if no preset is selected yet
          if (selectedPresetIndex.value == -1) {
            _populateActiveMap(categories);
          }
        } else {
          myKitchenError.value =
              json['message'] ?? 'Failed to load your kitchen';
          // Still ensure empty sections show
          _populateActiveMap([]);
        }
      } else {
        myKitchenError.value =
            response.data['message'] ?? 'Server error ${response.statusCode}';
        _populateActiveMap([]);
      }
    } catch (e) {
      myKitchenError.value = 'Something went wrong. Please try again.';
      _populateActiveMap([]);
      debugPrint('fetchMyKitchen error: $e');
    } finally {
      isLoadingMyKitchen.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // 2. GET equipment/kitchen-presets — preset cards
  // ════════════════════════════════════════════════════
  final RxList<KitchenPreset> presets = <KitchenPreset>[].obs;
  final RxBool isLoadingPresets = false.obs;
  final RxString presetsError = ''.obs;

  // -1 = none selected, 0..n = preset index, 9999 = Custom Setup
  final RxInt selectedPresetIndex = (-1).obs;

  Future<void> fetchPresets() async {
    try {
      isLoadingPresets.value = true;
      presetsError.value = '';
      final response = await ApiService.get('equipment/kitchen-presets');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final list = json['data'] as List<dynamic>;
          presets.value = list
              .map((e) => KitchenPreset.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          presetsError.value = json['message'] ?? 'Failed to load presets';
        }
      } else {
        presetsError.value =
            response.data['message'] ?? 'Server error ${response.statusCode}';
      }
    } catch (e) {
      presetsError.value = 'Something went wrong. Please try again.';
      debugPrint('fetchPresets error: $e');
    } finally {
      isLoadingPresets.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // Custom Setup — GET equipment?type=list
  // Shows all equipment with checkboxes
  // Pre-checks items the user already has (from myKitchen data)
  // ════════════════════════════════════════════════════
  final RxList<EquipmentListCategory> customSetupCategories =
      <EquipmentListCategory>[].obs;
  final RxBool isLoadingCustomSetup = false.obs;
  final RxString customSetupError = ''.obs;

  // Track my items for pre-checking: name -> quantity
  final Map<String, int> _myItemQty = {};

  Future<void> selectCustomSetup() async {
    selectedPresetIndex.value = 9999;
    // Clear active map so sections below show empty while custom is selected
    _populateActiveMap([]);

    try {
      isLoadingCustomSetup.value = true;
      customSetupError.value = '';
      customSetupCategories.clear();

      final response = await ApiService.get('equipment?type=list');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final list = json['data'] as List<dynamic>;
          final categories = list
              .map((e) => EquipmentListCategory.fromJson(
            e as Map<String, dynamic>,
          ))
              .toList();

          // Sort into fixed order
          categories.sort((a, b) {
            final order = kCategoryOrder;
            final ai = order.indexOf(a.category);
            final bi = order.indexOf(b.category);
            return (ai == -1 ? 99 : ai).compareTo(bi == -1 ? 99 : bi);
          });

          // Pre-check items the user already has — set qty from their existing data
          for (final cat in categories) {
            for (final item in cat.items) {
              final existingQty = _myItemQty[item.name] ?? 0;
              item.isSelected = existingQty > 0;
              item.quantity = existingQty > 0 ? existingQty : 0;
            }
          }

          customSetupCategories.value = categories;
          // Default all expanded
          for (final cat in categories) {
            _expandedMap[cat.category] = true;
          }
          _expandedMap.refresh();
        } else {
          customSetupError.value =
              json['message'] ?? 'Failed to load equipment';
        }
      } else {
        customSetupError.value =
            response.data['message'] ?? 'Server error ${response.statusCode}';
      }
    } catch (e) {
      customSetupError.value = 'Something went wrong. Please try again.';
      debugPrint('selectCustomSetup error: $e');
    } finally {
      isLoadingCustomSetup.value = false;
    }
  }

  void toggleCustomItem(String category, int itemIndex) {
    final cat = customSetupCategories
        .firstWhereOrNull((c) => c.category == category);
    if (cat != null && itemIndex < cat.items.length) {
      cat.items[itemIndex].isSelected = !cat.items[itemIndex].isSelected;
      // When checking on, default qty to 1; when off reset to 0
      if (cat.items[itemIndex].isSelected) {
        if (cat.items[itemIndex].quantity == 0) cat.items[itemIndex].quantity = 1;
      } else {
        cat.items[itemIndex].quantity = 0;
      }
      customSetupCategories.refresh();
    }
  }

  void incrementCustomItem(String category, int itemIndex) {
    final cat = customSetupCategories
        .firstWhereOrNull((c) => c.category == category);
    if (cat != null && itemIndex < cat.items.length) {
      cat.items[itemIndex].quantity++;
      cat.items[itemIndex].isSelected = true;
      customSetupCategories.refresh();
    }
  }

  void decrementCustomItem(String category, int itemIndex) {
    final cat = customSetupCategories
        .firstWhereOrNull((c) => c.category == category);
    if (cat != null && itemIndex < cat.items.length) {
      if (cat.items[itemIndex].quantity > 0) {
        cat.items[itemIndex].quantity--;
        // qty=0 means not selected
        if (cat.items[itemIndex].quantity == 0) {
          cat.items[itemIndex].isSelected = false;
        }
        customSetupCategories.refresh();
      }
    }
  }

  // Build payload — only items with qty > 0
  List<Map<String, dynamic>> get customSetupPayload {
    final List<Map<String, dynamic>> result = [];
    for (final cat in customSetupCategories) {
      for (final item in cat.items) {
        if (item.quantity > 0) {
          result.add({'_id': item.id, 'quantity': item.quantity});
        }
      }
    }
    return result;
  }

  // ════════════════════════════════════════════════════
  // 3. GET equipment/kitchen/:presetId — on preset tap
  //    Replaces active sections with this preset's data
  // ════════════════════════════════════════════════════
  final RxBool isLoadingPresetDetail = false.obs;
  final RxString presetDetailError = ''.obs;

  Future<void> onPresetTap(int index) async {
    selectedPresetIndex.value = index;
    final String presetId = presets[index].id;
    try {
      isLoadingPresetDetail.value = true;
      presetDetailError.value = '';

      final response = await ApiService.get('equipment/kitchen/$presetId');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final data = json['data'] as Map<String, dynamic>;
          final rawItems = data['items'] as List<dynamic>? ?? [];
          final categories = rawItems
              .map((e) =>
              KitchenDetailCategory.fromJson(e as Map<String, dynamic>))
              .toList();
          _populateActiveMap(categories);
        } else {
          presetDetailError.value =
              json['message'] ?? 'Failed to load preset';
          _populateActiveMap([]);
        }
      } else {
        presetDetailError.value =
            response.data['message'] ?? 'Server error ${response.statusCode}';
        _populateActiveMap([]);
      }
    } catch (e) {
      presetDetailError.value = 'Something went wrong. Please try again.';
      _populateActiveMap([]);
      debugPrint('onPresetTap error: $e');
    } finally {
      isLoadingPresetDetail.value = false;
    }
  }
}