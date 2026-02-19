import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CafeAddMenuItemController extends GetxController {

  // ─── Text Controllers ─────────────────────────────────────────────────────
  final nameController = TextEditingController(text: "Quesadilla");
  final descriptionController = TextEditingController(
    text:
    "Home-cooked Chopped Burrito. Inspired by 10 years of experience in cooking in Mexican fine dining restaurants.\nServed with black beans and chilli sauce. One of my...",
  );

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
  };

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}