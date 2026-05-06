import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:intl_phone_field/countries.dart';
import 'package:new_untitled/features/common/auth/sign%20up/presentation/widget/account_create_popup.dart';
import 'package:new_untitled/utils/helpers/other_helper.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/storage/storage_keys.dart';
import '../../../../../../services/storage/storage_services.dart';
import '../../../../../../utils/app_utils.dart';
import '../../../../../../utils/log/app_log.dart';
import '../screen/Cafe_Enable_AutoAccept_Screen.dart';
import '../screen/Cafe_Setup_Profile_Screen.dart';
import '../screen/Cafe_set_your_price_screen.dart';
import '../screen/Chef_add_menu_items_screen.dart';
import '../screen/cafe_set_availability.dart';

class SignUpChefController extends GetxController {
  bool isPopUpOpen = false;
  bool isLoading = false;
  bool isLoadingVerify = false;
  bool isCompleteProfile = false;

  Timer? _timer;
  int start = 0;
  String time = '';
  String? image;

  String tempAbout = '';
  String tempExperience = '';
  String? tempImagePath;

  TextEditingController firstNameController = TextEditingController(
    text: kDebugMode ? '' : '',
  );
  TextEditingController lastNameController = TextEditingController(
    text: kDebugMode ? '' : '',
  );
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? '' : '',
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

  List dietaryOption = [
    'Vegetarian', 'Vegan', 'Pescatarian', 'Gluten-free',
    'Dairy-free', 'Lactose-free', 'Nut-free', 'Soy-free',
    'Egg-free', 'Shellfish-free', 'Halal', 'Kosher',
  ];
  List selectDietary = [];

  List selectedOption = ['User', 'Consultant'];
  String selectRole = 'User';
  String countryCode = '+880';
  String signUpToken = '';

  static SignUpChefController get instance => Get.put(SignUpChefController());

  String get _onboardingEndpoint =>
      'user/onboarding/${LocalStorage.userId}';

  void onChangeDietary(value) {
    if (selectDietary.contains(value)) {
      selectDietary.remove(value);
    } else {
      selectDietary.add(value);
      dietaryController.text = selectDietary.join(', ');
    }
    update();
  }

  void onCountryChange(Country value) {
    countryCode = value.dialCode.toString();
  }

  void setSelectedRole(value) {
    selectRole = value;
    update();
  }

  Future<void> getProfileImage() async {
    image = await OtherHelper.openGallery();
    update();
  }

  Future<void> openGallery() async {
    image = await OtherHelper.openGallery();
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
        time = '$minutes:$seconds';
        update();
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> signUpUser(String role) async {
    isLoading = true;
    update();

    final response = await ApiService.post(
      ApiEndPoint.signUp,
      body: {'email': emailController.text, 'role': role},
    );

    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.chef_verify_user);
    } else if (response.statusCode == 400 &&
        response.data['suggestRoute'] == '/api/v1/auth/verify-email') {
    } else {
      Utils.errorSnackBar(response.statusCode.toString(), response.message);
    }

