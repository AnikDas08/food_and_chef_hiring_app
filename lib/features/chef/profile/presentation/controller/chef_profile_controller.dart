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
  List languages = ["English", "French", "Arabic"];

  List<Map<String, dynamic>> profileOptions = [
    {"name": "Chef", "image": AppIcons.chefIcon},
    {"name": "Customers", "image": AppIcons.customers},
  ];

  RxBool isNotification = false.obs;

  void loadProfile(data) {
    isNotification.value = data['notification_enabled'] ?? false;
  }

  Future<void> notification() async {
    bool newValue = !isNotification.value;
    isNotification.value = newValue;

    var response = await ApiService.patch(
      ApiEndPoint.chefProfile,
      body: {
        "notification_enabled": newValue.toString(),
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      Get.snackbar("Message", "notification setting updated",backgroundColor: Colors.green,colorText: Colors.white);
    } else {
      isNotification.value = !newValue;
      Utils.errorSnackBar("Error", "Failed to update notification setting");
    }
  }

  /// Cuisine Options
  final List<String> cuisineOptions = [
    'Chinese', 'Italian', 'American', 'Indian', 'Japanese',
    'Mexican', 'Thai', 'French', 'Mediterranean',
  ];
  List<String> selectedCuisines = [];

  /// Expertise Options
  List<String> expertiseInCooking = [
    "Chinese", "Italian", "American", "Indian", "Japanese",
  ];

  /// Text Controllers
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

  /// Location Data
  double? selectedLat;
  double? selectedLng;

  /// Address Autocomplete
  List<Map<String, String>> addressSuggestions = [];
  bool isSearchingAddress = false;

  /// Toggles
  bool isDiscount = false;
  bool isWeekend = false;
  bool isAutoAccept = false;

  /// Language & Profile
  String selectedLanguage = "English";
  Map<String, dynamic> selectedProfile = {
    "name": "Customers",
    "image": AppIcons.customers,
  };

  /// Image & Loading
  String? image;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    if (LocalStorage.userId.isEmpty) {
      LocalStorage.getAllPrefData().then((_) => update());
    }
  }

  bool isLoadingUpdate = false;

  Future<void> updateContactInfo() async {
    isLoadingUpdate = true;
    update();

    try {

      final Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "contact": phoneController.text.trim(),
      };

      final response = await ApiService.patch(
        ApiEndPoint.user,
        body: body,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar("Success", "Profile updated successfully");
        Get.find<ChefHomeController>().fetchChefProfile();
        Get.toNamed(AppRoutes.chefProfile);
      } else {
        Get.snackbar("Error", response.data?['message']?.toString() ?? "Something went wrong");
      }
    } catch (e) {
      debugPrint("Update profile error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoadingUpdate = false;
      update();
    }
  }

  static const String _placesApiKey = "AIzaSyCVoe2GBYsk1jU6E9RFIxhVfsyBCSkMX_w";

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
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
            "?input=${Uri.encodeComponent(query)}"
            "&key=$_placesApiKey",
      );
      final res = await GetConnect().get(uri.toString());
      if (res.statusCode == 200 && res.body['status'] == 'OK') {
        final predictions = res.body['predictions'] as List;
        addressSuggestions = predictions.map<Map<String, String>>((p) {
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
        "https://maps.googleapis.com/maps/api/place/details/json"
            "?place_id=${item['placeId']}"
            "&fields=geometry"
            "&key=$_placesApiKey",
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
    Get.back();
  }

  void onTap(int value) {
    selectExpertiseController.text = expertiseInCooking[value];
    update();
    Get.back();
  }

  void toggleCuisine(String cuisine) {
    if (selectedCuisines.contains(cuisine)) {
      selectedCuisines.remove(cuisine);
    } else {
      selectedCuisines.add(cuisine);
    }
    update();
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
    Get.back();
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
      while (payload.length % 4 != 0) payload += '=';
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      return map['id']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  void loadProfileData() {
    final profile = Get.find<ChefHomeController>().chefProfile.value;
    if (profile == null) return;

    final nameParts = profile.name.split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameController.text = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    aboutController.text = profile.about;
    experienceController.text = profile.experience.toString();
    pricingController.text = profile.pricing.toString();
    addressController.text = profile.address;
    distanceController.text = profile.cookingAreaDistance.toString();



    isAutoAccept = profile.orderAutoAccept;
    isDiscount = profile.weekDaysDiscountHas;

    isWeekend = profile.weekendDiscountHas;
    weekendRateController.text = profile.weekendDiscountAmount.toString();

    selectedCuisines = List<String>.from(profile.foods);

    update();
  }


  Future<void> editProfileRepo(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    if (!LocalStorage.isLogIn) return;


    if (selectedLat == null || selectedLng == null) {
      Utils.errorSnackBar("Error", "Please select a valid address from the suggestions");
      return;
    }

    isLoading = true;
    update();

    try {
      await LocalStorage.getAllPrefData();

      String userId = LocalStorage.userId;
      if (userId.isEmpty && LocalStorage.token.isNotEmpty) {
        userId = _getUserIdFromToken(LocalStorage.token);
        if (userId.isNotEmpty) {
          LocalStorage.userId = userId;
          await LocalStorage.setString("userId", userId);
        }
      }

      if (userId.isEmpty) {
        Utils.errorSnackBar("Error", "User not logged in. Please login again.");
        isLoading = false;
        update();
        return;
      }
      final Map<String, dynamic> body = {
        "role": "CHEF","first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "phone": numberController.text.trim(),
        "address": addressController.text.trim(),
        "lat": selectedLat.toString(),
        "lng": selectedLng.toString(),
        "about": aboutController.text.trim(),
        "experience": experienceController.text.trim().replaceAll(",", ""),
        "pricing": pricingController.text.trim(),
        "cooking_area_distance": distanceController.text.trim(),
        "minimum_booking_duration": minBookingController.text.trim(),
        "auto_accept": isAutoAccept.toString(),
        "week_days_discount_has": isDiscount.toString(),
        "week_days_discount_from": fromController.text.trim(),
        "week_days_discount_to": toController.text.trim(),
        "week_days_discount_rate": weekdayRateController.text.trim(),
        "weekend_discount_has": isWeekend.toString(),
        "weekend_discount_rate": weekendRateController.text.trim(),
        "foods": selectedCuisines.join(','),
      };

      final List files = [];
      if (image != null && image!.isNotEmpty) {
        files.add({"name": "image", "image": image});
      }

      final response = await ApiService.multipartImage(
        "user/onboarding/$userId",
        method: "PATCH",
        body: body,
        files: files,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        LocalStorage.userId = data['data']?["_id"] ?? "";
        LocalStorage.myImage = data['data']?["image"] ?? "";
        LocalStorage.myName = data['data']?["fullName"] ?? "";
        LocalStorage.myEmail = data['data']?["email"] ?? "";
        LocalStorage.setString("userId", LocalStorage.userId);
        LocalStorage.setString("myImage", LocalStorage.myImage);
        LocalStorage.setString("myName", LocalStorage.myName);
        LocalStorage.setString("myEmail", LocalStorage.myEmail);
        Utils.successSnackBar("Success", "Profile updated successfully");

        await Get.find<ChefHomeController>().fetchChefProfile();
        update();


        Get.toNamed(AppRoutes.chefHomeScreen, arguments: {"index": 4});
      } else {
        Utils.errorSnackBar("Error", response.data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
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