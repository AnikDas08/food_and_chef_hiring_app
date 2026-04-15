import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/utils/app_utils.dart';

class DietaryController extends GetxController {
  // ── CATEGORIES ─────────────────────────────────────────────────────────
  final List<String> categories = [
    'Allergies & Intolerance',
    'Religious & Ethical Restrictions',
    'Preferences & Lifestyle',
  ];

  // ── ALL items per category (loaded on init for edit screen) ─────────────
  RxMap<String, List<String>> itemsByCategory =
      <String, List<String>>{}.obs;

  // ── SELECTED items (what the user picks) ───────────────────────────────
  RxList<String> selectedDietaryItems = <String>[].obs;

  // ── SAVED items grouped by category (for view screen) ──────────────────
  RxMap<String, List<String>> groupedSavedItems =
      <String, List<String>>{}.obs;

  RxBool isLoadingDietary = false.obs;

  // kept for compat
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load categories FIRST, then saved prefs so grouping works correctly
    _loadAllThenSaved();
  }

  // ── LOAD ALL CATEGORY ITEMS, THEN SAVED PREFS ───────────────────────────
  Future<void> _loadAllThenSaved() async {
    isLoadingDietary.value = true;
    try {
      // Step 1: fetch all category items
      await _loadAllCategoryItems();
      // Step 2: now itemsByCategory is populated, safe to build grouping
      await loadSavedPreferences();
    } finally {
      isLoadingDietary.value = false;
    }
  }

  // ── FETCH ALL CATEGORIES ────────────────────────────────────────────────
  Future<void> _loadAllCategoryItems() async {
    try {
      for (final category in categories) {
        final encoded =
        category.replaceAll('&', '%26').replaceAll(' ', '%20');
        final response =
        await ApiService.get('dietary?category=$encoded');

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'] ?? [];
          itemsByCategory[category] = data.cast<String>();
        }
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // ── LOAD SAVED PREFERENCES FROM API ────────────────────────────────────
  Future<void> loadSavedPreferences() async {
    try {
      final response = await ApiService.get('user/profile');
      if (response.statusCode == 200) {
        final List<dynamic> foods =
            response.data['data']['foods'] ?? [];
        final saved = foods.cast<String>();

        // Pre-select saved items
        selectedDietaryItems.assignAll(saved);

        // Group saved items by category for view screen
        _buildGroupedSaved(saved);
      }
    } catch (e) {
      // silently fail — view screen shows empty state
    }
  }

  void _buildGroupedSaved(List<String> saved) {
    final Map<String, List<String>> grouped = {};

    for (final category in categories) {
      final allItemsInCategory = itemsByCategory[category] ?? [];
      // Match saved items that belong to this category
      final matched =
      allItemsInCategory.where((i) => saved.contains(i)).toList();
      if (matched.isNotEmpty) {
        grouped[category] = matched;
      }
    }

    // Fallback: if itemsByCategory still empty, show all saved under one group
    if (grouped.isEmpty && saved.isNotEmpty) {
      grouped['Selected'] = saved;
    }

    groupedSavedItems.assignAll(grouped);
  }

  // ── CHECK / TOGGLE ──────────────────────────────────────────────────────
  bool isItemSelected(String item) => selectedDietaryItems.contains(item);

  void toggleDietaryItem(String item) {
    if (selectedDietaryItems.contains(item)) {
      selectedDietaryItems.remove(item);
    } else {
      selectedDietaryItems.add(item);
    }
    selectedDietaryItems.refresh();
  }

  // ── SAVE ────────────────────────────────────────────────────────────────
  Future<void> saveDietaryPreferences() async {
    if (selectedDietaryItems.isEmpty) {
      Utils.errorSnackBar('Error', 'Please select at least one item');
      return;
    }

    isLoadingDietary.value = true;
    try {
      final response = await ApiService.patch(
        'user/profile',
        body: {'foods': selectedDietaryItems.toList()},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Rebuild grouped map for view screen
        _buildGroupedSaved(selectedDietaryItems.toList());
        await Future.delayed(const Duration(milliseconds: 400));
        Navigator.pop(Get.context!);
        Utils.successSnackBar('Success', 'Dietary preferences saved');
      } else {
        Utils.errorSnackBar(
            'Error', response.data['message'] ?? 'Failed to save');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingDietary.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}