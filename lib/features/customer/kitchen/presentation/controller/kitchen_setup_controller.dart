import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_untitled/services/api/api_service.dart';

import '../../data/equipment_data.dart';
import '../../data/kitchen_model.dart';

class KitchenSetupController extends GetxController {

  // ════════════════════════════════════════════════════
  // SCREEN 1 — Fetch kitchen presets (GET)
  // ════════════════════════════════════════════════════
  final RxList<KitchenPresetModel> kitchenPresets = <KitchenPresetModel>[].obs;
  final RxBool isLoadingPresets = false.obs;
  final RxString presetsError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKitchenPresets();
  }

  Future<void> fetchKitchenPresets() async {
    try {
      isLoadingPresets.value = true;
      presetsError.value = '';
      final response = await ApiService.get('equipment/kitchen-presets');
      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> json = response.data;
        if (json['success'] == true) {
          final List<dynamic> data = json['data'] as List<dynamic>;
          kitchenPresets.value = data
              .map((e) => KitchenPresetModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          presetsError.value = json['message'] ?? 'Failed to load presets';
        }
      } else {
        presetsError.value =
            response.data?['message'] ?? 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      presetsError.value = 'Something went wrong. Please try again.';
      debugPrint('fetchKitchenPresets error: $e');
    } finally {
      isLoadingPresets.value = false;
    }
  }

  // ────────────────────────────────────────────────────
  // Selection state
  // -1   = nothing selected
  // 0…n  = preset index from API
  // 9999 = Custom Setup (fixed)
  // ────────────────────────────────────────────────────
  final RxInt selectedKitchenIndex = (-1).obs;

  bool get isAnythingSelected => selectedKitchenIndex.value != -1;
  bool get isCustomSetup => selectedKitchenIndex.value == 9999;

  // When a preset card is tapped → immediately POST
  void selectPreset(int index) {
    selectedKitchenIndex.value = index;
    submitPresetKitchen(kitchenPresets[index].kitchen);
  }

  void selectCustomSetup() {
    selectedKitchenIndex.value = 9999;
  }

  // ════════════════════════════════════════════════════
  // POST equipment/kitchen
  // Body: { "presetId": "<kitchen id>" }
  // Called immediately when user taps a preset card
  // ════════════════════════════════════════════════════
  final RxBool isSubmittingPreset = false.obs;

  Future<void> submitPresetKitchen(String presetId) async {
    try {
      isSubmittingPreset.value = true;
      final response = await ApiService.post(
        'equipment/kitchen',
        body: {'presetId': presetId},
      );
      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> json = response.data;
        final message = json['message'] ?? 'Kitchen saved successfully!';
        if (json['success'] == true) {
          Get.snackbar(
            '',
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response.data?['message'] ?? 'Server error: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      debugPrint('submitPresetKitchen error: $e');
      Get.snackbar(
        'Error', 'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSubmittingPreset.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // GET equipment?type=list
  // Called when Custom Setup → Continue is tapped
  // Populates all checkbox screens dynamically from API
  // ════════════════════════════════════════════════════
  final RxList<EquipmentCategoryModel> equipmentCategories =
      <EquipmentCategoryModel>[].obs;
  final RxBool isLoadingEquipment = false.obs;
  final RxString equipmentError = ''.obs;

  // Each category's items are stored here with selection state
  // Key = category name, Value = list of items with isSelected
  final RxMap<String, List<EquipmentItemModel>> categoryItemsMap =
      <String, List<EquipmentItemModel>>{}.obs;

  Future<void> fetchEquipmentList() async {
    try {
      isLoadingEquipment.value = true;
      equipmentError.value = '';

      final response = await ApiService.get('equipment?type=list');

      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> json = response.data;
        if (json['success'] == true) {
          final List<dynamic> data = json['data'] as List<dynamic>;
          final categories = data
              .map((e) => EquipmentCategoryModel.fromJson(
              e as Map<String, dynamic>))
              .toList();
          equipmentCategories.value = categories;

          // Build categoryItemsMap with fresh selection state
          final Map<String, List<EquipmentItemModel>> map = {};
          for (final cat in categories) {
            map[cat.category] = cat.items
                .map((item) => EquipmentItemModel(
              id: item.id,
              name: item.name,
              isSelected: false,
            ))
                .toList();
          }
          categoryItemsMap.value = map;
        } else {
          equipmentError.value =
              json['message'] ?? 'Failed to load equipment';
        }
      } else {
        equipmentError.value =
            response.data?['message'] ?? 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      equipmentError.value = 'Something went wrong. Please try again.';
      debugPrint('fetchEquipmentList error: $e');
    } finally {
      isLoadingEquipment.value = false;
    }
  }

  // Toggle a single item in a category
  void toggleItem(String category, int itemIndex) {
    final list = categoryItemsMap[category];
    if (list != null && itemIndex < list.length) {
      list[itemIndex].isSelected = !list[itemIndex].isSelected;
      categoryItemsMap.refresh();
    }
  }

  // Get items for a specific category name
  List<EquipmentItemModel> itemsFor(String category) {
    return categoryItemsMap[category] ?? [];
  }

  // Selected count for a category
  int selectedCountFor(String category) {
    return categoryItemsMap[category]?.where((e) => e.isSelected).length ?? 0;
  }

  // ════════════════════════════════════════════════════
  // Screen 5: Upload Photo
  // ════════════════════════════════════════════════════
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (image != null) selectedImage.value = image;
  }

  void removeImage() => selectedImage.value = null;
}