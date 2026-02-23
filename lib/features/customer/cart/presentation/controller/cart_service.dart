import 'package:get/get.dart';

/// A single cart item stored in CartService.
class CartItemModel {
  final String id;
  final String name;
  final String? image;
  final String? cookingTime;
  final List<String> customizations;
  final double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    this.image,
    this.cookingTime,
    this.customizations = const [],
    this.price = 0.0,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}

/// Registered once in main (or binding) via Get.put(CartService()).
/// Both ChefDetailsController and CartController read from here.
class CartService extends GetxService {
  static CartService get instance => Get.find<CartService>();

  RxList<CartItemModel> items = <CartItemModel>[].obs;

  int get totalCount => items.length;

  void addItem(CartItemModel newItem) {
    final existing = items.firstWhereOrNull((i) => i.id == newItem.id);
    if (existing != null) {
      existing.quantity++;
      items.refresh();
    } else {
      items.add(newItem);
    }
  }

  void increment(String id) {
    final item = items.firstWhereOrNull((i) => i.id == id);
    if (item != null) {
      item.quantity++;
      items.refresh();
    }
  }

  void decrement(String id) {
    final item = items.firstWhereOrNull((i) => i.id == id);
    if (item != null) {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        items.remove(item);
      }
      items.refresh();
    }
  }

  void remove(String id) {
    items.removeWhere((i) => i.id == id);
  }

  /// Sum of (price × quantity) for every item in the cart.
  double get subtotal => items.fold(0.0, (sum, i) => sum + i.totalPrice);

  void clear() => items.clear();
}