import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/home/presentation/data/chef_model.dart';
import '../../../../../services/api/api_response_model.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../data/cousine_data.dart';

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

  // ── CUISINES ────────────────────────────────────────────────────────────────
  RxBool isLoadingCuisines = false.obs;
  List<CuisineData> cuisineList = [];

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

  // ── FILTER STATE ────────────────────────────────────────────────────────────
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 100.0.obs;
  RxList<String> selectedAvailability = <String>[].obs;
  RxList<String> selectedProfessionalLevels = <String>[].obs;
  RxList<String> selectedDietaryPrefs = <String>[].obs;
  RxList<String> selectedCuisines = <String>[].obs;
  RxBool savedChefsOnly = false.obs;

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

    // Fetch cuisines for filter panel
    fetchCuisines();
  }

  // ── FETCH CUISINES FROM API ────────────────────────────────────────────────

  Future<void> fetchCuisines() async {
    isLoadingCuisines.value = true;

    try {
      final response = await ApiService.get("cusine");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        cuisineList = data
            .map((item) => CuisineData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        Utils.errorSnackBar('Error', 'Failed to fetch cuisines');
        cuisineList = [];
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      cuisineList = [];
    } finally {
      isLoadingCuisines.value = false;
    }
  }

  // ── SORT / FILTER ──────────────────────────────────────────────────────────

  /// Called when user taps a sort chip
  Future<void> onSortChanged(String label) async {
    if (selectedSortLabel == label) return;
    selectedSortLabel = label;
    update();
    await _fetchWithCurrentFilter();
  }

  // ── BUILD FILTER URL ───────────────────────────────────────────────────────

  /// Builds the complete URL with all active filters
  String _buildFilterUrl({String? searchTerm}) {
    final List<String> params = [];

    // Search term
    if (searchTerm != null && searchTerm.isNotEmpty) {
      params.add("searchTerm=$searchTerm");
    }

    // Cuisine IDs (from selectedCuisines list)
    if (selectedCuisines.isNotEmpty) {
      params.add("cusine=${selectedCuisines.first}"); // API expects single cusine param
    }

    // Price range
    if (minPrice.value > 0 || maxPrice.value < 100) {
      params.add("minPrice=${minPrice.value.toInt()}");
      params.add("maxPrice=${maxPrice.value.toInt()}");
    }

    // Availability
    if (selectedAvailability.isNotEmpty) {
      params.add("availability=${selectedAvailability.first}");
    }

    // Professional level
    if (selectedProfessionalLevels.isNotEmpty) {
      String levels = selectedProfessionalLevels.join(',');
      params.add("chef_professional_level=$levels");
    }

    // Dietary preferences (as JSON array)
    if (selectedDietaryPrefs.isNotEmpty) {
      String dietary = jsonEncode(selectedDietaryPrefs);
      params.add("dietary=$dietary");
    }

    // Saved chefs only
    if (savedChefsOnly.value) {
      params.add("save=true");
    }

    // Sort
    final String sortParam = _sortParamMap[selectedSortLabel] ?? "";
    if (sortParam.isNotEmpty) {
      params.add(sortParam);
    }

    final String query = params.isNotEmpty ? "?${params.join('&')}" : "";
    return "user/search-chefs$query";
  }

  // ── APPLY FILTERS ──────────────────────────────────────────────────────────

  /// Called when user taps "Apply" button in filter panel
  Future<void> applyFilters() async {
    Get.back(); // Close filter panel
    await _fetchWithCurrentFilter();
  }

  /// Clears all filters and resets to defaults
  void clearAllFilters() {
    minPrice.value = 0.0;
    maxPrice.value = 100.0;
    selectedAvailability.clear();
    selectedProfessionalLevels.clear();
    selectedDietaryPrefs.clear();
    selectedCuisines.clear();
    savedChefsOnly.value = false;
    selectedSortLabel = "Recommended";
    update();
  }

  // ── FETCH WITH FILTERS ─────────────────────────────────────────────────────

  Future<void> _fetchWithCurrentFilter({String? searchTerm}) async {
    isLoadingChefs = true;
    update();

    try {
      final String url = _buildFilterUrl(searchTerm: searchTerm);
      print("🔍 Filter URL: $url"); // Debug log

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

  // ── SEARCH ─────────────────────────────────────────────────────────────────

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

  // ── LOCATION ───────────────────────────────────────────────────────────────

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