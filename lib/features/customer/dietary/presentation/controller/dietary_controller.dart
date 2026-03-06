import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/utils/app_utils.dart';
import 'dart:convert';

class DietaryController extends GetxController {
  // ── DROPDOWN CATEGORIES ─────────────────────────────────────────────────
  final List<String> categories = [
    'Allergies & Intolerance',
    'Religious & Ethical Restrictions',
    'Preferences & Lifestyle'
  ];

  RxString selectedCategory = ''.obs;

  // ── DIETARY ITEMS FROM API ──────────────────────────────────────────────
  RxList<String> dietaryItems = <String>[].obs;
  RxList<String> selectedDietaryItems = <String>[].obs;
  RxBool isLoadingDietary = false.obs;

  // ── SEARCH ──────────────────────────────────────────────────────────────
  RxList<String> filteredDietaryItems = <String>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterDietaryItems);
  }

  // ── FETCH DIETARY ITEMS FROM API ────────────────────────────────────────
  Future<void> fetchDietaryItems(String category) async {
    if (category.isEmpty) return;

    isLoadingDietary.value = true;
    selectedDietaryItems.clear();

    try {
      final String encodedCategory = category.replaceAll('&', '%26').replaceAll(' ', '%20');
      final String url = 'dietary?category=$encodedCategory';

      print('🔍 Fetching from: $url');

      final response = await ApiService.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        dietaryItems.assignAll(data.cast<String>());
        filteredDietaryItems.assignAll(dietaryItems);
        print('✅ Loaded ${dietaryItems.length} dietary items');
      } else {
        Utils.errorSnackBar('Error', 'Failed to fetch dietary items');
        dietaryItems.clear();
        filteredDietaryItems.clear();
      }
    } catch (e) {
      print('❌ Error fetching dietary: $e');
      Utils.errorSnackBar('Error', e.toString());
      dietaryItems.clear();
      filteredDietaryItems.clear();
    } finally {
      isLoadingDietary.value = false;
    }
  }

  // ── FILTER DIETARY ITEMS BY SEARCH ──────────────────────────────────────
  void _filterDietaryItems() {
    final String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      filteredDietaryItems.assignAll(dietaryItems);
    } else {
      filteredDietaryItems.assignAll(
        dietaryItems.where((item) => item.toLowerCase().contains(query)).toList(),
      );
    }
  }

  // ── CHECK IF ITEM IS SELECTED ───────────────────────────────────────────
  bool isItemSelected(String item) {
    return selectedDietaryItems.contains(item);
  }

  // ── TOGGLE DIETARY ITEM SELECTION ──────────────────────────────────────
  void toggleDietaryItem(String item) {
    if (selectedDietaryItems.contains(item)) {
      selectedDietaryItems.remove(item);
    } else {
      selectedDietaryItems.add(item);
    }
    selectedDietaryItems.refresh();
  }

  // ── SAVE DIETARY PREFERENCES (PATCH /user/profile) ──────────────────────
  Future<void> saveDietaryPreferences() async {
    if (selectedDietaryItems.isEmpty) {
      Utils.errorSnackBar('Error', 'Please select at least one dietary item');
      return;
    }

    isLoadingDietary.value = true;

    try {
      // ✅ OPTION 1: Send as simple array (most likely format)
      final List<String> foodsList = selectedDietaryItems.toList();

      final Map<String, dynamic> body = {
        'foods': foodsList,
      };

      print('═══════════════════════════════════════════');
      print('📤 SENDING TO BACKEND');
      print('═══════════════════════════════════════════');
      print('Endpoint: PATCH /user/profile');
      print('Foods List: $foodsList');
      print('Body Type: ${body.runtimeType}');
      print('Body: $body');
      print('JSON String: ${jsonEncode(body)}');
      print('═══════════════════════════════════════════');

      final response = await ApiService.patch(
        'user/profile',
        body: body,
      );

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.successSnackBar('Success', 'Dietary preferences saved');
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to save';
        print('❌ Error: $errorMsg');
        Utils.errorSnackBar('Error', errorMsg);
      }
    } catch (e) {
      print('❌ Exception: $e');
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingDietary.value = false;
    }
  }

  // ── ALTERNATIVE: Save with JSON string (if backend expects string) ──────
  Future<void> saveDietaryPreferencesAsString() async {
    if (selectedDietaryItems.isEmpty) {
      Utils.errorSnackBar('Error', 'Please select at least one dietary item');
      return;
    }

    isLoadingDietary.value = true;

    try {
      // ✅ OPTION 2: Send foods as JSON string
      final List<String> foodsList = selectedDietaryItems.toList();
      final String foodsJsonString = jsonEncode(foodsList);

      final Map<String, dynamic> body = {
        'foods': foodsJsonString,
      };

      print('📤 Sending as JSON string...');
      print('Body: $body');

      final response = await ApiService.patch(
        'user/profile',
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.successSnackBar('Success', 'Dietary preferences saved');
        Get.back();
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Failed to save');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingDietary.value = false;
    }
  }


  // ── SELECT CATEGORY ────────────────────────────────────────────────────
  void selectCategory(String category) {
    selectedCategory.value = category;
    fetchDietaryItems(category);
  }

  // ── CLEAR SEARCH ───────────────────────────────────────────────────────
  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}