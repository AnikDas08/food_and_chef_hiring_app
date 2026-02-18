import 'package:get/get.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/utils/app_utils.dart';
import 'package:new_untitled/utils/log/app_log.dart';
import '../../../home/presentation/data/chef_model.dart';
import '../../data/chef_details.dart';
import '../../data/mamu_model.dart';

class ChefDetailsController extends GetxController {
  static ChefDetailsController get instance =>
      Get.find<ChefDetailsController>();

  // Chef passed from previous screen
  ChefData? chefArg;

  // Chef detail API data
  ChefDetailModel? chefDetailModel;
  ChefDetailData? chefDetail;
  bool isLoadingDetail = false;

  // ── Menu state per section ──────────────────────────────────────────────────
  Map<String, List<MenuData>> menuCache = {};   // loaded items per section
  Map<String, int> menuCurrentPage = {};        // current page per section
  Map<String, int> menuTotalPages = {};         // total pages per section
  Map<String, bool> menuLoadingMore = {};       // is-fetching-more per section
  bool isLoadingMenu = false;
  String selectedMenuSection = "Stater";

  static const int _pageLimit = 10;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ChefData) {
      chefArg = Get.arguments as ChefData;
      fetchChefDetails(chefArg!.id!);
    }
    ever(innerBoxIsScrolled, (bool value) {
      appLog(value, source: "ChefDetailsController");
    });
  }

  // Fetch chef detail
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

  // Called by each tab on first appearance — loads page 1 if not cached
  Future<void> fetchMenuForSection(String section) async {
    if (menuCache.containsKey(section)) return; // already loaded
    if (chefArg?.id == null) return;
    await _fetchMenuPage(section, page: 1);
  }

  // Load next page for a section (called on scroll-to-end)
  Future<void> loadMoreMenu(String section) async {
    final currentPage = menuCurrentPage[section] ?? 1;
    final totalPages = menuTotalPages[section] ?? 1;
    final isAlreadyLoading = menuLoadingMore[section] ?? false;

    if (isAlreadyLoading || currentPage >= totalPages) return;

    await _fetchMenuPage(section, page: currentPage + 1, isLoadMore: true);
  }

  bool hasMorePages(String section) {
    final currentPage = menuCurrentPage[section] ?? 1;
    final totalPages = menuTotalPages[section] ?? 1;
    return currentPage < totalPages;
  }

  bool isLoadingMoreForSection(String section) =>
      menuLoadingMore[section] ?? false;

  // Core fetch — handles both first load and pagination
  Future<void> _fetchMenuPage(String section,
      {required int page, bool isLoadMore = false}) async {
    if (chefArg?.id == null) return;

    if (isLoadMore) {
      menuLoadingMore[section] = true;
    } else {
      selectedMenuSection = section;
      isLoadingMenu = true;
    }
    update();

    try {
      final response = await ApiService.get(
        "menu/chef/${chefArg!.id}"
            "?menu_section=$section"
            "&page=$page"
            "&limit=$_pageLimit",
      );

      if (response.statusCode == 200) {
        final model = MenuModel.fromJson(response.data);
        final newItems = model.data ?? [];

        // Save pagination info
        menuCurrentPage[section] = model.pagination?.page ?? page;
        menuTotalPages[section] = model.pagination?.totalPage ?? 1;

        // Append or set
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

  // ── existing fields ─────────────────────────────────────────────────────────

  DateTime selectedDate = DateTime.now();
  List<String> selectedTime = [];
  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "02:00 PM", "04:00 PM", "06:00 PM",
  ];

  void selectDate(DateTime date) { selectedDate = date; update(); }

  void selectTime(String time) {
    if (selectedTime.contains(time)) {
      selectedTime.remove(time);
    } else {
      selectedTime.add(time);
    }
    update();
  }

  bool isFavorite = false;
  bool isExpanded = false;
  List cartItems = [];
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
    appLog(value, source: "ChefDetailsController onChangeInnerBoxIsScrolled");
    if (innerBoxIsScrolled.value == value) return;
    innerBoxIsScrolled(value);
  }

  onChange() { isFavorite = !isFavorite; update(); }
  onChangeExpand() { isExpanded = !isExpanded; update(); }
  addToCart(value) { cartItems.add(value); update(); Get.back(); }
  onChangeDish(int index) {
    dish[index]["isSelected"] = !dish[index]["isSelected"];
    update();
  }
}