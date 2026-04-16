import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/storage/storage_keys.dart';
import '../../../../../../services/storage/storage_services.dart';

class SignInController extends GetxController {
  /// Sign in Button Loading variable
  bool isLoading = false;
  bool isLoadingChef = false;

  /// Sign in form key , help for Validation
  final formKey = GlobalKey<FormState>();

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'feseba4600@azucore.com' : '',
  );

  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : "",
  );

  /// Sign in Api call here
  Future<void> signInUser() async {
    isLoading = true;
    update();

    Map<String, String> body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    var response = await ApiService.post(
      ApiEndPoint.signIn,
      body: body,
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var data = response.data;

      /*if (response.data["data"]["onboarding"] == false) {
        isLoading = false;
        update();
        Get.toNamed(AppRoutes.createSignUpPassword);
        await Utils.errorSnackBar("Complete Profile", "First Complete your all details");
        return;
      }*/

      LocalStorage.token = data['data']["accessToken"];
      LocalStorage.userId = data['data']["userId"];
      LocalStorage.myRole = data["data"]["role"];
      LocalStorage.isLogIn = true;

      await LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
      await LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);
      await LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
      await LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);

      emailController.clear();
      passwordController.clear();

      if (response.data["data"]["role"] == "CHEF") {
        Get.offAllNamed(AppRoutes.chefHomeScreen);
      } else if (response.data["data"]["role"] == "CUSTOMER") {
        Get.offAllNamed(AppRoutes.customerHomeScreen);
      } else {
        Get.snackbar("Message", response.message);
      }

    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }

    isLoading = false;
    update();
  }

  // Future<void> signInChef() async {
  //   if (!formKey.currentState!.validate()) return;
  //
  //   isLoadingChef = true;
  //   update();
  //
  //   Map<String, String> body = {
  //     "email": emailController.text,
  //     "password": passwordController.text,
  //   };
  //
  //   try {
  //     var response = await ApiService.post(
  //       ApiEndPoint.signIn,
  //       body: body,
  //     ).timeout(const Duration(seconds: 30));
  //
  //     if (response.statusCode == 200) {
  //       var data = response.data;
  //       if (response.data["data"]["onboarding"] == false) {
  //         isLoadingChef = false;
  //         update();
  //         Get.toNamed(AppRoutes.createSignUpPassword);
  //         await Utils.errorSnackBar("Complete Profile", "First Complete your all details");
  //         return;
  //       }
  //
  //       LocalStorage.token = data['data']["accessToken"];
  //       LocalStorage.myRole = data["data"]["role"];
  //       LocalStorage.userId = data['data']["userId"];
  //       LocalStorage.isLogIn = true;
  //
  //       await LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
  //       await LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);
  //       await LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
  //       await LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
  //
  //       emailController.clear();
  //       passwordController.clear();
  //
  //       Get.offAllNamed(AppRoutes.chefHomeScreen);
  //     } else {
  //       Get.snackbar(response.statusCode.toString(), response.message);
  //     }
  //   } catch (e) {
  //     debugPrint("❌ SignIn Chef error: $e");
  //     Utils.errorSnackBar("Error", "Something went wrong");
  //   } finally {
  //     isLoadingChef = false;
  //     update();
  //   }
  // }
}
