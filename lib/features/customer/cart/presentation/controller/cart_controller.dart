import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/extensions/extension.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../address/data/address_model.dart';
import '../../data/cart_model.dart';
import '../screen/stripe_webview_screen.dart';

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
  String menuId='';

  // ── Other state ─────────────────────────────────────────────────────────────
  bool isDefaultAddress = false;
  bool isExpanded = false;
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  /*final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "04:00 PM", "06:00 PM",
  ];*/

  @override
  void onInit(){
    super.onInit();
    if(Get.arguments!=null){
      fetchCardData();
    }
  }

  bool isCheckingOut = false;
  String? promoCode;

  void onPromoCodeApplied(String code) {
    promoCode = code.trim().isEmpty ? null : code.trim();
    update();
  }

  AddressModel? selectedAddress;

  void onAddressSelected(AddressModel address) {
    selectedAddress = address;
    update();
  }

  String? selectedTaxId;

  void onTaxSelected(String? taxId) {
    selectedTaxId = taxId;
    update();
  }

  final RxBool _isEditingOrder = false.obs;
  bool get isEditingOrder => _isEditingOrder.value;

  void toggleEditingOrder() {
    _isEditingOrder.value = !_isEditingOrder.value;
    update();
  }

  Future<void> updateCartCustomizations({
    required String cartItemId,
    required List<String> customizations,
    required String chefId,
    int? quantity,
  }) async {
    // Optimistic Update
    for (var group in chefGroups) {
      final item = group.menus?.firstWhereOrNull((m) => m.id == cartItemId);
      if (item != null) {
        if (quantity != null) item.quantity = quantity;
        item.customizations = customizations;
        // Recalculate total price if needed (basic logic)
        if (item.unitPrice != null && item.quantity != null) {
          item.totalPrice = item.unitPrice! * item.quantity!;
        }
        break;
      }
    }
    update();

    try {
      final Map<String, dynamic> body = {'customizations': customizations};
      if (quantity != null) body['quantity'] = quantity;

      final response = await ApiService.patch(
        'cart/update/$cartItemId',
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.successSnackBar('Success', 'Cart updated successfully');
        await fetchCart(chefId);
      } else {
        Utils.errorSnackBar('Error', 'Failed to update cart');
        await fetchCart(chefId); // Revert on error
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      await fetchCart(chefId); // Revert on error
    }
  }

  Future<void> placeOrder() async {
    // ── Validations ──────────────────────────────────────────────────────────
    if (selectedAddress == null) {
      Utils.errorSnackBar('Error', 'Please select a delivery address');
      return;
    }
    if (dateController.text.trim().isEmpty) {
      Utils.errorSnackBar('Error', 'Please select a booking date and time');
      return;
    }
    if (chefGroups.isEmpty) {
      Utils.errorSnackBar('Error', 'Your cart is empty');
      return;
    }

    isCheckingOut = true;
    update();

    try {
      // ── Build date string from selectedDate + selectedTime ───────────────
      // selectedDate is DateTime, selectedTime is e.g. "10:00 AM"
      final DateTime bookingDate = _buildBookingDateTime();

      // ── Build body ───────────────────────────────────────────────────────
      final Map<String, dynamic> body = {
        'chef': chefGroups.first.chef?.id ?? '',
        'address_id': selectedAddress!.id,
        'date': bookingDate.toUtc().toIso8601String(),
      };

      if (promoCode != null && promoCode!.isNotEmpty) {
        body['promo_code'] = promoCode;
      }

      if (selectedTaxId != null && selectedTaxId!.isNotEmpty) {
        body['tax_id'] = selectedTaxId;
      }

      final response = await ApiService.post('order', body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear cart state after successful order
        String? checkoutUrl;
        checkoutUrl=response.data['data'];
        cartResponse = null;
        selectedAddress = null;
        promoCode = null;
        selectedTaxId = null;
        dateController.clear();
        selectedTime = '';
        update();

        if(checkoutUrl!=null){
         await Get.to(
            StripeWebViewScreen(checkoutUrl: checkoutUrl),
          );
        }
        else{
          Utils.errorSnackBar(
              'Error', 'Failed to provide payment url');
        }

        //Get.offAllNamed(AppRoutes.orderSuccess); // or your success route
        //Utils.successSnackBar('Success', 'Order placed successfully');
      } else {
        Utils.errorSnackBar(
            'Error', response.data['message'] ?? 'Failed to place order');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isCheckingOut = false;
      update();
    }
  }



  DateTime _buildBookingDateTime() {
    if (selectedTime.isEmpty) return selectedDate;

    try {
      // Parse "10:00 AM" / "02:00 PM" format
      final parts = selectedTime.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final String period = parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );
    } catch (_) {
      return selectedDate;
    }
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
        'cart',
        body: {
          'menu': menuId,
          'quantity': quantity,
          'customizations': customizations,
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
      final response = await ApiService.get('cart?chefId=$chefId');
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

  Future<void> fetchCardData() async {
    isLoadingCart = true;
    update();

    try {
      final response = await ApiService.get('cart');
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
        'cart/$cartItemId',
        body: {'quantity': increment ? 1 : -1},
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
      final response = await ApiService.delete('cart/$cartItemId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(Get.context!);
        Utils.successSnackBar('Successful', 'Successfully Delete the');
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

    // ✅ FIX: Format the date/time properly for display in the text field
    // Example output: "1 January 2026, 10:00 AM"
    dateController.text = '${selectedDate.dateMonthYear}, $time';

    // Close the dialog
    Navigator.pop(Get.context!);

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
    //dateController.dispose();
    super.onClose();
  }
}