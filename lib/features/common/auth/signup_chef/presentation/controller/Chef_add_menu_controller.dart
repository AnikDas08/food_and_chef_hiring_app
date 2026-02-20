import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/storage/storage_services.dart';

// ── Models ──
class IngredientModel {
  final String name;
  final String quantity;
  final String unit;

  IngredientModel({required this.name, required this.quantity, required this.unit});

  factory IngredientModel.fromJson(Map<String, dynamic> json) => IngredientModel(
    name: json['name'] ?? '',
    quantity: json['quantity'] ?? '',
    unit: json['unit'] ?? '',
  );
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
  final List<IngredientModel> ingredients;

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
        .map((e) => IngredientModel.fromJson(e))
        .toList(),
  );
}

class MenuSectionModel {
  final String menuSection;
  final List<MenuItemModel> menus;

  MenuSectionModel({required this.menuSection, required this.menus});

  factory MenuSectionModel.fromJson(Map<String, dynamic> json) => MenuSectionModel(
    menuSection: json['menu_section'] ?? '',
    menus: (json['menus'] as List? ?? [])
        .map((e) => MenuItemModel.fromJson(e))
        .toList(),
  );
}

// ── Controller ──
class CafeAddMenuItemController extends GetxController {

  // ─── Fetch Menu ───────────────────────────────────────────────────────────
  final RxList<MenuSectionModel> menuSections = <MenuSectionModel>[].obs;
  final RxBool isLoadingMenu = false.obs;

  Future<void> fetchMenus() async {
    isLoadingMenu.value = true;
    try {
      final response = await ApiService.get(
        "${ApiEndPoint.baseUrl}menu/type-based?id=${LocalStorage.userId}",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List list = data['data'] ?? [];
          menuSections.value =
              list.map((e) => MenuSectionModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Menu fetch error: $e");
    } finally {
      isLoadingMenu.value = false;
    }
  }

  // ─── Text Controllers ─────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // ─── Dropdown values ──────────────────────────────────────────────────────
  String selectedCategory = "Starter";
  String selectedDietType = "Vegetarian";
  String selectedAllergen = "peanuts";
  String selectedPrepTime = "40 minutes";
  String selectedCookTime = "40 minutes";

  final categories = ["Starter", "Main Course", "Dessert", "Drinks"];
  final dietTypes = ["Vegetarian", "Vegan", "Non-Vegetarian", "Gluten-Free"];
  final allergens = ["peanuts", "dairy", "gluten", "eggs", "shellfish"];
  final times = ["10 minutes", "20 minutes", "30 minutes", "40 minutes", "60 minutes"];

  // ─── Customize the Dish ───────────────────────────────────────────────────
  final customizeOptions = <String>[
    "Without onions",
    "Without iceberg lettuce",
    "Without cheese",
    "Without cucumber slices",
    "Without Tomato",
    "Without Bacon",
  ].obs;
  bool customizeExpanded = true;

  // ─── Ingredients ──────────────────────────────────────────────────────────
  final ingredients = <String>[].obs;
  bool ingredientsExpanded = false;

  // ─── Special Equipment ────────────────────────────────────────────────────
  final specialEquipment = <String>[].obs;
  bool equipmentExpanded = false;

  // ─── Image ────────────────────────────────────────────────────────────────
  File? previewImage;

  static CafeAddMenuItemController get instance =>
      Get.put(CafeAddMenuItemController());

  @override
  void onInit() {
    super.onInit();
    fetchMenus(); // ← screen খুললেই fetch হবে
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  Future<void> pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      previewImage = File(picked.path);
      update();
    }
  }

  void setCategory(String val) { selectedCategory = val; update(); }
  void setDietType(String val) { selectedDietType = val; update(); }
  void setAllergen(String val) { selectedAllergen = val; update(); }
  void setPrepTime(String val) { selectedPrepTime = val; update(); }
  void setCookTime(String val) { selectedCookTime = val; update(); }

  void toggleCustomize() { customizeExpanded = !customizeExpanded; update(); }
  void toggleIngredients() { ingredientsExpanded = !ingredientsExpanded; update(); }
  void toggleEquipment() { equipmentExpanded = !equipmentExpanded; update(); }

  void addCustomizeOption(String val) {
    if (val.trim().isNotEmpty) { customizeOptions.add(val.trim()); update(); }
  }

  void removeCustomizeOption(String val) {
    customizeOptions.remove(val);
    update();
  }

  void addIngredient(String val) {
    if (val.trim().isNotEmpty) { ingredients.add(val.trim()); update(); }
  }

  void addEquipment(String val) {
    if (val.trim().isNotEmpty) { specialEquipment.add(val.trim()); update(); }
  }

  Map<String, dynamic> getItemData() => {
    'name': nameController.text.trim(),
    'description': descriptionController.text.trim(),
    'category': selectedCategory,
    'dietType': selectedDietType,
    'allergen': selectedAllergen,
    'prepTime': selectedPrepTime,
    'cookTime': selectedCookTime,
    'customizeOptions': customizeOptions.toList(),
    'ingredients': ingredients.toList(),
    'specialEquipment': specialEquipment.toList(),
    'imagePath': previewImage?.path,
  };

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}