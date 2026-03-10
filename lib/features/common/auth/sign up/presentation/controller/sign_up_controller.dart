import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:new_untitled/features/common/auth/sign%20up/presentation/widget/account_create_popup.dart';
import 'package:new_untitled/utils/helpers/other_helper.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/storage/storage_keys.dart';
import '../../../../../../services/storage/storage_services.dart';
import '../../../../../../utils/app_utils.dart';
import '../../../../../customer/address/repsozitory/address_repository.dart';

class SignUpController extends GetxController {
  bool isPopUpOpen = false;
  bool isLoading = false;
  bool isLoadingVerify = false;
  bool isCompleteProfile = false;

  Timer? _timer;
  int start = 0;

  String time = "";

  String? image;

  // ── Location ──────────────────────────────────────────────
  double selectedLat = 0;
  double selectedLng = 0;

  // ── Address Suggestions ───────────────────────────────────
  List<Map<String, dynamic>> addressSuggestions = [];
  bool isLoadingSuggestions = false;
  bool showAddressSuggestions = false;

  // ── Dietary ───────────────────────────────────────────────
  bool isLoadingDietary = false;
  List dietaryOption = [];
  List filteredDietaryOption = [];
  TextEditingController dietarySearchController = TextEditingController();

  getProfileImage() async {
    image = await OtherHelper.openGallery();
    update();
  }

  List selectedOption = ["User", "Consultant"];

  List selectDietary = [];

