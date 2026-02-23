import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';

class ProfileController extends GetxController {
  /// --- Language & Profile Options ---
  List languages = ["English", "French", "Arabic"];
  List<Map<String, dynamic>> profileOptions = [
    {"name": "Chef", "image": AppIcons.chefIcon},
    {"name": "Customers", "image": AppIcons.customers},
  ];

  final formKey = GlobalKey<FormState>();

  /// --- State Variables ---
  String selectedLanguage = "English";
  Map<String, dynamic> selectedProfile = {"name": "Customers", "image": AppIcons.customers};

  String? image;           // Stores local file path for preview
  String name = "";        // User name from API
  String email = "";       // User email from API
  String profileImage = "";  // Network image URL from API
  List linkAccounts = [];  // Dynamic list for linked social accounts
  bool isLoading = false;

  String savedCountryCode = "+880";     // e.g., +880
  String savedCountryIsoCode = "BD";    // e.g., BD

  /// International Phone Logic
  String fullPhoneNumber = "";

  /// --- Controllers ---
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  /// 1. Fetch User Profile Data
  getProfile() async {
    try {
      final response = await ApiService.get("user/profile");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        if (data != null) {
          name = data["name"] ?? "";
          email = data["email"] ?? "";
          profileImage = data["image"] ?? "";
          linkAccounts = data["link_accounts"] ?? [];

          nameController.text = name;
          addressController.text = data["address"] ?? "";

          // ✅ Split stored contact into countryCode and number
          String existingPhone = data["contact"] ?? "";
          fullPhoneNumber = existingPhone;

          if (existingPhone.contains(" ")) {
            List<String> parts = existingPhone.split(" ");
            savedCountryCode = parts[0];       // e.g., +880
            numberController.text = parts[1];  // e.g., 1712345678

            // ✅ Lookup ISO code from intl_phone_field countries list
            String cleanCode = parts[0].replaceAll("+", "");
            try {
              savedCountryIsoCode = countries
                  .firstWhere(
                    (c) => c.dialCode == cleanCode,
                orElse: () => countries.firstWhere((c) => c.code == "BD"),
              )
                  .code;
            } catch (e) {
              savedCountryIsoCode = "BD";
            }
          } else {
            numberController.text = existingPhone;
            savedCountryIsoCode = "BD";
          }

          update();
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  /// 2. Handle International Phone Changes
  void onPhoneChanged(PhoneNumber phone) {
    String complete = phone.completeNumber;  // e.g., +8801712345678
    String number = phone.number;            // e.g., 1712345678
    String code = complete.replaceAll(number, ""); // e.g., +880
    String countryCode=phone.countryCode;

    savedCountryCode = code;
    savedCountryIsoCode = phone.countryISOCode; // ✅ Save ISO directly e.g., "BD"
    fullPhoneNumber = "$countryCode $number";           // ✅ e.g., +880 1712345678

    update();
  }

  /// 3. Select Image from Gallery
  Future<void> getProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (pickedFile != null) {
      image = pickedFile.path;
      update();
    }
  }

  /// 4. Update Profile (PATCH Method with Multipart)
  Future<void> editProfileRepo() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) return;

    if (!LocalStorage.isLogIn) return;

    isLoading = true;
    update();

    Map<String, dynamic> body = {
      "name": nameController.text.trim(),
      "contact": fullPhoneNumber, // e.g., +880 1712345678
    };

    List files = [];
    if (image != null && image!.isNotEmpty) {
      files.add({"name": "image", "image": image});
    }

    try {
      var response = await ApiService.multipartImage(
        ApiEndPoint.user,
        method: "PATCH",
        body: body,
        files: files,
      );

      if (response.statusCode == 200) {
        var data = response.data['data'];

        LocalStorage.userId = data?["_id"] ?? "";
        LocalStorage.myImage = data?["image"] ?? "";
        LocalStorage.myName = data?["name"] ?? "";
        LocalStorage.myEmail = data?["email"] ?? "";

        LocalStorage.setString("userId", LocalStorage.userId);
        LocalStorage.setString("myImage", LocalStorage.myImage);
        LocalStorage.setString("myName", LocalStorage.myName);
        LocalStorage.setString("myEmail", LocalStorage.myEmail);

        Utils.successSnackBar("Success", "Profile Updated Successfully");
        Get.offAllNamed(AppRoutes.customerHomeScreen, arguments: {"index": 4});
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      debugPrint("Multipart Error: $e");
      Utils.errorSnackBar("Error", "Something went wrong while uploading");
    }

    isLoading = false;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    numberController.dispose();
    addressController.dispose();
    super.onClose();
  }
}