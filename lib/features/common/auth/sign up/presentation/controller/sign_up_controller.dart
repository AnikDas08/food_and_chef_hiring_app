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

class SignUpController extends GetxController {
  bool isPopUpOpen = false;
  bool isLoading = false;
  bool isLoadingVerify = false;
  bool isCompleteProfile = false;

  Timer? _timer;
  int start = 0;

  String time = "";

  String? image;

  getProfileImage() async {
    image = await OtherHelper.openGallery();
    update();
  }

  List selectedOption = ["User", "Consultant"];
  List dietaryOption = [
    "Vegetarian",
    "Vegan",
    "Pescatarian",
    "Gluten-free",
    "Dairy-free",
    "Lactose-free",
    "Nut-free",
    "Soy-free",
    "Egg-free",
    "Shellfish-free",
    "Halal",
    "Kosher",
  ];

  List selectDietary = [];

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
  TextEditingController numberController = TextEditingController(
  );
  TextEditingController addressController = TextEditingController();
  TextEditingController dietaryController = TextEditingController();
  TextEditingController otpController = TextEditingController(
    text: kDebugMode ? '' : '',
  );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    //Get.toNamed(AppRoutes.verifyUser);
    isLoading = true;
    update();
    Map<String, String> body = {
      "email": emailController.text,
      "role": role,
    };

    var response = await ApiService.post(
        ApiEndPoint.signUp,
        body: body
    );

    if (response.statusCode == 200) {
      var data = response.data;
      //signUpToken = data['data']['signUpToken'];
      Get.toNamed(AppRoutes.verifyUser);
    }
    else if(response.statusCode==400 && response.data["suggestRoute"]=="/api/v1/auth/verify-email"){
      Get.toNamed(AppRoutes.verifyUser);
    }
    else {
      Utils.errorSnackBar(response.statusCode.toString(), response.message);
    }
    isLoading = false;
    update();
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    start = 120; // Reset the start value
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
    //Get.toNamed(AppRoutes.createSignUpPassword);
    isLoadingVerify = true;
    update();
    Map<String, dynamic> body = {
      "email": emailController.text,
      "oneTimeCode": int.parse(otpController.text),
    };
    //Map<String, String> header = {"SignUpToken": "signUpToken $signUpToken"};
    var response = await ApiService.post(
      ApiEndPoint.verifyEmail,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = response.data;
      LocalStorage.userId=await data["data"];
      await LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);

      Get.toNamed(AppRoutes.createSignUpPassword);



     /* LocalStorage.token = data['data']["accessToken"];
      LocalStorage.userId = data['data']["attributes"]["_id"];
      LocalStorage.myImage = data['data']["attributes"]["image"];
      LocalStorage.myName = data['data']["attributes"]["fullName"];
      LocalStorage.myEmail = data['data']["attributes"]["email"];
      LocalStorage.isLogIn = true;*/

      /*LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
      LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);
      LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
      LocalStorage.setString(LocalStorageKeys.myImage, LocalStorage.myImage);
      LocalStorage.setString(LocalStorageKeys.myName, LocalStorage.myName);
      LocalStorage.setString(LocalStorageKeys.myEmail, LocalStorage.myEmail);*/

      // if (LocalStorage.myRole == 'consultant') {
      //   Get.toNamed(AppRoutes.personalInformation);
      // } else {
      //   Get.offAllNamed(AppRoutes.patientsHome);
      // }
    }
    else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }

    isLoadingVerify = false;
    update();
  }
  
  completeProfile() async {
    isCompleteProfile=true;
    update();
    try{
      Map<String,dynamic> body={
        "first_name":firstNameController.text,
        "last_name":lastNameController.text,
        "address":addressController.text,
        "password":passwordController.text,
        "lat":"23.777176",
        "lng":"90.399452",
        "contact":"$countryCode ${numberController.text}"
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
        accountCreatePopup();
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }

    }catch(e){
      Utils.errorSnackBar("Error", e.toString());
    }
  }
  
  
}
