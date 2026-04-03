import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/storage/storage_services.dart';

class IngredientInputModel {
  final String name;
  final String quantity;
  final String unit;
  IngredientInputModel({required this.name, required this.quantity, required this.unit});

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity, 'unit': unit};
}

class MenuItemModel {
  final String id;
  final List<String> images;
  final String name;
  final String description;
  final String menuSection;
  final List<String> dietTypes;
  final List<String> allergens;
  final String estCookingTime;
  final String estPrepTime;
  final List<String> customizations;
  final List<IngredientInputModel> ingredients;

  MenuItemModel({
    required this.id,
    required this.images,
    required this.name,
    required this.description,
    required this.menuSection,
    required this.dietTypes,
    required this.allergens,
    required this.estCookingTime,
    required this.estPrepTime,
    required this.customizations,
    required this.ingredients,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
    id: json['_id'] ?? '',
    images: List<String>.from(json['images'] ?? []),
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    menuSection: json['menu_section'] ?? '',
    dietTypes: List<String>.from(json['diet_types'] ?? []),
    allergens: List<String>.from(json['alergens'] ?? []),
    estCookingTime: json['est_cooking_time'] ?? '',
    estPrepTime: json['est_prep_time'] ?? '',
    customizations: List<String>.from(json['customizations'] ?? []),
    ingredients: (json['ingradients'] as List? ?? [])
        .map((e) => IngredientInputModel(
      name: e['name'] ?? '',
      quantity: e['quantity'] ?? '',
      unit: e['unit'] ?? '',
    ))
        .toList(),
  );
}

class MenuSectionModel {
  final String menuSection;
  final List<MenuItemModel> menus;

  MenuSectionModel({required this.menuSection, required this.menus});

  factory MenuSectionModel.fromJson(Map<String, dynamic> json) => MenuSectionModel(
    menuSection: json['menu_section'] ?? '',
    menus: (json['menus'] as List? ?? []).map((e) => MenuItemModel.fromJson(e)).toList(),
  );
}

class MenuCategoryModel {
  final String id;
  final String name;
  MenuCategoryModel({required this.id, required this.name});
}

class EquipmentModel {
  final String id;
  final String name;
  EquipmentModel({required this.id, required this.name});

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      EquipmentModel(id: json['_id'] ?? '', name: json['name'] ?? '');
}

class CafeAddMenuItemController extends GetxController {
  final RxList<MenuSectionModel> menuSections = <MenuSectionModel>[].obs;
  final RxBool isLoadingMenu = false.obs;

  final RxList<MenuCategoryModel> categoryModels = <MenuCategoryModel>[].obs;
  final RxList<String> categoryList = <String>[].obs;
  final RxBool isLoadingCategory = false.obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString _selectedCategory = ''.obs;
  final RxString _selectedDietType = 'Vegetarian'.obs;
  final RxString _selectedAllergen = 'peanuts'.obs;

  String get selectedCategory => _selectedCategory.value;
  String get selectedDietType => _selectedDietType.value;
  String get selectedAllergen => _selectedAllergen.value;

  final dietTypes = ["Vegetarian", "Vegan", "Non-Vegetarian", "Gluten-Free"];
  final allergens = ["peanuts", "dairy", "gluten", "eggs", "shellfish"];

  final prepTimeController = TextEditingController(text: "30");
  final cookTimeController = TextEditingController(text: "30");
  final RxString _selectedPrepUnit = 'Minutes'.obs;
  final RxString _selectedCookUnit = 'Minutes'.obs;
  String get selectedPrepUnit => _selectedPrepUnit.value;
  String get selectedCookUnit => _selectedCookUnit.value;
  final timeUnits = ["Minutes", "Hours"];

  void setPrepUnit(String val) => _selectedPrepUnit.value = val;
  void setCookUnit(String val) => _selectedCookUnit.value = val;

  final RxList<String> unitsList = <String>[].obs;
  final RxBool isLoadingUnits = false.obs;

  final RxList<EquipmentModel> equipmentList = <EquipmentModel>[].obs;
  final RxBool isLoadingEquipment = false.obs;
  final RxList<String> selectedEquipmentIds = <String>[].obs;
  final RxBool equipmentExpanded = false.obs;