  /// Filter dietary list based on search query
  void onSearchDietary(String query) {
    if (query.trim().isEmpty) {
      filteredDietaryOption = List.from(dietaryOption);
    } else {
      filteredDietaryOption = dietaryOption
          .where((e) =>
          e.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  onChangeDietary(value) {
    if (selectDietary.contains(value)) {
      selectDietary.remove(value);
      update();
      return;
    }
    selectDietary.add(value);
    update();
    dietaryController.text = selectDietary.join(", ");
  }

  /// Fetch dietary options from API
  Future<void> fetchDietary() async {
    isLoadingDietary = true;
    update();
    try {
      var response = await ApiService.get("dietary"); // your dietary url
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        dietaryOption = data;
        filteredDietaryOption = List.from(dietaryOption);
      } else {
        Utils.errorSnackBar(
            response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    } finally {
      isLoadingDietary = false;
      update();
    }
  }

  String selectRole = "User";
  String countryCode = "+880";

  String signUpToken = '';

  static SignUpController get instance => Get.put(SignUpController());

  TextEditingController firstNameController = TextEditingController(
    text: kDebugMode ? "" : "",
  );
  TextEditingController lastNameController = TextEditingController(
    text: kDebugMode ? "" : "",
  );
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "" : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? '' : '',
  );
  TextEditingController confirmPasswordController = TextEditingController(
    text: kDebugMode ? '' : '',
  );
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dietaryController = TextEditingController();
  TextEditingController otpController = TextEditingController(
    text: kDebugMode ? '' : '',
  );

  @override
  void onInit() {
    super.onInit();
    _listenAddressField();
    fetchDietary(); // ✅ fetch dietary from API on init
  }

  @override
  void dispose() {
    _timer?.cancel();
    dietarySearchController.dispose();
    super.dispose();
  }

  // ── Address listener ──────────────────────────────────────
  void _listenAddressField() {
    addressController.addListener(() {
      final q = addressController.text.trim();
      if (q.length >= 2) {
        _fetchAddressSuggestions(q);
      } else {
        addressSuggestions.clear();
        showAddressSuggestions = false;
        update();
      }
    });
  }

  Future<void> _fetchAddressSuggestions(String query) async {
    isLoadingSuggestions = true;
    showAddressSuggestions = true;
    update();
    try {
      addressSuggestions =
      await AddressRepository.getPlaceSuggestions(query);
    } catch (_) {
      addressSuggestions = [];
    } finally {
      isLoadingSuggestions = false;
      update();
    }
  }

  /// User taps a suggestion — fills addressController with 3-part address
  Future<void> onAddressSuggestionSelected(
      Map<String, dynamic> suggestion) async {
    final main = (suggestion['main_text'] ?? '').toString().trim();
    final secondary =
    (suggestion['secondary_text'] ?? '').toString().trim();

    final parts = secondary
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    List<String> result = [];
    if (main.isNotEmpty) result.add(main);
    for (final p in parts) {
      if (result.length >= 3) break;
      if (!result.contains(p)) result.add(p);
    }

    // Fill single address field with 3-part text
    addressController.text = result.join(', ');
    addressSuggestions.clear();
    showAddressSuggestions = false;
    update();

    // ✅ Fetch real lat/lng from place detail
    try {
      final placeId = suggestion['place_id'] as String?;
      if (placeId != null) {
        final detail = await AddressRepository.getPlaceDetail(placeId);
        if (detail != null) {
          selectedLat = detail['lat'] ?? 0;
          selectedLng = detail['lng'] ?? 0;
          update();
        }
      }
    } catch (_) {}
  }

  onCountryChange(PhoneNumber value) {
    countryCode = value.countryCode.toString();
  }

  setSelectedRole(value) {
    selectRole = value;
    update();
  }

  openGallery() async {
    image = await OtherHelper.openGallery();
    update();
  }

  signUpUser(String role) async {
    isLoading = true;
    update();
    Map<String, String> body = {
      "email": emailController.text,
      "role": role,
    };

    var response =
    await ApiService.post(ApiEndPoint.signUp, body: body);

    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.verifyUser);
    } else if (response.statusCode == 400 &&
        response.data["suggestRoute"] == "/api/v1/auth/verify-email") {
      Get.toNamed(AppRoutes.verifyUser);
    } else {
      Utils.errorSnackBar(
          response.statusCode.toString(), response.message);
    }
    isLoading = false;
    update();
  }

  void startTimer() {
    _timer?.cancel();
    start = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start > 0) {
        start--;
        final minutes = (start ~/ 60).toString().padLeft(2, '0');
        final seconds = (start % 60).toString().padLeft(2, '0');
        time = "$minutes:$seconds";
        update();
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> verifyOtpRepo() async {
    isLoadingVerify = true;
    update();
    Map<String, dynamic> body = {
      "email": emailController.text,
      "oneTimeCode": int.parse(otpController.text),
    };
    var response = await ApiService.post(
      ApiEndPoint.verifyEmail,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = response.data;
      LocalStorage.userId = await data["data"];
      await LocalStorage.setString(
          LocalStorageKeys.userId, LocalStorage.userId);
      Get.toNamed(AppRoutes.createSignUpPassword);
    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }

    isLoadingVerify = false;
    update();
  }

  completeProfile() async {
    isCompleteProfile = true;
    update();
    try {
      Map<String, dynamic> body = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "address": addressController.text,
        "password": passwordController.text,
        "lat": selectedLat.toString(),
        "lng": selectedLng.toString(),
        "contact": "$countryCode ${numberController.text}",
      };
      for (int i = 0; i < selectDietary.length; i++) {
        body["foods[$i]"] = selectDietary[i];
      }
      List files = [];
      if (image != null && image!.isNotEmpty) {
        files.add({"name": "image", "image": image});
      }

      var response = await ApiService.multipartImage(
        "user/onboarding/${LocalStorage.userId}",
        body: body,
        files: files,
      );
      if (response.statusCode == 200) {
        final data=response.data;
        LocalStorage.token = data['data']["accessToken"];
        LocalStorage.userId = data['data']["userId"];
        LocalStorage.myRole = data["data"]["role"];
        LocalStorage.isLogIn = true;

        await LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
        await LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);
        await LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
        await LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
        accountCreatePopup();
      } else {
        Utils.errorSnackBar(
            response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    }
  }
}