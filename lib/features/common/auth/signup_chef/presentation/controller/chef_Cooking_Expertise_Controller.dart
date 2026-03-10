import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/storage/storage_keys.dart';
import '../../../../../../services/storage/storage_services.dart';
import 'package:flutter/material.dart';

class CuisineModel {
  final String id;
  final String name;
  final String image;

  CuisineModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) => CuisineModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}

class CafeCookingExpertiseController extends GetxController {
  final RxList<CuisineModel> allCuisines = <CuisineModel>[].obs;
  final RxList<String> selectedIds = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool dropdownOpen = false.obs;

  // SignUpChefController এর মতো dynamic endpoint
  String get _onboardingEndpoint => "user/onboarding/${LocalStorage.userId}";

  @override
  void onInit() {
    super.onInit();
    fetchCuisines();
  }

  Future<void> fetchCuisines() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndPoint.cuisine);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List list = data['data'] ?? [];
          allCuisines.value =
              list.map((e) => CuisineModel.fromJson(e)).toList();
        } else {
          Get.snackbar("Message", data['message'] ?? "Failed to load cuisines");
        }
      } else {
        Get.snackbar("Message", "Something went wrong. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Message", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCuisine(String id) {

    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  bool isSelected(String id) => selectedIds.contains(id);

  void toggleDropdown() => dropdownOpen.value = !dropdownOpen.value;

  List<CuisineModel> get selectedCuisines =>
      allCuisines.where((c) => selectedIds.contains(c.id)).toList();

  Future<void> onContinue() async {
    if (selectedIds.isEmpty) {
      Get.snackbar("Warning", "Please select at least one cuisine");
      return;
    }

    isLoading.value = true;

    try {

      final Map<String, dynamic> body = {};

      for (int i = 0; i < selectedIds.length; i++) {
        body["cousines_expertise[$i]"] = selectedIds[i];
      }

      final response = await ApiService.multipartImage(
        _onboardingEndpoint,
        method: "PATCH",
        body: body,
        files: [],
      );

      if (response.statusCode == 200) {

        LocalStorage.token = response.data['data']['accessToken'];
        await LocalStorage.setString(LocalStorageKeys.token, response.data['data']['accessToken']);
        Get.snackbar(
          "Success",
          response.data['message'] ?? "Cuisine expertise saved!",

        );
        showAccountCreatedPopup();
        // Get.to(() => YourNextScreen()); // next screen এ যাও
      } else {
        Get.snackbar(
            "Error", response.data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

void showAccountCreatedPopup() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cross Button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: const Color(0xFF272727),
                  ),
                ),
              ),
            ),
            8.verticalSpace,
            Container(
              width: 72.w,
              height: 72.w,
              decoration: const BoxDecoration(
                color: Color(0xFF34C759),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 36.sp,
              ),
            ),
            20.verticalSpace,
            Text(
              "Account Created",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF272727),
              ),
            ),
            12.verticalSpace,
            Text(
              "Account created! You're all set to offer your culinary services on HeyChef!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF777777),
                height: 1.5,
              ),
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                 // Get.offAllNamed(AppRoutes.signIn);
                  Get.offAllNamed(AppRoutes.chefHomeScreen);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C1C1C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Go to Home",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}