  List<String> get selectedEquipmentNames => equipmentList
      .where((e) => selectedEquipmentIds.contains(e.id))
      .map((e) => e.name)
      .toList();

  void toggleEquipmentSelection(String id) {
    if (selectedEquipmentIds.contains(id)) {
      selectedEquipmentIds.remove(id);
    } else {
      selectedEquipmentIds.add(id);
    }
  }

  final RxList<IngredientInputModel> ingredientsList = <IngredientInputModel>[].obs;
  final RxBool ingredientsExpanded = false.obs;

  final RxList<String> customizeOptions = <String>[
    "Without onions",
    "Without iceberg lettuce",
    "Without cheese",
    "Without cucumber slices",
    "Without Tomato",
    "Without Bacon",
  ].obs;
  final RxBool customizeExpanded = true.obs;

  final Rx<File?> previewImage = Rx<File?>(null);
  final RxBool isSubmitting = false.obs;

  final RxBool isEditMode = false.obs;
  final RxString editingItemId = ''.obs;
  final RxString existingImageUrl = ''.obs;

  String get safeCategoryValue {
    if (categoryList.isEmpty) return '';
    return categoryList.contains(_selectedCategory.value)
        ? _selectedCategory.value
        : categoryList.first;
  }

  static CafeAddMenuItemController get instance {
    if (!Get.isRegistered<CafeAddMenuItemController>()) {
      Get.put(CafeAddMenuItemController());
    }
    return Get.find<CafeAddMenuItemController>();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchMenus();
    fetchEquipments();
    fetchUnits();
  }

  String get selectedCategoryId {
    final found = categoryModels.firstWhereOrNull((e) => e.name == selectedCategory);
    return found?.id ?? '';
  }

  void loadItemForEdit(MenuItemModel item) {
    isEditMode.value = true;
    editingItemId.value = item.id;
    nameController.text = item.name;
    descriptionController.text = item.description;

    _selectedCategory.value = item.menuSection;

    final prepParts = item.estPrepTime.split(' ');
    prepTimeController.text = prepParts.isNotEmpty ? prepParts[0] : '30';
    _selectedPrepUnit.value = prepParts.length > 1 ? prepParts[1] : 'Minutes';

    final cookParts = item.estCookingTime.split(' ');
    cookTimeController.text = cookParts.isNotEmpty ? cookParts[0] : '30';
    _selectedCookUnit.value = cookParts.length > 1 ? cookParts[1] : 'Minutes';

    if (item.dietTypes.isNotEmpty) _selectedDietType.value = item.dietTypes.first;
    if (item.allergens.isNotEmpty) _selectedAllergen.value = item.allergens.first;

    existingImageUrl.value = item.images.isNotEmpty ? item.images.first : '';
    previewImage.value = null;

    ingredientsList.value = List.from(item.ingredients);
    customizeOptions.value = item.customizations.isNotEmpty
        ? List.from(item.customizations)
        : [
      "Without onions",
      "Without iceberg lettuce",
      "Without cheese",
      "Without cucumber slices",
      "Without Tomato",
      "Without Bacon",
    ];
  }

  void resetForm() {
    isEditMode.value = false;
    editingItemId.value = '';
    existingImageUrl.value = '';
    nameController.clear();
    descriptionController.clear();
    prepTimeController.text = '30';
    cookTimeController.text = '30';
    _selectedPrepUnit.value = 'Minutes';
    _selectedCookUnit.value = 'Minutes';
    _selectedDietType.value = 'Vegetarian';
    _selectedAllergen.value = 'peanuts';
    previewImage.value = null;
    ingredientsList.clear();
    selectedEquipmentIds.clear();
    customizeOptions.value = [
      "Without onions",
      "Without iceberg lettuce",
      "Without cheese",
      "Without cucumber slices",
      "Without Tomato",
      "Without Bacon",
    ];
  }

  Future<void> fetchUnits() async {
    isLoadingUnits.value = true;
    try {
      final response = await ApiService.get(ApiEndPoint.getUnits);
      if (response.statusCode == 200 && response.data['success'] == true) {
        unitsList.value = List<String>.from(response.data['data'] ?? []);
      }
    } catch (e) {
      debugPrint("❌ Units fetch error: $e");
    } finally {
      isLoadingUnits.value = false;
    }
  }

