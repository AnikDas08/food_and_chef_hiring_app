import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../address/data/address_model.dart';
import '../../data/cart_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find<CartController>();

  // ── Cart API state ──────────────────────────────────────────────────────────
  CartResponseModel? cartResponse;
  CartResponseData? get cartData => cartResponse?.data;
  List<CartChefGroup> get chefGroups => cartData?.data ?? [];
  PriceBreakdown? get priceBreakdown => cartData?.priceBreakdown;
  String? get estimatedTime => cartData?.estimatedTime;

  bool isLoadingCart = false;
  bool isPostingCart = false;

  // ── Other state ─────────────────────────────────────────────────────────────
  bool isDefaultAddress = false;
  bool isExpanded = false;
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "04:00 PM", "06:00 PM",
  ];

  AddressModel? selectedAddress;

  void onAddressSelected(AddressModel address) {
    selectedAddress = address;
    update();
  }

  // ── POST → navigate ─────────────────────────────────────────────────────────

  Future<void> postCartAndNavigate({
    required String menuId,
    required String chefId,
    int quantity = 1,
    List<String> customizations = const [],
  }) async {
    isPostingCart = true;
    update();

    try {
      final response = await ApiService.post(
        "cart",
        body: {
          "menu": menuId,
          "quantity": quantity,
          "customizations": customizations,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCart(chefId);
        Get.toNamed(AppRoutes.cart);
      } else {
        Utils.errorSnackBar(
            'Error', response.data['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isPostingCart = false;
      update();
    }
  }

  // ── GET cart ────────────────────────────────────────────────────────────────

  Future<void> fetchCart(String chefId) async {
    isLoadingCart = true;
    update();

    try {
      final response = await ApiService.get("cart?chefId=$chefId");
      if (response.statusCode == 200) {
        cartResponse = CartResponseModel.fromJson(response.data);
      } else {
        Utils.errorSnackBar('Error', 'Failed to fetch cart');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingCart = false;
      update();
    }
  }

  // ── Update quantity (PUT cart/:cartItemId) ──────────────────────────────────

  Future<void> updateQuantity({
    required String cartItemId,
    required bool increment,
    required String chefId,
  }) async {
    // Instantly update the quantity on the local item so cart_screen
    // recalculates subtotal/total immediately via GetBuilder rebuild.
    for (final group in chefGroups) {
      final item = group.menus?.firstWhereOrNull((m) => m.id == cartItemId);
      if (item != null) {
        item.quantity = (item.quantity ?? 1) + (increment ? 1 : -1);
        item.totalPrice = (item.unitPrice ?? 0) * (item.quantity ?? 1);
        update(); // rebuild cart_screen instantly
        break;
      }
    }

    // Sync with server
    try {
      final response = await ApiService.patch(
        "cart/$cartItemId",
        body: {"quantity": increment ? 1 : -1},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCart(chefId); // refresh with real server values
      } else {
        Utils.errorSnackBar('Error', 'Failed to update quantity');
        await fetchCart(chefId); // revert on failure
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      await fetchCart(chefId);
    }
  }

  // ── Delete cart item (DELETE cart/:cartItemId) ──────────────────────────────

  Future<void> deleteCartItem({
    required String cartItemId,
    required String chefId,
  }) async {
    try {
      final response = await ApiService.delete("cart/$cartItemId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCart(chefId);
      } else {
        Utils.errorSnackBar('Error', 'Failed to delete item');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // ── Misc ────────────────────────────────────────────────────────────────────

  void selectDate(DateTime date) { selectedDate = date; update(); }

  void selectTime(String time) {
    selectedTime = time;
    dateController.text = "${selectedDate.dateMonthYear}, $time";
    Get.back();
    update();
  }

  void onChangeDefaultAddress(value) {
    isDefaultAddress = value ?? false;
    update();
  }

  void onChangeExpanded() {
    isExpanded = !isExpanded;
    update();
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}