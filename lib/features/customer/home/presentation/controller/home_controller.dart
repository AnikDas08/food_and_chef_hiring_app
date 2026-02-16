import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/utils/app_utils.dart';

import '../data/cousine_data.dart';
import '../data/chef_model.dart';

class HomeController extends GetxController {
  RangeValues values = const RangeValues(20, 100);

  bool saved = false;
  String address = "";
  bool isLoadingChefs = false;
  bool isLoadingLocation = false;

  // Location variables
  double? currentLat;
  double? currentLng;

  List<String> cuisineOption = [
    "Health food",
    "Vegan",
    "Chinese",
    "American",
    "Italian",
    "Mexican",
    "Japanese",
    "Indian",
  ];

  CuisineModel? cuisineModel;
  List<CuisineData> cuisineList = [];

  // Nearby chefs data
  ChefModel? chefModel;
  List<ChefData> nearbyChefsList = [];

  List<String> timeOption = ["Today", "Tomorrow", "This week", "Next week"];
  List<String> levelOption = [
    "No restaurant experience",
    "Restaurant experience",
    "Fine dining experience",
  ];

  List<String> dietaryOption = [
    "Vegan",
    "Vegetarian",
    "Pescetarian",
    "Halal",
    "Kosher",
  ];

  List<String> selectTime = [];
  List<String> selectLevel = [];
  List<String> selectCuisine = [];
  List<String> selectDietary = [];

  onChangeTime(String value) {
    if (selectTime.contains(value)) {
      selectTime.remove(value);
      update();
      return;
    }
    selectTime.add(value);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getProfileData();
    getCusine();
    getCurrentLocationAndFetchChefs();
  }

  // Get current location with permission handling
  Future<void> getCurrentLocationAndFetchChefs() async {
    isLoadingLocation = true;
    update();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Utils.errorSnackBar(
          'Location Error',
          'Location services are disabled. Please enable them.',
        );
        isLoadingLocation = false;
        update();
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Utils.errorSnackBar(
            'Permission Denied',
            'Location permission is required to find nearby chefs.',
          );
          isLoadingLocation = false;
          update();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.errorSnackBar(
          'Permission Denied',
          'Location permission is permanently denied. Please enable it in settings.',
        );
        isLoadingLocation = false;
        update();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLng = position.longitude;

      isLoadingLocation = false;
      update();

      // Fetch nearby chefs with the obtained location
      await getNearbyChefs();
    } catch (e) {
      isLoadingLocation = false;
      update();
      Utils.errorSnackBar('Location Error', e.toString());
    }
  }

  // Fetch nearby chefs from API
  Future<void> getNearbyChefs() async {
    if (currentLat == null || currentLng == null) {
      Utils.errorSnackBar(
        'Location Error',
        'Unable to get your location. Please try again.',
      );
      return;
    }

    isLoadingChefs = true;
    update();

    try {
      final response = await ApiService.get(
        "user/nearby-chefs?lat=23.746445&lng=90.376013",
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
  }

  // Refresh chefs list
  Future<void> refreshChefs() async {
    await getCurrentLocationAndFetchChefs();
  }

  void getProfileData() async {
    try {
      final response = await ApiService.get(
        "user/profile",
      );
      if (response.statusCode == 200) {
        final data = response.data;
        address = response.data["data"]["address"];
        update();
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    }
  }

  void getCusine() async {
    try {
      final response = await ApiService.get("cusine");
      if (response.statusCode == 200) {
        final data = response.data;
        cuisineModel = CuisineModel.fromJson(response.data);
        cuisineList = cuisineModel?.data ?? [];
      }
    } catch (e) {}
  }

  onChangeCuisine(String value) {
    if (selectCuisine.contains(value)) {
      selectCuisine.remove(value);
      update();
      return;
    }

    selectCuisine.add(value);
    update();
  }

  onChangeLevel(String value) {
    if (selectLevel.contains(value)) {
      selectLevel.remove(value);
      update();
      return;
    }
    selectLevel.add(value);
    update();
  }

  onChangeDietary(String value) {
    if (selectDietary.contains(value)) {
      selectDietary.remove(value);
      update();
      return;
    }

    selectDietary.add(value);
    update();
  }

  onChangeSaved() {
    saved = !saved;
    update();
  }

  onChangeValue(newValue) {
    values = newValue;
    update();
  }
}