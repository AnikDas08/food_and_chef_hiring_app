import 'package:get/get.dart';

class KitchenSetupController extends GetxController {
  // ─── Screen 1: Kitchen Type Selection ───
  final RxInt selectedKitchenType = (-1).obs;

  final List<Map<String, dynamic>> kitchenTypes = [
    {
      'title': 'Standard Home Kitchen',
      'subtitle': 'Oven, stove-top, basic pans, knives',
      'emoji': '🏠',
    },
    {
      'title': 'Minimal Kitchen',
      'subtitle': 'Stove-top only, basic tools',
      'emoji': '🔥',
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

  // ─── Screen 2: Cooking Appliances ───
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

  // ─── Screen 3: Pans & Pots + Tools ───
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

  void togglePanPot(int index) {
    pansPotsSelected[index] = !pansPotsSelected[index];
  }

  void toggleTool(int index) {
    toolsSelected[index] = !toolsSelected[index];
  }

  // ─── Screen 4: Special Equipment ───
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

  void toggleSpecialEquipment(int index) {
    specialEquipmentSelected[index] = !specialEquipmentSelected[index];
  }

// ─── Screen 5: Upload Photo ───
// Integrate image_picker as needed
}