import 'package:get/get.dart';

class KitchenEquipmentController extends GetxController {
  // ─── Kitchen Type ───
  final RxInt selectedKitchenType = 0.obs; // default: Standard Home Kitchen

  final List<Map<String, dynamic>> kitchenTypes = [
    {
      'title': 'Standard Home Kitchen',
      'subtitle': 'Oven, stove-top, basic pans, knives',
      'emoji': '🏠',
    },
    {
      'title': 'Minimal Kitchen',
      'subtitle': 'Stove-top only, basic tools',
      'emoji': '🔍',
    },
    {
      'title': 'Well-Equipped',
      'subtitle': 'Oven, blender, food processor, grill pan',
      'emoji': '⭐',
    },
    {
      'title': 'Custom Setup',
      'subtitle': '',
      'emoji': '🔨',
    },
  ];

  void selectKitchenType(int index) {
    selectedKitchenType.value = index;
  }

  // ─── Section expansion state ───
  final RxBool appliancesExpanded = true.obs;
  final RxBool pansPotsExpanded = true.obs;
  final RxBool toolsExpanded = false.obs;
  final RxBool specialEquipmentExpanded = false.obs;

  void toggleAppliances() =>
      appliancesExpanded.value = !appliancesExpanded.value;
  void togglePansPots() => pansPotsExpanded.value = !pansPotsExpanded.value;
  void toggleTools() => toolsExpanded.value = !toolsExpanded.value;
  void toggleSpecialEquipment() =>
      specialEquipmentExpanded.value = !specialEquipmentExpanded.value;

  // ─── Cooking Appliances ───
  final RxList<bool> appliancesSelected = <bool>[
    true,  // Oven
    true,  // Stove-top
    true,  // Microwave
    false, // Air fryer
    false, // Grill (indoor or outdoor)
    false, // Rice cooker
  ].obs;

  final List<String> appliances = [
    'Oven',
    'Stove-top',
    'Microwave',
    'Air fryer',
    'Grill (indoor or outdoor)',
    'Rice cooker',
  ];

  void toggleAppliance(int index) {
    appliancesSelected[index] = !appliancesSelected[index];
  }

  // ─── Pans & Pots ───
  final RxList<bool> pansPotsSelected = <bool>[
    true,  // Frying pan
    true,  // Sauce pot
    true,  // Large pot
    false, // Small pot
  ].obs;

  final List<String> pansPots = [
    'Frying pan',
    'Sauce pot',
    'Large pot',
    'Small pot',
  ];

  void togglePanPot(int index) {
    pansPotsSelected[index] = !pansPotsSelected[index];
  }

  // ─── Tools ───
  final RxList<bool> toolsSelected = <bool>[
    true,  // Sharp knife
    true,  // Fillet knife
    true,  // Cutting board
    false, // Blender
    false, // Food processor
  ].obs;

  final List<String> tools = [
    'Sharp knife',
    'Fillet knife',
    'Cutting board',
    'Blender',
    'Food processor',
  ];

  void toggleTool(int index) {
    toolsSelected[index] = !toolsSelected[index];
  }

  // ─── Special Equipment ───
  final RxList<bool> specialEquipmentSelected = <bool>[
    false, // Stand mixer
    false, // Sous-vide
    false, // Pizza stone
    false, // Wok
  ].obs;

  final List<String> specialEquipment = [
    'Stand mixer',
    'Sous-vide',
    'Pizza stone',
    'Wok',
  ];

  void toggleSpecialEquipments(int index) {
    specialEquipmentSelected[index] = !specialEquipmentSelected[index];
  }

  // ─── Recipe match % based on selected items ───
  double get matchPercent {
    int total = appliances.length +
        pansPots.length +
        tools.length +
        specialEquipment.length;
    int selected = appliancesSelected.where((e) => e).length +
        pansPotsSelected.where((e) => e).length +
        toolsSelected.where((e) => e).length +
        specialEquipmentSelected.where((e) => e).length;
    return selected / total;
  }
}