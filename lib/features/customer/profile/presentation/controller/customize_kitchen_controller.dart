import 'package:get/get.dart';

class CustomizeKitchenController extends GetxController {
  // ─── Kitchen Type ───
  final RxInt selectedKitchenType = 0.obs; // default: Standard Home Kitchen

  void selectKitchenType(int index) {
    selectedKitchenType.value = index;
  }

  // ─── Cooking Appliances (quantity based) ───
  final RxList<int> appliancesQty = <int>[
    1, // Oven
    1, // Stove-top
    1, // Microwave
    0, // Air fryer
    0, // Grill (indoor or outdoor)
    0, // Rice Cooker
  ].obs;

  final List<String> appliances = [
    'Oven',
    'Stove-top',
    'Microwave',
    'Air fryer',
    'Grill (indoor or outdoor)',
    'Rice Cooker',
  ];

  void incrementAppliance(int index) {
    appliancesQty[index] = appliancesQty[index] + 1;
  }

  void decrementAppliance(int index) {
    if (appliancesQty[index] > 0) {
      appliancesQty[index] = appliancesQty[index] - 1;
    }
  }

  // ─── Pans & Pots (quantity based) ───
  final RxList<int> pansPotsQty = <int>[
    1, // Frying pan
    1, // Sauce pot
    1, // Large pot
    0, // Small pot
  ].obs;

  final List<String> pansPots = [
    'Frying pan',
    'Sauce pot',
    'Large pot',
    'Small pot',
  ];

  void incrementPanPot(int index) {
    pansPotsQty[index] = pansPotsQty[index] + 1;
  }

  void decrementPanPot(int index) {
    if (pansPotsQty[index] > 0) {
      pansPotsQty[index] = pansPotsQty[index] - 1;
    }
  }

  // ─── Tools (quantity based) ───
  final RxList<int> toolsQty = <int>[
    1, // Sharp knife
    1, // Fillet knife
    1, // Cutting board
    0, // Blender
    0, // Food processor
  ].obs;

  final List<String> tools = [
    'Sharp knife',
    'Fillet knife',
    'Cutting board',
    'Blender',
    'Food processor',
  ];

  void incrementTool(int index) {
    toolsQty[index] = toolsQty[index] + 1;
  }

  void decrementTool(int index) {
    if (toolsQty[index] > 0) {
      toolsQty[index] = toolsQty[index] - 1;
    }
  }

  // ─── Special Equipment (quantity based) ───
  final RxList<int> specialEquipmentQty = <int>[
    0, // Stand mixer
    0, // Sous-vide
    0, // Pizza stone
    0, // Wok
  ].obs;

  final List<String> specialEquipment = [
    'Stand mixer',
    'Sous-vide',
    'Pizza stone',
    'Wok',
  ];

  void incrementSpecial(int index) {
    specialEquipmentQty[index] = specialEquipmentQty[index] + 1;
  }

  void decrementSpecial(int index) {
    if (specialEquipmentQty[index] > 0) {
      specialEquipmentQty[index] = specialEquipmentQty[index] - 1;
    }
  }

  // ─── Section expand toggles ───
  final RxBool appliancesExpanded = true.obs;
  final RxBool pansPotsExpanded = false.obs;
  final RxBool toolsExpanded = false.obs;
  final RxBool specialEquipmentExpanded = false.obs;

  void toggleAppliances() =>
      appliancesExpanded.value = !appliancesExpanded.value;
  void togglePansPots() =>
      pansPotsExpanded.value = !pansPotsExpanded.value;
  void toggleTools() => toolsExpanded.value = !toolsExpanded.value;
  void toggleSpecialEquipment() =>
      specialEquipmentExpanded.value = !specialEquipmentExpanded.value;

  // ─── Selected counts for each section (items with qty > 0) ───
  int get appliancesSelectedCount =>
      appliancesQty.where((q) => q > 0).length;

  int get pansPotsSelectedCount =>
      pansPotsQty.where((q) => q > 0).length;

  int get toolsSelectedCount =>
      toolsQty.where((q) => q > 0).length;

  int get specialEquipmentSelectedCount =>
      specialEquipmentQty.where((q) => q > 0).length;
}