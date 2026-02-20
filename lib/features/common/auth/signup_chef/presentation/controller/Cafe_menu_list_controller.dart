import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CafeMenuItem {
  String name;
  int ingredients;
  int cookingMinutes;
  File? image;

  CafeMenuItem({
    required this.name,
    this.ingredients = 0,
    this.cookingMinutes = 0,
    this.image,
  });
}

class CafeMenuSection {
  String title;
  List<CafeMenuItem> items;

  CafeMenuSection({required this.title, List<CafeMenuItem>? items})
      : items = items ?? [];
}

class CafeMenuListController extends GetxController {

  final sections = <CafeMenuSection>[
    CafeMenuSection(
      title: "STARTERS",
      items: [
        CafeMenuItem(name: "Quesadilla", ingredients: 10, cookingMinutes: 40),
      ],
    ),
    CafeMenuSection(
      title: "MAIN COURSE",
      items: [
        CafeMenuItem(name: "Salisbury Ground Beef", ingredients: 12, cookingMinutes: 30),
        CafeMenuItem(name: "Lemon Chicken", ingredients: 10, cookingMinutes: 20),
      ],
    ),
  ].obs;

  static CafeMenuListController get instance => Get.put(CafeMenuListController());

  void addSection(String title) {
    if (title.trim().isEmpty) return;
    sections.add(CafeMenuSection(title: title.trim().toUpperCase()));
    update();
  }

  void addItem(CafeMenuSection section, String name, int ingredients, int cookingMinutes) {
    if (name.trim().isEmpty) return;
    section.items.add(CafeMenuItem(
      name: name.trim(),
      ingredients: ingredients,
      cookingMinutes: cookingMinutes,
    ));
    update();
  }

  void deleteItem(CafeMenuSection section, CafeMenuItem item) {
    section.items.remove(item);
    update();
  }

  Future<void> pickImage(CafeMenuItem item) async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      item.image = File(picked.path);
      update();
    }
  }
}