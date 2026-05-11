import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/helpers/other_helper.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';
import '../../../home/presentation/controller/chef_home_controller.dart';

class ChefProfileController extends GetxController {

  /// Language List
  List languages = ['English', 'French', 'Arabic'];

  List<Map<String, dynamic>> profileOptions = [
    {'name': 'Chef', 'image': AppIcons.chefIcon},
    {'name': 'Customers', 'image': AppIcons.customers},
  ];

  RxBool isNotification = false.obs;

  void loadProfile(data) {
    isNotification.value = data['notification_enabled'] ?? false;
  }

  Future<void> notification() async {
    final bool newValue = !isNotification.value;
    isNotification.value = newValue;

    final response = await ApiService.patch(
      ApiEndPoint.chefProfile,
      body: {
        'notification_enabled': newValue.toString(),
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      await Get.find<ChefHomeController>().fetchChefProfile();
      Get.snackbar('Message', 'Notification setting updated',
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      isNotification.value = !newValue; // revert on failure
      Utils.errorSnackBar('Error', 'Failed to update notification setting');
    }
  }

  final RxList<CuisineModel> allCuisines = <CuisineModel>[].obs;
  final RxList<String> selectedCuisineIds = <String>[].obs;

  List<String> get selectedCuisineNames => allCuisines
      .where((c) => selectedCuisineIds.contains(c.id))
      .map((c) => c.name)
      .toList();

  Future<void> fetchCuisines() async {
    final response = await ApiService.get(ApiEndPoint.getCuisines);
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      allCuisines.value = data.map((e) => CuisineModel.fromJson(e)).toList();
    }
  }

  void toggleCuisine(String id) {
    if (selectedCuisineIds.contains(id)) {
      selectedCuisineIds.remove(id);
    } else {
      selectedCuisineIds.add(id);
    }
  }

  List<String> expertiseInCooking = [
    'Chinese', 'Italian', 'American', 'Indian', 'Japanese',
  ];

  TextEditingController selectExpertiseController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController pricingController = TextEditingController();
  TextEditingController distanceController = TextEditingController(text: '10');
  TextEditingController minBookingController = TextEditingController(text: '1.0');
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController weekdayRateController = TextEditingController();
  TextEditingController weekendRateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  double? selectedLat;
  double? selectedLng;

  List<Map<String, String>> addressSuggestions = [];
  bool isSearchingAddress = false;

  bool isDiscount = false;
  bool isWeekend = false;
  bool isAutoAccept = false;

  String selectedLanguage = 'English';
  Map<String, dynamic> selectedProfile = {
    'name': 'Customers',
    'image': AppIcons.customers,
  };

  String selectedCountryCode = '+1';
  String? image;
  bool isLoading = false;
  bool isLoadingUpdate = false;

  @override
  void onInit() {
    super.onInit();
    if (LocalStorage.userId.isEmpty) {
      LocalStorage.getAllPrefData().then((_) => update());
    }
  }

  void loadProfileData() {
    final profile = Get.find<ChefHomeController>().chefProfile.value;
    if (profile == null) return;

    final rawName = profile.originalName.isNotEmpty
        ? profile.originalName
        : profile.name;

    final nameParts = rawName.trim().split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameController.text =
    nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    aboutController.text = profile.about;
    experienceController.text = profile.experience.toString();
    pricingController.text = profile.pricing.toString();
    addressController.text = profile.address;
    distanceController.text = profile.cookingAreaDistance.toString();

    emailController.text = profile.email.isNotEmpty
        ? profile.email
        : LocalStorage.myEmail;

    isAutoAccept = profile.orderAutoAccept;
    isDiscount = profile.weekDaysDiscountHas;
    isWeekend = profile.weekendDiscountHas;
    weekendRateController.text = profile.weekendDiscountAmount.toString();

    selectedCuisineIds.value = List<String>.from(profile.foods);

    update();
  }

  Future<void> updateContactInfo() async {
    isLoadingUpdate = true;
    update();

    try {
      final Map<String, dynamic> body = {
        'email': emailController.text.trim(),
        'contact': '$selectedCountryCode${phoneController.text.trim()}',
      };

      final response = await ApiService.patch(
        ApiEndPoint.user,
        body: body,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('Success', 'Profile updated successfully');
        Get.find<ChefHomeController>().fetchChefProfile();
        Get.toNamed(AppRoutes.chefProfile);
      } else {
        Get.snackbar('Error',
            response.data['message']?.toString() ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoadingUpdate = false;
      update();
    }
  }

  static const String _placesApiKey = 'AIzaSyCVoe2GBYsk1jU6E9RFIxhVfsyBCSkMX_w';

  Future<void> fetchAddressSuggestions(String query) async {
    if (query.trim().isEmpty) {
      addressSuggestions = [];
      update();
      return;
    }
    isSearchingAddress = true;
    update();

    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
            '?input=${Uri.encodeComponent(query)}'
            '&key=$_placesApiKey',
      );
      final res = await GetConnect().get(uri.toString());
      if (res.statusCode == 200 && res.body['status'] == 'OK') {
        final predictions = res.body['predictions'] as List;
        addressSuggestions =
            predictions.map<Map<String, String>>((p) {
              final terms = p['terms'] as List? ?? [];
              final title = terms.isNotEmpty
                  ? terms[0]['value'].toString()
                  : p['description'].toString();
              return {
                'title': title,
                'sub': p['description'].toString(),
                'placeId': p['place_id'].toString(),
              };
            }).toList();
      } else {
        addressSuggestions = [];
      }
    } catch (_) {
      addressSuggestions = [];
    } finally {
      isSearchingAddress = false;
      update();
    }
  }

  Future<void> selectAddress(Map<String, String> item) async {
    addressController.text = item['sub'] ?? '';
    addressSuggestions = [];
    isSearchingAddress = true;
    update();

    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
            "?place_id=${item['placeId']}"
            '&fields=geometry'
            '&key=$_placesApiKey',
      );
      final res = await GetConnect().get(uri.toString());
      if (res.statusCode == 200 && res.body['status'] == 'OK') {
        final loc = res.body['result']['geometry']['location'];
        selectedLat = (loc['lat'] as num).toDouble();
        selectedLng = (loc['lng'] as num).toDouble();
      }
    } catch (_) {
      selectedLat = null;
      selectedLng = null;
    } finally {
      isSearchingAddress = false;
      update();
    }
  }

  void clearAddressSuggestions() {
    addressSuggestions = [];
    update();
  }

  void onChangeProfile(int index) {
    selectedProfile = profileOptions[index];
    update();
    Navigator.pop(Get.context!);
  }

  void onTap(int value) {
    selectExpertiseController.text = expertiseInCooking[value];
    update();
    Navigator.pop(Get.context!);
  }

  void onChangeDiscount(v) {
    isDiscount = !isDiscount;
    update();
  }

  void weekendToggle() {
    isWeekend = !isWeekend;
    update();
  }

  void autoAcceptToggle() {
    isAutoAccept = !isAutoAccept;
    update();
  }

  void selectLanguage(int index) {
    selectedLanguage = languages[index];
    update();
    Navigator.pop(Get.context!);
  }

  Future<void> getProfileImage() async {
    image = await OtherHelper.openGalleryForProfile();
    update();
  }

  String _getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';
      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      return map['id']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> editProfileRepo(GlobalKey<FormState> formKey) async {
    isLoading = true;
    update();

    try {
      await LocalStorage.getAllPrefData();

      String userId = LocalStorage.userId;
      if (userId.isEmpty && LocalStorage.token.isNotEmpty) {
        userId = _getUserIdFromToken(LocalStorage.token);
        if (userId.isNotEmpty) {
          LocalStorage.userId = userId;
          await LocalStorage.setString('userId', userId);
        }
      }

      if (userId.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.errorSnackBar('Error', 'User not logged in. Please login again.');
        });
        isLoading = false;
        update();
        return;
      }

      final String fullName =
      '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim();

      final Map<String, dynamic> body = {
        'role': 'CHEF',
        'name': fullName,
        'phone': numberController.text.trim(),
        if (selectedLat != null) 'lat': selectedLat.toString(),
        if (selectedLng != null) 'lng': selectedLng.toString(),
        'about': aboutController.text.trim(),
        'experience': experienceController.text.trim().replaceAll(',', ''),
        'pricing': pricingController.text.trim(),
        'cooking_area_distance': distanceController.text.trim(),
        'minimum_booking_duration': minBookingController.text.trim(),
        'auto_accept': isAutoAccept.toString(),
        'week_days_discount_has': isDiscount.toString(),
        'week_days_discount_from': fromController.text.trim(),
        'week_days_discount_to': toController.text.trim(),
        'week_days_discount_rate': weekdayRateController.text.trim(),
        'weekend_discount_has': isWeekend.toString(),
        'weekend_discount_rate': weekendRateController.text.trim(),
        'foods': selectedCuisineIds.join(','),
      };

      final List files = [];
      if (image != null && image!.isNotEmpty) {
        files.add({'name': 'image', 'image': image});
      }

      final response = await ApiService.multipartImage(
        '/user/profile',
        body: body,
        files: files,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        LocalStorage.userId = data['data']?['_id'] ?? '';
        LocalStorage.myImage = data['data']?['image'] ?? '';
        LocalStorage.myName = data['data']?['fullName'] ?? '';
        LocalStorage.myEmail = data['data']?['email'] ?? '';
        LocalStorage.setString('userId', LocalStorage.userId);
        LocalStorage.setString('myImage', LocalStorage.myImage);
        LocalStorage.setString('myName', LocalStorage.myName);
        LocalStorage.setString('myEmail', LocalStorage.myEmail);

        await Get.find<ChefHomeController>().fetchChefProfile();
        update();

        Get.toNamed(AppRoutes.chefHomeScreen, arguments: {'index': 4});

        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.context != null) {

            Get.snackbar('Success', 'Profile updated successfully',backgroundColor: Colors.green,colorText: Colors.white);
          }
        });
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    selectExpertiseController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    numberController.dispose();
    addressController.dispose();
    aboutController.dispose();
    experienceController.dispose();
    pricingController.dispose();
    distanceController.dispose();
    minBookingController.dispose();
    fromController.dispose();
    toController.dispose();
    weekdayRateController.dispose();
    weekendRateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

class CuisineModel {
  final String id;
  final String name;
  final String image;

  CuisineModel({required this.id, required this.name, required this.image});

  factory CuisineModel.fromJson(Map<String, dynamic> json) => CuisineModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}