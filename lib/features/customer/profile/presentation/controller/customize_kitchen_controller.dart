import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/services/storage/storage_services.dart';

import '../../../../../services/api/api_response_model.dart';
import 'kitchen_equipment_controller.dart';

// Re-uses models from kitchen_equipment_controller.dart:
// KitchenPreset, KitchenDetailItem, KitchenDetailCategory,
// EquipmentListItem, EquipmentListCategory, kCategoryOrder

class CustomizeKitchenController extends GetxController {
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initLoad();
    for (final cat in kCategoryOrder) {
      _expandedMap[cat] = true;
    }
    _expandedMap.refresh();
  }

  Future<void> _initLoad() async {
    await fetchMyKitchen();
    await fetchPresets();
    await _loadEquipmentList({});
  }

  final Rx<dynamic> localImage = Rx<dynamic>(null);
  final RxString serverImage = ''.obs;

  Future<void> pickImage() async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked != null) localImage.value = picked;
  }

  // ════════════════════════════════════════════════════
  // COLLAPSE / EXPAND
  // ════════════════════════════════════════════════════
  final RxMap<String, bool> _expandedMap = <String, bool>{}.obs;

  bool isExpanded(String category) => _expandedMap[category] ?? true;

  void toggleCategory(String category) {
    _expandedMap[category] = !(_expandedMap[category] ?? true);
    _expandedMap.refresh();
  }

  // Count of items with qty > 0 for a category
  int selectedCountFor(String category) {
    return customSetupCategories
        .firstWhereOrNull((c) => c.category == category)
        ?.items
        .where((i) => i.quantity > 0)
        .length ??
        0;
  }


  final RxInt selectedPresetIndex = (-1).obs;


  String get _patchId {
    if (selectedPresetIndex.value >= 0 &&
        selectedPresetIndex.value < presets.length) {
      return presets[selectedPresetIndex.value].id;
    }
    return LocalStorage.userId ?? '';
  }

  final RxBool isLoadingMyKitchen = false.obs;

  final Map<String, int> _myItemQty = {};

  String _myKitchenId = '';

  Future<void> fetchMyKitchen() async {

    try {
      isLoadingMyKitchen.value = true;
      final String userId = LocalStorage.userId ?? '';
      _myKitchenId = userId;
      final response = await ApiService.get('equipment/kitchen/$userId');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final data = json['data'] as Map<String, dynamic>;
          serverImage.value = data['image'] ?? '';
          final rawItems = data['items'] as List<dynamic>? ?? [];
          _myItemQty.clear();
          for (final raw in rawItems) {
            final cat = raw as Map<String, dynamic>;
            for (final item in (cat['items'] as List<dynamic>? ?? [])) {
              final m = item as Map<String, dynamic>;
              _myItemQty[m['name'] ?? ''] =
              (m['quantity'] as int? ?? 0) > 0 ? (m['quantity'] as int) : 1;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('fetchMyKitchen error: $e');
    } finally {
      isLoadingMyKitchen.value = false;
    }
  }
  
  final RxList<KitchenPreset> presets = <KitchenPreset>[].obs;
  final RxBool isLoadingPresets = false.obs;
  final RxString presetsError = ''.obs;

  Future<void> fetchPresets() async {

    try {
      isLoadingPresets.value = true;
      presetsError.value = '';
      final response = await ApiService.get('equipment/kitchen-presets');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          presets.value = (json['data'] as List<dynamic>)
              .map((e) => KitchenPreset.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          presetsError.value = json['message'] ?? 'Failed to load presets';
        }
      }
    } catch (e) {
      presetsError.value = 'Something went wrong.';
      debugPrint('fetchPresets error: $e');
    } finally {
      isLoadingPresets.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // EQUIPMENT LIST — shared by both preset tap & custom setup
  // GET equipment?type=list → then pre-fill qty
  // ════════════════════════════════════════════════════
  final RxList<EquipmentListCategory> customSetupCategories =
      <EquipmentListCategory>[].obs;
  final RxBool isLoadingEquipmentList = false.obs;
  final RxString equipmentListError = ''.obs;

  // Aliases used by the screen
  RxBool get isLoadingCustomSetup => isLoadingEquipmentList;
  RxString get customSetupError => equipmentListError;

  /// Loads full equipment list and pre-fills qty from [qtySource].
  /// [qtySource] is a map of item name → quantity to pre-fill.
  Future<void> _loadEquipmentList(Map<String, int> qtySource) async {
    try {
      isLoadingEquipmentList.value = true;
      equipmentListError.value = '';
      customSetupCategories.clear();

      final response = await ApiService.get('equipment?type=list');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final categories = (json['data'] as List<dynamic>)
              .map((e) =>
              EquipmentListCategory.fromJson(e as Map<String, dynamic>))
              .toList();

          // Sort into fixed order
          categories.sort((a, b) {
            final ai = kCategoryOrder.indexOf(a.category);
            final bi = kCategoryOrder.indexOf(b.category);
            return (ai == -1 ? 99 : ai).compareTo(bi == -1 ? 99 : bi);
          });

          // Pre-fill qty from source map
          for (final cat in categories) {
            for (final item in cat.items) {
              final qty = qtySource[item.name] ?? 0;
              item.quantity = qty;
              item.isSelected = qty > 0;
            }
          }

          customSetupCategories.value = categories;
          for (final cat in categories) {
            _expandedMap[cat.category] = true;
          }
          _expandedMap.refresh();
        } else {
          equipmentListError.value =
              json['message'] ?? 'Failed to load equipment';
        }
      } else {
        equipmentListError.value = 'Server error ${response.statusCode}';
      }
    } catch (e) {
      equipmentListError.value = 'Something went wrong.';
      debugPrint('_loadEquipmentList error: $e');
    } finally {
      isLoadingEquipmentList.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // PRESET TAP — fetch preset detail, show only that preset's items with qty
  // ════════════════════════════════════════════════════
  final RxBool isLoadingPresetDetail = false.obs;

  Future<void> onPresetTap(int index) async {
    selectedPresetIndex.value = index;
    final String presetId = presets[index].id;
    try {
      isLoadingPresetDetail.value = true;
      final response = await ApiService.get('equipment/kitchen/$presetId');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          final data = json['data'] as Map<String, dynamic>;
          // Build name→qty map from preset items
          final Map<String, int> presetQty = {};
          for (final raw in (data['items'] as List<dynamic>? ?? [])) {
            final cat = raw as Map<String, dynamic>;
            for (final item in (cat['items'] as List<dynamic>? ?? [])) {
              final m = item as Map<String, dynamic>;
              final qty = (m['quantity'] as int? ?? 0);
              presetQty[m['name'] ?? ''] = qty > 0 ? qty : 1;
            }
          }
          // Load full equipment list, pre-fill with preset's qtys
          await _loadEquipmentList(presetQty);
        }
      }
    } catch (e) {
      debugPrint('onPresetTap error: $e');
    } finally {
      isLoadingPresetDetail.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // CUSTOM SETUP — all equipment, my existing items pre-filled with qty
  // ════════════════════════════════════════════════════
  Future<void> selectCustomSetup() async {
    selectedPresetIndex.value = 9999;
    // Pre-fill with my own kitchen quantities so my items show checked
    await _loadEquipmentList(_myItemQty);
  }

  // ════════════════════════════════════════════════════
  // INCREMENT / DECREMENT
  // ════════════════════════════════════════════════════
  void incrementCustomItem(String category, int i) {
    final cat =
    customSetupCategories.firstWhereOrNull((c) => c.category == category);
    if (cat != null && i < cat.items.length) {
      cat.items[i].quantity++;
      cat.items[i].isSelected = true;
      customSetupCategories.refresh();
    }
  }

  void decrementCustomItem(String category, int i) {
    final cat =
    customSetupCategories.firstWhereOrNull((c) => c.category == category);
    if (cat != null && i < cat.items.length && cat.items[i].quantity > 0) {
      cat.items[i].quantity--;
      cat.items[i].isSelected = cat.items[i].quantity > 0;
      customSetupCategories.refresh();
    }
  }

  // ════════════════════════════════════════════════════
  // PAYLOAD — only items with qty > 0
  // ════════════════════════════════════════════════════
  List<Map<String, dynamic>> get _payload {
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
  // SAVE — PATCH equipment/kitchen/:id
  // id = preset's kitchen id  OR  my userId
  // body = { items: [...] }  +  optional image (multipart)
  // ════════════════════════════════════════════════════
  final RxBool isSaving = false.obs;

  Future<void> save() async {
    try {
      isSaving.value = true;
      final String patchId = _patchId;
      final items = _payload;
      final imagePath = localImage.value?.path;
      final bool hasImage = imagePath != null && imagePath.isNotEmpty;

      ApiResponseModel response;
      if (hasImage) {
        // multipartImage sends List values as jsonEncoded string internally —
        // backend expects actual array so we pass the raw list
        response = await ApiService.multipartImage(
          'equipment/kitchen/$patchId',
          method: 'PATCH',
          body: {'items': items}, // ApiService must NOT double-encode this
          files: [
            {'name': 'image', 'image': imagePath}
          ],
        );
      } else {
        // Plain PATCH — send items as actual array, not jsonEncoded string
        response = await ApiService.multipartImage(
          'equipment/kitchen/$patchId',
          method: 'PATCH',
          body: {'items': items}, // ApiService must NOT double-encode this
        );
      }

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
          Get.offAllNamed(AppRoutes.customerHomeScreen);
          Get.snackbar(
            'Saved',
            'Your kitchen has been updated.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        } else {
          Get.snackbar(
            'Error',
            json['message'] ?? 'Something went wrong.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      }
    } catch (e) {
      debugPrint('save error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSaving.value = false;
    }
  }
}