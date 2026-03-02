import 'package:get/get.dart';

class GroceryController extends GetxController {
  // Partner Selection
  var selectedPartner = "Instacart".obs;

  // MULTI-SELECT: List of selected indexes
  var selectedBookingIndexes = <int>[0].obs;

  // Grocery Items List
  var basketItems = <Map<String, dynamic>>[
    {'name': 'Eggs', 'price': 70.00, 'items': 1, 'isSelected': true},
    {'name': 'Jasmine rice', 'price': 70.00, 'items': 1, 'isSelected': true},
    {'name': 'Vegetable oil', 'price': 70.00, 'items': 1, 'isSelected': true},
    {'name': 'White onion', 'price': 70.00, 'items': 1, 'isSelected': true},
  ].obs;

  // Suggested Items List
  var suggestedItems = <Map<String, dynamic>>[
    {'name': 'Eggs', 'price': 70.00, 'items': 1, 'isSelected': false},
    {'name': 'Jasmine rice', 'price': 70.00, 'items': 1, 'isSelected': false},
  ].obs;

  // Booking Data
  final List<Map<String, dynamic>> bookingList = [
    {
      "name": "Michael Alonso",
      "recipe": "6 Recipe • 18 Items",
      "userImg": "https://i.pravatar.cc/150?u=1",
      "images": ["https://picsum.photos/200", "https://picsum.photos/201"],
      "more": 4
    },
    {
      "name": "Michael Alonso",
      "recipe": "6 Recipe • 18 Items",
      "userImg": "https://i.pravatar.cc/150?u=2",
      "images": ["https://picsum.photos/202", "https://picsum.photos/203"],
      "more": 4
    },
  ];

  // Logic to toggle multi-selection
  void toggleBookingSelection(int index) {
    if (selectedBookingIndexes.contains(index)) {
      selectedBookingIndexes.remove(index);
    } else {
      selectedBookingIndexes.add(index);
    }
  }

  void toggleBasketItem(int index) {
    basketItems[index]['isSelected'] = !basketItems[index]['isSelected'];
    basketItems.refresh();
  }

  void toggleSuggestItem(int index) {
    suggestedItems[index]['isSelected'] = !suggestedItems[index]['isSelected'];
    suggestedItems.refresh();
  }
}