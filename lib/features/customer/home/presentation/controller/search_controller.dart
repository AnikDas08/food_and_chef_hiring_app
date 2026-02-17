import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../services/api/api_response_model.dart';
import '../../../../../services/api/api_service.dart';
import '../data/search_chef_mofel.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool hasSearched = false.obs;
  RxList<ChefData> searchResults = <ChefData>[].obs;
  RxString errorMessage = ''.obs;
  RxString searchText = ''.obs;
  bool isLoadingChefs = false;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
      if (searchController.text.isEmpty) {
        hasSearched.value = false;
        searchResults.clear();
      }
    });
  }

  // Auto-search logic
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        searchChefs(value.trim());
      }
    });
  }

  Future<void> searchChefs(String searchTerm) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      ApiResponseModel response = await ApiService.get('user/search-chefs?searchTerm=$searchTerm');

      if (response.statusCode == 200) {
        SearchChefResponse searchResponse = SearchChefResponse.fromJson(response.data);
        searchResults.assignAll(searchResponse.data ?? []);
        hasSearched.value = true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Error fetching data';
      }
    } catch (e) {
      errorMessage.value = 'Connection error';
    } finally {
      isLoading.value = false;
    }
  }

  /*Future<void> getChefs() async {
    isLoadingChefs = true;
    update();

    try {
      final response = await ApiService.get(
        "user/nearby-chefs",
      );

      if (response.statusCode == 200) {
        chefModel = ChefModel.fromJson(response.data);
        nearbyChefsList = chefModel?.data ?? [];
        isLoadingChefs = false;
        update();
      } else {
        isLoadingChefs = false;
        update();
        Utils.errorSnackBar('Error', 'Failed to fetch nearby chefs');
      }
    } catch (e) {
      isLoadingChefs = false;
      update();
      Utils.errorSnackBar('Error', e.toString());
    }
  }*/

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    searchResults.clear();
    hasSearched.value = false;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}