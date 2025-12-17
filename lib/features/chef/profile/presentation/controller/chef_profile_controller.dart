import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/services/storage/storage_services.dart';
import 'package:new_untitled/utils/constants/app_icons.dart';
import 'package:new_untitled/utils/helpers/other_helper.dart';

import '../../../../../config/api/api_end_point.dart';
import '../../../../../config/route/app_routes.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/app_utils.dart';

class ChefProfileController extends GetxController {
  /// Language List here
  List languages = ["English", "French", "Arabic"];
  List<Map<String, dynamic>> profileOptions = [
    {"name": "Chef", "image": AppIcons.chefIcon},
    {"name": "Customers", "image": AppIcons.customers},
  ];

  bool isDiscount = false;

  List<String> expertiseInCooking = [
    "Chinese",
    "Italian",
    "American",
    "Indian",
    "Japanese",
  ];

  TextEditingController selectExpertiseController = TextEditingController();

  bool isNotification = false;

  /// form key here
  final formKey = GlobalKey<FormState>();

  /// select Language here
  String selectedLanguage = "English";
  Map<String, dynamic> selectedProfile = {
    "name": "Customers",
    "image": AppIcons.customers,
  };

  onChangeProfile(int index) {
    selectedProfile = profileOptions[index];
    update();
    Get.back();
  }

  onTap(int value) {
    selectExpertiseController.text = expertiseInCooking[value];
    update();
    Get.back();
  }

  onChangeDiscount(v) {
    isDiscount = !isDiscount;
    update();
  }

  /// select image here
  String? image;

  /// edit button loading here
  bool isLoading = false;

  /// all controller here
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  /// select image function here
  getProfileImage() async {
    image = await OtherHelper.openGalleryForProfile();
    update();
  }

  /// select language  function here
  selectLanguage(int index) {
    selectedLanguage = languages[index];
    update();
    Get.back();
  }

  /// notification function here
  void notification(v) {
    isNotification = !isNotification;
    update();
  }

  /// update profile function here
  Future<void> editProfileRepo() async {
    if (!formKey.currentState!.validate()) return;

    if (!LocalStorage.isLogIn) return;
    isLoading = true;
    update();

    Map<String, String> body = {
      "fullName": nameController.text,
      "phone": numberController.text,
    };

    var response = await ApiService.multipart(
      ApiEndPoint.user,
      body: body,
      imagePath: image,
      imageName: "image",
    );

    if (response.statusCode == 200) {
      var data = response.data;

      LocalStorage.userId = data['data']?["_id"] ?? "";
      LocalStorage.myImage = data['data']?["image"] ?? "";
      LocalStorage.myName = data['data']?["fullName"] ?? "";
      LocalStorage.myEmail = data['data']?["email"] ?? "";

      LocalStorage.setString("userId", LocalStorage.userId);
      LocalStorage.setString("myImage", LocalStorage.myImage);
      LocalStorage.setString("myName", LocalStorage.myName);
      LocalStorage.setString("myEmail", LocalStorage.myEmail);

      Utils.successSnackBar("Successfully Profile Updated", response.message);
      Get.toNamed(AppRoutes.profile);
    } else {
      Utils.errorSnackBar(response.statusCode, response.message);
    }

    isLoading = false;
    update();
  }
}