    isLoading = false;
    update();
  }

  Future<void> verifyOtpRepo() async {
    isLoadingVerify = true;
    update();

    final response = await ApiService.post(
      ApiEndPoint.verifyEmail,
      body: {
        'email': emailController.text,
        'oneTimeCode': int.parse(otpController.text),
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;

      final userId = data['data']?.toString() ?? '';
      LocalStorage.userId = userId;
      await LocalStorage.setString(LocalStorageKeys.userId, userId);

      final token = data['token'] ??
          data['accessToken'] ??
          (data['data'] is Map ? data['data']['accessToken'] : null) ?? '';

      if (token.toString().isNotEmpty) {
        await LocalStorage.setString(LocalStorageKeys.token, token.toString());
      } else {
      }
      Get.toNamed(AppRoutes.create_password_chef_screen);
    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }

    isLoadingVerify = false;
    update();
  }

  Future<void> chefSignUp() async {
    isLoading = true;
    update();
    try {
      final response = await ApiService.patch(
        _onboardingEndpoint,
        body: {
          'password': passwordController.text.trim(),
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final token = data['data']?['accessToken'] ??
            data['accessToken'] ??
            data['token'] ?? '';
        if (token.toString().isNotEmpty) {
          await LocalStorage.setString(LocalStorageKeys.token, token.toString());
        }

        if (data['success'] == true) {
        } else {
          Utils.errorSnackBar('Error', data['message'] ?? 'Something went wrong');
        }
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Request failed');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<String> _compressImage(String path) async {
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return path;

      final resized = img.copyResize(decoded, width: 800);
      final compressed = img.encodeJpg(resized, quality: 40);

      final newPath = '${path}_c.jpg';
      await File(newPath).writeAsBytes(compressed);
      return newPath;
    } catch (e) {
      return path;
    }
  }

  Future<void> submitChefVerification({
    required String? idCardFrontPath,
    required String? idCardBackPath,
    required String? proofOfAddressPath,
    required String? foodSafetyCertPath,
    required String? additionalCulinaryPath,
  }) async {
    isLoading = true;
    update();
    try {
      final List files = [];

      if (idCardFrontPath != null && idCardFrontPath.isNotEmpty) {
        files.add({'name': 'id_card_front', 'image': await _compressImage(idCardFrontPath)});
      }
      if (idCardBackPath != null && idCardBackPath.isNotEmpty) {
        files.add({'name': 'id_card_back', 'image': await _compressImage(idCardBackPath)});
      }
      if (proofOfAddressPath != null && proofOfAddressPath.isNotEmpty) {
        files.add({'name': 'proof_of_address', 'image': await _compressImage(proofOfAddressPath)});
      }
      if (foodSafetyCertPath != null && foodSafetyCertPath.isNotEmpty) {
        files.add({'name': 'food_safety_certificate', 'image': await _compressImage(foodSafetyCertPath)});
      }
      if (additionalCulinaryPath != null && additionalCulinaryPath.isNotEmpty) {
        files.add({'name': 'additional_culinary_licenses', 'image': await _compressImage(additionalCulinaryPath)});
      }
      if (image != null && image!.isNotEmpty) {

        files.add({'name': 'image', 'image': await _compressImage(image!)});

      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: {'role': 'CHEF'},
        files: files,
      );

      if (response.statusCode == 200) {

        if(LocalStorage.isLogIn == false){

          Get.to(() => const CafeSetupProfileScreen());

        }else if(LocalStorage.isLogIn == true){

          Get.offAllNamed(AppRoutes.chefHomeScreen);

        }else {

          Utils.errorSnackBar('message', response.data['message'] ?? 'Something is logically wrong.');

        }

      } else {
        Utils.errorSnackBar('message', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('message', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }



  Future<void> ChefProfileLocationUpdate({
    required String cookingAreaDistance,
    required String address,
    required String lat,
    required String lng,
    String? imagePath,
  }) async {
    isLoading = true;
    update();
    try {
      final List files = [];
      if (imagePath != null && imagePath.isNotEmpty) {
        files.add({'name': 'image', 'image': imagePath});
      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: {
          'cooking_area_distance': int.tryParse(cookingAreaDistance) ?? 0,
          'address': address,
          'lat': lat,
          'lng': lng,
        },
        files: files,
      );

      if (response.statusCode == 200) {

        Navigator.pop(Get.context!);

      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> setupChefProfile({
    required String about,
    required String experience,
    required String cookingAreaDistance,
    required String address,
    required String lat,
    required String lng,
    String? imagePath,
  }) async {
    isLoading = true;
    update();
    try {
      final List files = [];
      if (imagePath != null && imagePath.isNotEmpty) {
        files.add({'name': 'image', 'image': imagePath});
      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: {
          'about': about,
          'experience': int.tryParse(experience) ?? 0,
          'cooking_area_distance': int.tryParse(cookingAreaDistance) ?? 0,
          'address': address,
          'lat': lat,
          'lng': lng,
        },
        files: files,
      );

      if (response.statusCode == 200) {
        Get.to(() => const CafeSetYourPriceScreen());
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> setupChefPrice({
    required String pricing,
    required bool weekDaysDiscountHas,
    required Map<String, dynamic> weekDaysDiscount,
    required bool weekendDiscountHas,
    required String weekendDiscountAmount,
    required String minimumShortOrderHours,
  }) async {
    isLoading = true;
    update();
    try {
      final Map<String, dynamic> body = {
        'pricing': pricing,
        'role': 'CHEF',
        'week_days_discount_has': weekDaysDiscountHas.toString(),
        'weekend_discount_has': weekendDiscountHas.toString(),
        'weekend_discount_amount': weekendDiscountAmount,
        'minimum_short_order_hours': minimumShortOrderHours,
        'week_days_discount': jsonEncode(weekDaysDiscountHas && weekDaysDiscount.isNotEmpty
            ? {
          'start_time': weekDaysDiscount['from'] ?? '',
          'end_time': weekDaysDiscount['to'] ?? '',
          'amount': int.tryParse(weekDaysDiscount['amount']?.toString() ?? '0') ?? 0,
        }
            : {'start_time': '', 'end_time': '', 'amount': 0}),
      };

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: body,
        files: [],
      );

      if (response.statusCode == 200) {
        Get.to(() => const CafeSetAvailabilityScreen());
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> setupChefAvailability2({
    required List<DaySchedule> days,
  }) async {
    isLoading = true;
    update();
    try {

      final List<Map<String, dynamic>> availabilityList = days.map((day) {

        return {
          'day': day.name.toLowerCase(),
          'availability': day.isEnabled,
          'availability_times': day.isEnabled
              ? day.slots.map((slot) => {
            'start_time': _formatTime(slot.from),
            'end_time': _formatTime(slot.to),
          }).toList()
              : [],
        };

      }).toList();

      final response = await ApiService.multipartImage(
        ApiEndPoint.user,
        body: {
          'availability': jsonEncode(availabilityList),
        },
        files: [],
      );

      if (response.statusCode == 200) {

        if (Get.context != null) {
          Navigator.pop(Get.context!);
        }
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> setupChefAvailability({
    required List<DaySchedule> days,
  }) async {
    isLoading = true;
    update();
    try {
      final Map<String, dynamic> body = {};

      for (int i = 0; i < days.length; i++) {
        final day = days[i];
        body['availability[$i][day]'] = day.name.toLowerCase();
        body['availability[$i][availability]'] = day.isEnabled;

        if (day.isEnabled) {
          for (int j = 0; j < day.slots.length; j++) {
            final slot = day.slots[j];
            body['availability[$i][availability_times][$j][start_time]'] =
                _formatTime(slot.from);
            body['availability[$i][availability_times][$j][end_time]'] =
                _formatTime(slot.to);
          }
        }
      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: body,
        files: [],
      );

      if (response.statusCode == 200) {
        Get.to(() => const CafeEnableAutoAcceptScreen());
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> setupAutoAccept({required bool autoAccept}) async {
    isLoading = true;
    update();
    try {
      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: {'order_auto_accept': autoAccept.toString()},
        files: [],
      );

      if (response.statusCode == 200) {
        Get.to(() => const CafeAddMenuItemsScreen());
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> completeProfile() async {
    isCompleteProfile = true;
    update();
    try {
      final Map<String, dynamic> body = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'address': addressController.text,
        'password': passwordController.text,
        'contact': '$countryCode${numberController.text}',
      };

      for (int i = 0; i < selectDietary.length; i++) {
        body['foods[$i]'] = selectDietary[i];
      }

      final List files = [];
      if (image != null && image!.isNotEmpty) {
        files.add({'name': 'image', 'image': image});
      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        body: body,
        files: files,
      );

      if (response.statusCode == 200) {
        accountCreatePopup();
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isCompleteProfile = false;
      update();
    }
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "${h.toString().padLeft(2, '0')}:$m $p";
  }

  @override
  void dispose() {
    _timer?.cancel();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    numberController.dispose();
    addressController.dispose();
    dietaryController.dispose();
    otpController.dispose();
    super.dispose();
  }
}