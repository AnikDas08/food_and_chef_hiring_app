
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:new_untitled/utils/app_utils.dart';

import '../../../../../services/storage/storage_keys.dart';
import '../../../../../services/storage/storage_services.dart';
import '../data/cousine_data.dart';
import '../data/chef_model.dart';
import '../data/order_model.dart';

class HomeController extends GetxController {
  RangeValues values = const RangeValues(20, 100);

  bool saved = false;
  String address = '';
  RxString defaultAddress = ''.obs;
  bool isLoadingChefs = false;
  bool isLoadingLocation = false;
  bool isLoadingOrderAgain = false;

  // Location variables
  double? currentLat;
  double? currentLng;

  List<String> cuisineOption = [
    'Health food',
    'Vegan',
    'Chinese',
    'American',
    'Italian',
    'Mexican',
    'Japanese',
    'Indian',
  ];

  CuisineModel? cuisineModel;
  List<CuisineData> cuisineList = [];

  // Nearby chefs data
  ChefModel? chefModel;
  List<ChefData> nearbyChefsList = [];

  // Order again data
  OrderAgainModel? orderAgainModel;
  List<OrderAgainData> orderAgainList = [];

  List<String> timeOption = ['Today', 'Tomorrow', 'This week', 'Next week'];
  List<String> levelOption = [
    'No restaurant experience',
    'Restaurant experience',
    'Fine dining experience',
  ];

  List<String> dietaryOption = [
    'Vegan',
    'Vegetarian',
    'Pescetarian',
    'Halal',
    'Kosher',
  ];

  List<String> selectTime = [];
  List<String> selectLevel = [];
  List<String> selectCuisine = [];
  List<String> selectDietary = [];

  void onChangeTime(String value) {
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
    getOrderAgain();
  }

  // Get current location with permission handling
  Future<void> getCurrentLocationAndFetchChefs() async {
    isLoadingLocation = true;
    update();

    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Location Services Disabled',style: TextStyle(color: Colors.black)),
            content: const Text(
              'Please enable location services to find nearby chefs.',style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(Get.context!),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(Get.context!);
                  await Geolocator.openLocationSettings();
                  await getCurrentLocationAndFetchChefs();
                },
                child: const Text(
                  'Enable',
                  style: TextStyle(color: Color(0xffFD713F)),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
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
          Get.dialog(
            AlertDialog(
              title: const Text('Permission Denied'),
              content: const Text(
                'Location permission is required to find nearby chefs. Please allow it to continue.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(Get.context!),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(Get.context!);
                    await getCurrentLocationAndFetchChefs();
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Color(0xffFD713F)),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
          isLoadingLocation = false;
          update();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.dialog(
          AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
              'Location permission is permanently denied. Please enable it in your device settings to find nearby chefs.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(Get.context!),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(Get.context!);
                  Geolocator.openAppSettings();
                },
                child: const Text(
                  'Open Settings',
                  style: TextStyle(color: Color(0xffFD713F)),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        isLoadingLocation = false;
        update();
        return;
      }

      // Permission granted — get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLng = position.longitude;

      // Reverse geocode to get human-readable address
      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;

          // Build address from available fields
          final List<String> addressParts = [
            place.street ?? '',
            place.subLocality ?? '',
            place.locality ?? '',
          ].where((part) => part.trim().isNotEmpty).toList();

          address = addressParts.join(', ');
        }
      } catch (e) {
        // Reverse geocoding failed — address will remain as profile address
        debugPrint('Reverse geocoding failed: $e');
      }

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
        //"user/nearby-chefs?lat=$currentLat&lng=$currentLng",
        'user/nearby-chefs?lat=$currentLat&lng=$currentLng',
        // I said"user/nearby-chefs",
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

  // Fetch order again list from API
  Future<void> getOrderAgain() async {
    isLoadingOrderAgain = true;
    update();

    try {
      final response = await ApiService.get('order/order-again-orders');

      if (response.statusCode == 200) {
        orderAgainModel = OrderAgainModel.fromJson(response.data);
        orderAgainList = orderAgainModel?.data ?? [];
        isLoadingOrderAgain = false;
        update();
      } else {
        isLoadingOrderAgain = false;
        update();
        Utils.errorSnackBar('Error', 'Failed to fetch order again list');
      }
    } catch (e) {
      isLoadingOrderAgain = false;
      update();
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Refresh chefs list
  Future<void> refreshChefs() async {
    await getCurrentLocationAndFetchChefs();
  }

  Future<void> getProfileData() async {
    try {
      final response = await ApiService.get('user/profile');
      if (response.statusCode == 200) {
        final data = response.data;
        final profileAddress = response.data['data']['address'] ?? '';

        // ✅ Only set address from profile if location address isn't set yet
        if (defaultAddress.value.isEmpty) {
          defaultAddress.value = profileAddress;
        }
        if (address.isEmpty) {
          address = response.data['data']['address'] ?? '';
          defaultAddress.value = response.data['data']['address'] ?? '';
        }

        LocalStorage.userId = data['data']?.id ?? '';
        await LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
        update();
      }
    } catch (e) {}
  }



  Future<void> getCusine() async {
    try {
      final response = await ApiService.get('cusine');
      if (response.statusCode == 200) {
        cuisineModel = CuisineModel.fromJson(response.data);
        cuisineList = cuisineModel?.data ?? [];
      }
    } catch (e) {}
  }

  void onChangeCuisine(String value) {
    if (selectCuisine.contains(value)) {
      selectCuisine.remove(value);
      update();
      return;
    }

    selectCuisine.add(value);
    update();
  }

  void onChangeLevel(String value) {
    if (selectLevel.contains(value)) {
      selectLevel.remove(value);
      update();
      return;
    }
    selectLevel.add(value);
    update();
  }

  void onChangeDietary(String value) {
    if (selectDietary.contains(value)) {
      selectDietary.remove(value);
      update();
      return;
    }

    selectDietary.add(value);
    update();
  }

  void onChangeSaved() {
    saved = !saved;
    update();
  }

  void onChangeValue(newValue) {
    values = newValue;
    update();
  }
}