  Future<void> fetchEquipments() async {
    isLoadingEquipment.value = true;
    try {
      final response = await ApiService.get(ApiEndPoint.getEquipments);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        equipmentList.value = list.map((e) => EquipmentModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("❌ Equipment fetch error: $e");
    } finally {
      isLoadingEquipment.value = false;
    }
  }
  Future<void> fetchCategories() async {
    isLoadingCategory.value = true;
    try {
      final response =
      await ApiService.get("${ApiEndPoint.AddMenuSection}${LocalStorage.userId}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        final seen = <String>{};
        categoryModels.value = list
            .map((e) => MenuCategoryModel(id: e['_id'] ?? '', name: e['name'] ?? ''))
            .where((e) => e.name.isNotEmpty && seen.add(e.name))
            .toList();
        categoryList.value = categoryModels.map((e) => e.name).toList();

        final defaults = ['Starter', 'Main Dish', 'Dessert'];

        for (final name in defaults) {
          if (!categoryList.contains(name)) {
            try {
              await ApiService.post(
                "${ApiEndPoint.AddMenuSection}${LocalStorage.userId}",
                body: {"name": name},
              );
              categoryList.add(name);
              categoryModels.add(MenuCategoryModel(id: '', name: name));
            } catch (_) {}
          }
        }

        if (categoryList.isNotEmpty) {
          _selectedCategory.value = categoryList.first;
        }
      }
    } catch (e) {
      debugPrint("❌ Category fetch error: $e");
      Get.snackbar("Error", "Failed to load categories.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingCategory.value = false;
    }
  }

  Future<void> fetchMenus() async {
    isLoadingMenu.value = true;
    try {
      final response =
      await ApiService.get("${ApiEndPoint.addMenuItem}${LocalStorage.userId}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        final List<MenuItemModel> items =
        list.map((e) => MenuItemModel.fromJson(e)).toList();

        final Map<String, List<MenuItemModel>> grouped = {};
        for (var item in items) {
          final section = item.menuSection.isEmpty ? "Other" : item.menuSection;
          grouped.putIfAbsent(section, () => []).add(item);
        }

        menuSections.value = grouped.entries
            .map((e) => MenuSectionModel(menuSection: e.key, menus: e.value))
            .toList();
      }
    } catch (e) {
      debugPrint("Menu fetch error: $e");
    } finally {
      isLoadingMenu.value = false;
    }
  }

  Future<void> submitMenuItem() async {

    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Message", "Item name is required", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (ingredientsList.isEmpty) {
      Get.snackbar("message", "Please add at least one ingredient", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('name', nameController.text.trim()),
        MapEntry('description', descriptionController.text.trim()),
        MapEntry('menu_section', selectedCategory),
        MapEntry('est_prep_time', "${prepTimeController.text.trim()} $selectedPrepUnit"),
        MapEntry('est_cooking_time', "${cookTimeController.text.trim()} $selectedCookUnit"),
        MapEntry('diet_types[]', selectedDietType),
        MapEntry('alergens[]', selectedAllergen),
      ]);

      for (final opt in customizeOptions) {
        formData.fields.add(MapEntry('customizations[]', opt));
      }
      for (final id in selectedEquipmentIds) {
        formData.fields.add(MapEntry('special_equipment[]', id));
      }

      formData.fields.add(MapEntry(
        'ingradients',
        jsonEncode(ingredientsList.map((e) => e.toJson()).toList()),
      ));

      if (previewImage.value != null) {
        final file = previewImage.value!;
        final ext = file.path.split('.').last.toLowerCase();
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            file.path,
            filename: "image.$ext",
            contentType: DioMediaType.parse(lookupMimeType(file.path) ?? 'image/jpeg'),
          ),
        ));
      }

