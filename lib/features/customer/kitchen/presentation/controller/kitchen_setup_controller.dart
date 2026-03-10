import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_untitled/services/api/api_service.dart';

import '../../../../../services/api/api_response_model.dart';
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
  // Selection state — just marks, no API call on tap
  // -1   = nothing selected
  // 0…n  = preset index from API
  // 9999 = Custom Setup (fixed)
  // ────────────────────────────────────────────────────
  final RxInt selectedKitchenIndex = (-1).obs;

  bool get isAnythingSelected => selectedKitchenIndex.value != -1;
  bool get isCustomSetup => selectedKitchenIndex.value == 9999;

  void selectPreset(int index) {
    selectedKitchenIndex.value = index;
    // NO API call here — fires only when Continue is tapped
  }

  void selectCustomSetup() {
    selectedKitchenIndex.value = 9999;
  }

  // ════════════════════════════════════════════════════
  // POST equipment/kitchen
  // Body: { "presetId": "<kitchen id>" }
  // Called ONLY when Continue is tapped with a preset selected
  // ════════════════════════════════════════════════════
  final RxBool isSubmittingPreset = false.obs;

  Future<bool> submitPresetKitchen() async {
    final String presetId = kitchenPresets[selectedKitchenIndex.value].kitchen;
    try {
      isSubmittingPreset.value = true;
      final response = await ApiService.post(
        'equipment/kitchen',
        body: {'presetId': presetId},
      );
      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> json = response.data;
        if (json['success'] == true) {
          Get.snackbar(
            'Successful', json['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
          return true;
        } else {
          Get.snackbar(
            'Error', json['message'] ?? 'Something went wrong.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
          return false;
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
        return false;
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
      return false;
    } finally {
      isSubmittingPreset.value = false;
    }
  }

  // ════════════════════════════════════════════════════
  // GET equipment?type=list
  // Called when Continue is tapped with a preset selected
  // (after preset POST succeeds) AND also for Custom Setup Continue
  // ════════════════════════════════════════════════════
  final RxList<EquipmentCategoryModel> equipmentCategories =
      <EquipmentCategoryModel>[].obs;
  final RxBool isLoadingEquipment = false.obs;
  final RxString equipmentError = ''.obs;

  // Keyed by category name → list of items with isSelected state
  final RxMap<String, List<EquipmentItemModel>> categoryItemsMap =
      <String, List<EquipmentItemModel>>{}.obs;

  // Collapse state per category — true = expanded
  final RxMap<String, bool> categoryExpanded = <String, bool>{}.obs;

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
              .map((e) => EquipmentCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
          equipmentCategories.value = categories;

          // Build item map + default all expanded
          final Map<String, List<EquipmentItemModel>> map = {};
          final Map<String, bool> expanded = {};
          for (final cat in categories) {
            map[cat.category] = cat.items
                .map((item) => EquipmentItemModel(
              id: item.id,
              name: item.name,
              isSelected: false,
            ))
                .toList();
            expanded[cat.category] = true;
          }
          categoryItemsMap.value = map;
          categoryExpanded.value = expanded;
        } else {
          equipmentError.value = json['message'] ?? 'Failed to load equipment';
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

  void toggleItem(String category, int itemIndex) {
    final list = categoryItemsMap[category];
    if (list != null && itemIndex < list.length) {
      list[itemIndex].isSelected = !list[itemIndex].isSelected;
      // Reset quantity to 1 when toggling on, keep when toggling off
      if (list[itemIndex].isSelected) {
        list[itemIndex].quantity = 1;
      }
      categoryItemsMap.refresh();
    }
  }

  void incrementItem(String category, int itemIndex) {
    final list = categoryItemsMap[category];
    if (list != null && itemIndex < list.length) {
      list[itemIndex].quantity++;
      categoryItemsMap.refresh();
    }
  }

  void decrementItem(String category, int itemIndex) {
    final list = categoryItemsMap[category];
    if (list != null && itemIndex < list.length && list[itemIndex].quantity > 1) {
      list[itemIndex].quantity--;
      categoryItemsMap.refresh();
    }
  }

  void toggleCategoryExpanded(String category) {
    categoryExpanded[category] = !(categoryExpanded[category] ?? true);
    categoryExpanded.refresh();
  }

  List<EquipmentItemModel> itemsFor(String category) =>
      categoryItemsMap[category] ?? [];

  int selectedCountFor(String category) =>
      categoryItemsMap[category]?.where((e) => e.isSelected).length ?? 0;

  bool isExpanded(String category) =>
      categoryExpanded[category] ?? true;

  // ════════════════════════════════════════════════════
  // UPLOAD PHOTO SCREEN — POST custom kitchen setup
  // Called when Continue is tapped on UploadKitchenPhotoScreen
  // This is the API that saves the full custom setup
  // ════════════════════════════════════════════════════
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final _picker = ImagePicker();
  final RxBool isSubmittingCustom = false.obs;

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (image != null) selectedImage.value = image;
  }

  void removeImage() => selectedImage.value = null;

  // Build payload: [{ "_id": "xxx", "quantity": 3 }, ...]
  // Uses actual quantity set by user via +/- controls
  List<Map<String, dynamic>> get selectedItemsPayload {
    final List<Map<String, dynamic>> result = [];
    for (final items in categoryItemsMap.values) {
      for (final item in items) {
        if (item.isSelected) {
          result.add(item.toPayload());
        }
      }
    }
    return result;
  }

  Future<bool> submitCustomKitchen() async {
    try {
      isSubmittingCustom.value = true;

      final List<Map<String, dynamic>> items = selectedItemsPayload;
      final String? imagePath = selectedImage.value?.path;
      final bool hasImage = imagePath != null && imagePath.isNotEmpty;

      ApiResponseModel response;

      if (hasImage) {
        // ── With image: multipartImage ──
        // items sent as JSON-encoded array in body field
        response = await ApiService.multipartImage(
          'equipment/kitchen',
          method: 'POST',
          body: {
            'items': items, // List<Map> — multipartImage jsonEncodes this
          },
          files: [
            {'name': 'image', 'image': imagePath},
          ],
        );
      } else {
        // ── No image: plain JSON POST ──
        // Dio sends List<Map> as proper JSON array: [{"_id":"xxx","quantity":1}]
        response = await ApiService.multipartImage(
          'equipment/kitchen',
          method: 'POST',
          body: {
            'items': items, // List<Map> — multipartImage jsonEncodes this
          },
        );
      }

      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> json = response.data;
        if (json['success'] == true) {
          return true;
        } else {
          Get.snackbar(
            'Error', json['message'] ?? 'Something went wrong.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
          return false;
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
        return false;
      }
    } catch (e) {
      debugPrint('submitCustomKitchen error: $e');
      Get.snackbar(
        'Error', 'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isSubmittingCustom.value = false;
    }
  }
}