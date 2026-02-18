import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/home/presentation/data/chef_model.dart';
import '../../../../../services/api/api_response_model.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../data/cousine_data.dart';
import '../data/search_chef_mofel.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool hasSearched = false.obs;
  RxBool isSubmitted = false.obs;
  RxList<ChefData> searchResults = <ChefData>[].obs;
  RxString errorMessage = ''.obs;
  RxString searchText = ''.obs;
  bool isLoadingChefs = false;
  bool isLoadingLocation = false;
  double? currentLat;
  double? currentLng;
  CuisineModel? cuisineModel;
  List<CuisineData> cuisineList = [];
  CuisineData? selectedCuisine;

  ChefModel? chefModel;
  ChefData? chefArg;
  CuisineData? cuisineData;
  List<ChefData> nearbyChefsList = [];

  /// Currently active sort/filter label (matches the chip label in SearchItem)
  String selectedSortLabel = "Recommended";

  Timer? _debounce;

  /// Maps chip label → query param string (appended to the base URL)
  static const Map<String, String> _sortParamMap = {
    "Recommended": "",
    "Rating": "sort=rating",
    "Price": "sort=price",
    "Next Available": "availability=next_week",
  };

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is CuisineData) {
      cuisineData = Get.arguments as CuisineData;
      searchController.text = cuisineData?.name ?? "";
      getChefsByCuisineId(cuisineData!.id!);
    } else {
      getCurrentLocationAndFetchChefs();
    }

    searchController.addListener(() {
      searchText.value = searchController.text;
      if (searchController.text.isEmpty) {
        hasSearched.value = false;
        isSubmitted.value = false;
        searchResults.clear();
        getCurrentLocationAndFetchChefs();
      }
    });
  }

  // ── Sort / filter ──────────────────────────────────────────────────────────

  /// Called when user taps a sort chip. Resets to "Recommended" silently
  /// if the label isn't in the map, then fetches with the right param.
  Future<void> onSortChanged(String label) async {
    if (selectedSortLabel == label) return; // no-op if already selected
    selectedSortLabel = label;
    update();
    await _fetchWithCurrentFilter();
  }

  /// Builds the URL and calls the API with whatever sort/filter is active,
  /// plus an optional search term (used when the user submitted a search).
  Future<void> _fetchWithCurrentFilter({String? searchTerm}) async {
    isLoadingChefs = true;
    update();

    try {
      final String sortParam = _sortParamMap[selectedSortLabel] ?? "";
      final List<String> params = [];
      if (searchTerm != null && searchTerm.isNotEmpty) {
        params.add("searchTerm=$searchTerm");
      }
      if (sortParam.isNotEmpty) {
        params.add(sortParam);
      }

      final String query =
      params.isNotEmpty ? "?${params.join('&')}" : "";
      final String url = "user/search-chefs$query";

      final response = await ApiService.get(url);

      if (response.statusCode == 200) {
        chefModel = ChefModel.fromJson(response.data);
        nearbyChefsList = chefModel?.data ?? [];
      } else {
        Utils.errorSnackBar('Error', 'Failed to fetch chefs');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingChefs = false;
      update();
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  void onSearchChanged(String value) {
    isSubmitted.value = false;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        searchChefs(value.trim());
      }
    });
  }

  void onSearchSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _debounce?.cancel();
    isSubmitted.value = true;
    getNearbyChefsByTerm(value.trim());
  }

  Future<void> searchChefs(String searchTerm) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      ApiResponseModel response = await ApiService.get(
        'user/search-chefs?searchTerm=$searchTerm',
      );

      if (response.statusCode == 200) {
        ChefModel searchResponse = ChefModel.fromJson(response.data);
        searchResults.assignAll(searchResponse.data ?? []);
        hasSearched.value = true;
      } else {
        errorMessage.value =
            response.data['message'] ?? 'Error fetching data';
      }
    } catch (e) {
      errorMessage.value = 'Connection error';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Location ───────────────────────────────────────────────────────────────

  Future<void> getCurrentLocationAndFetchChefs() async {
    isLoadingLocation = true;
    update();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Utils.errorSnackBar(
            'Location Error', 'Location services are disabled.');
        isLoadingLocation = false;
        update();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Utils.errorSnackBar(
              'Permission Denied', 'Location permission is required.');
          isLoadingLocation = false;
          update();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.errorSnackBar(
            'Permission Denied', 'Enable location in settings.');
        isLoadingLocation = false;
        update();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLat = position.latitude;
      currentLng = position.longitude;
      isLoadingLocation = false;
      update();

      await getNearbyChefs();
    } catch (e) {
      isLoadingLocation = false;
      update();
      Utils.errorSnackBar('Location Error', e.toString());
    }
  }

  Future<void> getChefsByCuisineId(String cuisineId) async {
    isLoadingChefs = true;
    update();

    try {
      final response = await ApiService.get(
        "user/search-chefs?cusine=$cuisineId",
      );

      if (response.statusCode == 200) {
        chefModel = ChefModel.fromJson(response.data);
        nearbyChefsList = chefModel?.data ?? [];
      } else {
        Utils.errorSnackBar('Error', 'No chefs found for this category');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingChefs = false;
      update();
    }
  }

  Future<void> getNearbyChefs() async {
    if (currentLat == null || currentLng == null) return;
    await _fetchWithCurrentFilter();
  }

  Future<void> getNearbyChefsByTerm(String searchTerm) async {
    await _fetchWithCurrentFilter(searchTerm: searchTerm);
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}