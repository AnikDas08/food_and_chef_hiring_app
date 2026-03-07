import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/app_utils.dart';
import 'package:new_untitled/utils/log/app_log.dart';
import '../../../cart/presentation/controller/cart_controller.dart';
import '../../../home/presentation/data/chef_model.dart';
import '../../data/chef_details.dart';
import '../../data/mamu_model.dart';

class ChefDetailsController extends GetxController {
  static ChefDetailsController get instance =>
      Get.find<ChefDetailsController>();

  ChefData? chefArg;
  ChefDetailModel? chefDetailModel;
  ChefDetailData? chefDetail;
  bool isLoadingDetail = false;

  // ── Menu state ──────────────────────────────────────────────────────────────
  Map<String, List<MenuData>> menuCache = {};
  Map<String, int> menuCurrentPage = {};
  Map<String, int> menuTotalPages = {};
  Map<String, bool> menuLoadingMore = {};
  bool isLoadingMenu = false;
  String selectedMenuSection = "Stater";
  static const int _pageLimit = 10;
  String chefId = "";

  @override
  void onInit() {
    super.onInit();
    // Ensure CartController is available
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }
    if (Get.arguments != null && Get.arguments is ChefData) {
      chefArg = Get.arguments as ChefData;
      chefId = chefArg!.id ?? ""; // ✅ FIX: Always set chefId from chefArg
      fetchChefDetails(chefArg!.id!);
    } else if (Get.arguments != null && Get.arguments is String) {
      chefId = Get.arguments;
      print("id: 😍😍😍😍😍😍😍${chefId}");
      fetchChefDetails(chefId);
    }
    ever(innerBoxIsScrolled, (bool value) {
      appLog(value, source: "ChefDetailsController");
    });
  }

  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  List<String> timeSlots = []; // Start empty, fill from API
  bool isSlotLoading = false;

  // Method to fetch slots from API
  Future<void> fetchAvailableSlots() async {
    isSlotLoading = true;
    update();

    try {
      // Formatting date to "yyyy-MM-dd" or as required by your logic
      // The example shows "2026-01-12 8:20 PM", but usually availability
      // check only needs the date part.
      String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      final response = await ApiService.post(
        "user/check-chef-availability/$chefId",
        body: {"date": formattedDate},
      );

      if (response.statusCode == 200) {
        // Map the "data" list from response to our timeSlots list
        timeSlots = List<String>.from(response.data['data']);
      } else {
        timeSlots = [];
        Get.snackbar("Error", "Could not fetch slots");
      }
    } catch (e) {
      timeSlots = [];
      debugPrint("Slot Fetch Error: $e");
    } finally {
      isSlotLoading = false;
      update();
    }
  }

  void selectDate(DateTime date, String passedChefId)async {
    selectedDate = date;
    selectedTime = ""; // Reset time when date changes

    // Update the controller's chefId with the one passed from the popup
    await fetchChefDetails(passedChefId);
    chefId = passedChefId;

    // 1. Fetch the slots for the calendar
    fetchAvailableSlots();


    update();
  }

  void selectTime(String time) {
    selectedTime = time;
    update();
  }

  // ── Chef detail ─────────────────────────────────────────────────────────────

  Future<void> fetchChefDetails(String chefId) async {
    isLoadingDetail = true;
    update();
    try {
      final response = await ApiService.get("user/chef-details/$chefId");
      if (response.statusCode == 200) {
        chefDetailModel = ChefDetailModel.fromJson(response.data);
        chefDetail = chefDetailModel?.data;
        final sections = chefDetail?.menuSections ?? [];
        if (sections.isNotEmpty) selectedMenuSection = sections.first;
      } else {
        Utils.errorSnackBar('Error', 'Failed to fetch chef details');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingDetail = false;
      update();
    }
  }

  // ── Menu pagination ─────────────────────────────────────────────────────────

  Future<void> fetchMenuForSection(String section) async {
    if (menuCache.containsKey(section)) return;
    if (chefArg?.id == null && chefId.isEmpty) return; // ← allow chefId alone
    await _fetchMenuPage(section, page: 1);
  }

  Future<void> loadMoreMenu(String section) async {
    final currentPage = menuCurrentPage[section] ?? 1;
    final totalPages = menuTotalPages[section] ?? 1;
    final isAlreadyLoading = menuLoadingMore[section] ?? false;
    if (isAlreadyLoading || currentPage >= totalPages) return;
    await _fetchMenuPage(section, page: currentPage + 1, isLoadMore: true);
  }

  bool hasMorePages(String section) =>
      (menuCurrentPage[section] ?? 1) < (menuTotalPages[section] ?? 1);

  bool isLoadingMoreForSection(String section) =>
      menuLoadingMore[section] ?? false;

  Future<void> _fetchMenuPage(String section,
      {required int page, bool isLoadMore = false}) async {
    final id = chefArg?.id ?? chefId;
    if (id.isEmpty) return;

    if (isLoadMore) {
      menuLoadingMore[section] = true;
    } else {
      selectedMenuSection = section;
      isLoadingMenu = true;
    }
    update();

    try {
      final response = await ApiService.get(
        "menu/chef/$id?menu_section=$section&page=$page&limit=$_pageLimit",
      );
      if (response.statusCode == 200) {
        final model = MenuModel.fromJson(response.data);
        final newItems = model.data ?? [];
        menuCurrentPage[section] = model.pagination?.page ?? page;
        menuTotalPages[section] = model.pagination?.totalPage ?? 1;
        if (isLoadMore) {
          menuCache[section] = [...(menuCache[section] ?? []), ...newItems];
        } else {
          menuCache[section] = newItems;
        }
      } else {
        if (!isLoadMore) menuCache[section] = [];
        Utils.errorSnackBar('Error', 'Failed to fetch menu');
      }
    } catch (e) {
      if (!isLoadMore) menuCache[section] = [];
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      if (isLoadMore) {
        menuLoadingMore[section] = false;
      } else {
        isLoadingMenu = false;
        selectedMenuSection = section;
      }
      update();
    }
  }

  // ── Cart ─────────────────────────────────────────────────────────────────────

  /// Proxy to CartController so chef_details_screen.dart bottom bar stays reactive.
  List get cartItems => CartController.instance.chefGroups
      .expand((g) => g.menus ?? [])
      .toList();

  /// Called from item_details.dart "Add to Order" button.
  /// POSTs to cart API then navigates to CartScreen.
  Future<void> addToCart(Map<String, dynamic> data) async {
    final String menuId = data['id'] ?? '';
    final String chefId = chefArg?.id ?? '';
    final List<String> customizations =
    List<String>.from(data['customizations'] ?? []);

    if (menuId.isEmpty || chefId.isEmpty) {
      Utils.errorSnackBar('Error', 'Missing menu or chef information');
      return;
    }

    Get.back(); // close the bottom sheet first

    await CartController.instance.postCartAndNavigate(
      menuId: menuId,
      chefId: chefId,
      quantity: 1,
      customizations: customizations,
    );
  }

  // ── Cart item count (for bottom bar badge) ───────────────────────────────────

  /// Returns total items from the last fetched cart data.
  int get cartItemCount {
    final groups = CartController.instance.chefGroups;
    return groups.fold(0, (sum, g) => sum + (g.menus?.length ?? 0));
  }

  // ── Misc state ───────────────────────────────────────────────────────────────

  bool isFavorite = false;
  bool isExpanded = false;
  RxBool innerBoxIsScrolled = false.obs;

  List dish = [
    {"name": "Without onions", "isSelected": false},
    {"name": "Without iceberg lettuce", "isSelected": false},
    {"name": "Without cheese", "isSelected": false},
    {"name": "Without cucumber slices", "isSelected": false},
    {"name": "Without Tomato", "isSelected": false},
    {"name": "Without Bacon", "isSelected": false},
  ];

  onChangeInnerBoxIsScrolled(bool value) {
    if (innerBoxIsScrolled.value == value) return;
    innerBoxIsScrolled(value);
  }

  onChange() { isFavorite = !isFavorite; update(); }
  onChangeExpand() { isExpanded = !isExpanded; update(); }
  onChangeDish(int index) {
    dish[index]["isSelected"] = !dish[index]["isSelected"];
    update();
  }
}