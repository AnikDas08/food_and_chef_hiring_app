import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:new_untitled/component/text/common_text.dart';
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
  final deletePasswordController = TextEditingController();

  /// --- Rx State Variables ---
  RxString imagePath = "".obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString profileImage = "".obs;
  RxList linkAccounts = [].obs;
  RxBool isLoading = false.obs;
  RxBool isDeleteLoading = false.obs;
  RxBool isKitchen = false.obs;

  // ✅ Make savedCountryIsoCode reactive so UI rebuilds when profile loads
  RxString savedCountryIsoCode = "US".obs;

  String selectedLanguage = "English";
  Map<String, dynamic> selectedProfile = {
    "name": "Customers",
    "image": AppIcons.customers
  };

  String savedCountryCode = "+1";
  String fullPhoneNumber = "";

  /// --- Controllers ---
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Convenience getter for image nullable string
  String? get image => imagePath.value.isEmpty ? null : imagePath.value;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  /// 1. Fetch User Profile Data
  getProfile() async {
    try {
      final response = await ApiService.get("user/profile");

      if (response.statusCode == 200) {
        final data = response.data['data'];

        if (data != null) {
          name.value = data["orginal_name"] ?? "";
          email.value = data["email"] ?? "";
          profileImage.value = data["image"] ?? "";
          linkAccounts.value = data["link_accounts"] ?? [];
          isKitchen.value = data["is_kitchen_has"] ?? false;
          print("Profile image: ${ApiEndPoint.imageUrl + profileImage.value}");

          nameController.text = name.value;
          addressController.text = data["address"] ?? "";

          String existingPhone = data["contact"] ?? "";
          fullPhoneNumber = existingPhone;

          if (existingPhone.contains(" ")) {
            List<String> parts = existingPhone.split(" ");

            // ✅ parts[0] = "+1", parts[1..] = the number
            savedCountryCode = parts[0];
            numberController.text = parts.sublist(1).join(" ");

            // ✅ Strip "+" and find matching ISO code from dial code
            String cleanCode = parts[0].replaceAll("+", "");
            try {
              savedCountryIsoCode.value = countries
                  .firstWhere(
                    (c) => c.dialCode == cleanCode,
                orElse: () => countries.firstWhere((c) => c.code == "US"),
              )
                  .code;
            } catch (e) {
              savedCountryIsoCode.value = "US";
            }
          } else {
            // No space found — treat entire string as number, default to US
            numberController.text = existingPhone;
            savedCountryIsoCode.value = "US";
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  void onCountryChanged(Country country) {
    savedCountryCode = "${country.dialCode}";
    savedCountryIsoCode.value = country.code;

    // ✅ Rebuild fullPhoneNumber with new country code + existing number
    String currentNumber = numberController.text.trim();
    fullPhoneNumber = "${country.dialCode} $currentNumber";
  }

  /// 2. Handle International Phone Changes
  void onPhoneChanged(PhoneNumber phone) {
    String complete = phone.completeNumber;
    String number = phone.number;
    String code = complete.replaceAll(number, "");
    String countryCode = phone.countryCode;

    savedCountryCode = code;
    savedCountryIsoCode.value = phone.countryISOCode; // ✅ Update reactive ISO code on manual change
    fullPhoneNumber = "$countryCode $number";
  }

  /// 3. Select Image from Gallery
  Future<void> getProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  /// 4. Update Profile (PATCH Method with Multipart)
  Future<void> editProfileRepo() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) return;
    if (!LocalStorage.isLogIn) return;

    isLoading.value = true;

    Map<String, dynamic> body = {
      "name": nameController.text.trim(),
      "contact": fullPhoneNumber,
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

        // Update Rx values so UI reflects immediately
        name.value = LocalStorage.myName;
        email.value = LocalStorage.myEmail;
        profileImage.value = LocalStorage.myImage;

        LocalStorage.setString("userId", LocalStorage.userId);
        LocalStorage.setString("myImage", LocalStorage.myImage);
        LocalStorage.setString("myName", LocalStorage.myName);
        LocalStorage.setString("myEmail", LocalStorage.myEmail);
        Get.offAllNamed(AppRoutes.customerHomeScreen, arguments: {"index": 4});
        Utils.successSnackBar("Success", "Profile Updated Successfully");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      debugPrint("Multipart Error: $e");
      Utils.errorSnackBar("Error", "Something went wrong while uploading");
    }

    isLoading.value = false;
  }

  /// 5. Show Delete Account Popup
  void showDeleteAccountPopup() {
    deletePasswordController.clear();
    Get.dialog(
      _DeleteAccountDialog(controller: this),
      barrierDismissible: false,
    );
  }

  /// 6. Delete Account API
  Future<void> deleteAccount() async {
    final password = deletePasswordController.text.trim();
    if (password.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter your password");
      return;
    }

    isDeleteLoading.value = true;

    try {
      var response = await ApiService.delete(
        "user/account-delete",
        body: {"password": password},
      );

      if (response.statusCode == 200) {
        Navigator.of(Get.context!).pop();
        Utils.successSnackBar("Success", "Account deleted successfully");

        // Clear local storage and navigate to login
        await LocalStorage.removeAllPrefData();
        Get.offAllNamed(AppRoutes.signIn);
      } else {
        Utils.errorSnackBar(
          response.statusCode,
          response.message ?? "Incorrect password or request failed",
        );
      }
    } catch (e) {
      debugPrint("Delete Account Error: $e");
      Utils.errorSnackBar("Error", "Something went wrong. Please try again.");
    }

    isDeleteLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    numberController.dispose();
    addressController.dispose();
    deletePasswordController.dispose();
    super.onClose();
  }
}

/// ── Delete Account Dialog Widget ──────────────────────────────────────────────
class _DeleteAccountDialog extends StatelessWidget {
  final ProfileController controller;
  const _DeleteAccountDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big title
            /*const Text(
              "Delete Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xffFF0000),
              ),
            ),*/
            CommonText(
                text: "Delete Account",
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xffFF0000),
            ),
            const SizedBox(height: 12),

            // Warning text
            /*const Text(
              "Are you sure you want to delete your account? This action is permanent and cannot be undone.\n\nTo confirm, please enter your password below.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff555555),
                height: 1.5,
              ),
            ),*/
            CommonText(
              text: "Are you sure you want to delete your account? This action is permanent and cannot be undone.\n\nTo confirm, please enter your password below.",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              maxLines: 4,
              color: Color(0xff555555),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),

            // Password field
            TextField(
              controller: controller.deletePasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Enter your password",
                labelStyle: const TextStyle(color: Color(0xff777777)),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff777777)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xffDDDDDD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xffDDDDDD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xffFF0000), width: 1.5),
                ),
                filled: true,
                fillColor: const Color(0xffF9F9F9),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Obx(() => Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.isDeleteLoading.value
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xffDDDDDD)),
                    ),
                    child: /*const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff444444),
                      ),
                    ),*/
                    CommonText(
                        text: "Cancel",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff444444),
                    )
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm Delete
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isDeleteLoading.value
                        ? null
                        : controller.deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF0000),
                      disabledBackgroundColor: const Color(0xffFF6666),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isDeleteLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : /*const Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),*/
                    CommonText(
                        text: "Confirm",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}