      final response = await ApiService.post(
        "${ApiEndPoint.addMenuItem}${LocalStorage.userId}",
        body: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ POST response diye directly UI-te add koro — GET call lagbe na
        final newItem = MenuItemModel.fromJson(response.data['data']);
        final sectionName = newItem.menuSection.isEmpty ? "Other" : newItem.menuSection;

        final existingSection = menuSections.firstWhereOrNull(
              (s) => s.menuSection == sectionName,
        );

        if (existingSection != null) {
          existingSection.menus.add(newItem);
        } else {
          menuSections.add(MenuSectionModel(menuSection: sectionName, menus: [newItem]));
        }
        menuSections.refresh();

        Get.back(result: true);
        Get.snackbar("Success", "Menu item added successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error", "${response.data['message'] ?? 'Failed to add menu item.'}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint("Submit error: $e");
      Get.snackbar("Error", "Something went wrong: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateMenuItem() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Item name is required", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('name', nameController.text.trim()),
        MapEntry('description', descriptionController.text.trim()),
        MapEntry('menu_section', selectedCategory),
        MapEntry('est_prep_time', "${prepTimeController.text.trim()} $selectedPrepUnit"),
        MapEntry('est_cooking_time', "${cookTimeController.text.trim()} $selectedCookUnit"),
        MapEntry('diet_types[]', selectedDietType),
        MapEntry('alergens[]', selectedAllergen),
      ]);

      for (final opt in customizeOptions) {
        formData.fields.add(MapEntry('customizations[]', opt));
      }
      for (final id in selectedEquipmentIds) {
        formData.fields.add(MapEntry('special_equipment[]', id));
      }

      formData.fields.add(MapEntry(
        'ingradients',
        jsonEncode(ingredientsList.map((e) => e.toJson()).toList()),
      ));

      if (previewImage.value != null) {
        final file = previewImage.value!;
        final ext = file.path.split('.').last.toLowerCase();
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            file.path,
            filename: "image.$ext",
            contentType: DioMediaType.parse(lookupMimeType(file.path) ?? 'image/jpeg'),
          ),
        ));
      }

      final response = await ApiService.patch(
        "${ApiEndPoint.baseUrl}menu/${editingItemId.value}",
        body: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ PATCH response diye directly UI update koro — GET call lagbe na
        final updatedItem = MenuItemModel.fromJson(response.data['data']);
        for (var section in menuSections) {
          final idx = section.menus.indexWhere((m) => m.id == updatedItem.id);
          if (idx != -1) {
            section.menus[idx] = updatedItem;
          }
        }
        menuSections.refresh();

        Get.back(result: true);
        Get.snackbar("Success", "Menu item updated successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error", "${response.data['message'] ?? 'Failed to update menu item.'}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint("Update error: $e");
      Get.snackbar("Error", "Something went wrong: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> addMenuSection(String sectionName) async {
    menuSections.add(MenuSectionModel(menuSection: sectionName, menus: []));
    try {
      await ApiService.post(
          "${ApiEndPoint.AddMenuSection}${LocalStorage.userId}", body: {"name": sectionName});
    } catch (e) {
      debugPrint(" Add section error: $e");
    }
  }

  Future<void> deleteMenuItem(String itemId) async {
    for (var section in menuSections) {
      section.menus.removeWhere((item) => item.id == itemId);
    }
    menuSections.refresh();
    try {
      await ApiService.delete("${ApiEndPoint.baseUrl}menu/$itemId");
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }

  Future<void> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) previewImage.value = File(picked.path);
  }

  void setCategory(String val) => _selectedCategory.value = val;
  void setDietType(String val) => _selectedDietType.value = val;
  void setAllergen(String val) => _selectedAllergen.value = val;

  void toggleCustomize() => customizeExpanded.value = !customizeExpanded.value;
  void toggleIngredients() => ingredientsExpanded.value = !ingredientsExpanded.value;
  void toggleEquipment() => equipmentExpanded.value = !equipmentExpanded.value;

  void addCustomizeOption(String val) {
    if (val.trim().isNotEmpty) customizeOptions.add(val.trim());
  }

  void removeCustomizeOption(String val) => customizeOptions.remove(val);

  void addIngredient(String name, String quantity, String unit) {
    if (name.trim().isNotEmpty) {
      ingredientsList.add(
          IngredientInputModel(name: name.trim(), quantity: quantity.trim(), unit: unit));
    }
  }

  void removeIngredient(int index) => ingredientsList.removeAt(index);

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    prepTimeController.dispose();
    cookTimeController.dispose();
    super.onClose();
  }
}