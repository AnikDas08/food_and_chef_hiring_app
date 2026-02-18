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

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    // ✅ On init: load nearby chefs by location
    if (Get.arguments != null && Get.arguments is CuisineData) {
      cuisineData = Get.arguments as CuisineData;

      // 2. Set the UI text so the user knows what they clicked
      searchController.text = cuisineData?.name ?? "";

      // 3. Fetch chefs using the ID
      getChefsByCuisineId(cuisineData!.id!);
    } else {
      // Normal flow if no category was selected
      getCurrentLocationAndFetchChefs();
    }

    searchController.addListener(() {
      searchText.value = searchController.text;
      if (searchController.text.isEmpty) {
        hasSearched.value = false;
        isSubmitted.value = false;
        searchResults.clear();
        // ✅ When cleared: reload location-based nearby chefs
        getCurrentLocationAndFetchChefs();
      }
    });
    if (Get.arguments != null && Get.arguments is CuisineData) {
      cuisineData = Get.arguments as CuisineData;
    }
  }

  // ✅ Typing → live searchResults list (shown in searchResult widget)
  void onSearchChanged(String value) {
    isSubmitted.value = false;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        searchChefs(value.trim());
      }
    });
  }

  // ✅ Enter → populate nearbyChefsList from search term (shown in SearchItem grid)
  void onSearchSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _debounce?.cancel();
    isSubmitted.value = true;
    getNearbyChefsByTerm(value.trim());
  }

  // Live typing search — fills searchResults (used by searchResult widget)
  Future<void> searchChefs(String searchTerm) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      ApiResponseModel response = await ApiService.get(
        'user/search-chefs?searchTerm=$searchTerm',
      );

      if (response.statusCode == 200) {
        ChefModel searchResponse =
        ChefModel.fromJson(response.data);
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

  // Initial load — location based
  Future<void> getCurrentLocationAndFetchChefs() async {
    isLoadingLocation = true;
    update();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Utils.errorSnackBar('Location Error', 'Location services are disabled.');
        isLoadingLocation = false;
        update();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Utils.errorSnackBar('Permission Denied', 'Location permission is required.');
          isLoadingLocation = false;
          update();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.errorSnackBar('Permission Denied', 'Enable location in settings.');
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
      // Using the ID in the query parameter (adjust key name based on your API)
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

  // Fills nearbyChefsList from lat/lng (initial state)
  Future<void> getNearbyChefs() async {
    if (currentLat == null || currentLng == null) return;

    isLoadingChefs = true;
    update();

    try {
      final response = await ApiService.get(
        //"user/nearby-chefs?lat=$currentLat&lng=$currentLng",
        "user/search-chefs",
      );

      if (response.statusCode == 200) {
        chefModel = ChefModel.fromJson(response.data);
        nearbyChefsList = chefModel?.data ?? [];
      } else {
        Utils.errorSnackBar('Error', 'Failed to fetch nearby chefs');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoadingChefs = false;
      update();
    }
  }

  // ✅ Fills nearbyChefsList from search term (after enter)
  // search-chefs returns the SAME JSON shape as nearby-chefs → use ChefModel.fromJson
  Future<void> getNearbyChefsByTerm(String searchTerm) async {
    isLoadingChefs = true;
    update();

    try {
      final response = await ApiService.get(
        "user/search-chefs?searchTerm=$searchTerm",
      );

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

  void clearSearch() {
    searchController.clear();
    // listener above handles the rest
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}