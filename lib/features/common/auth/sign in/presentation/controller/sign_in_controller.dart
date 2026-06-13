import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🌟 নতুন ইম্পোর্ট
import 'package:google_sign_in/google_sign_in.dart'; // 🌟 নতুন ইম্পোর্ট
import 'package:new_untitled/features/common/auth/sign%20up/presentation/controller/sign_up_controller.dart';

import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../services/api/api_service.dart';
import '../../../../../../services/socket/socket_service.dart';
import '../../../../../../services/storage/storage_keys.dart';
import '../../../../../../services/storage/storage_services.dart';
import '../../../../../../utils/app_utils.dart';

class SignInController extends GetxController {
  /// Sign in Button Loading variable
  bool isLoading = false;
  bool isLoadingChef = false;

  /// 🌟 Google Sign-In এবং Firebase-এর জন্য গেটার অবজেক্ট
  FirebaseAuth get _auth => FirebaseAuth.instance;
  GoogleSignIn get _googleSignIn => GoogleSignIn();

  /// Sign in form key , help for Validation
  final formKey = GlobalKey<FormState>();

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'feseba4600@azucore.com' : '',
  );

  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : '',
  );

  /// ১. সাধারণ ইমেইল/পাসওয়ার্ড লগইন (আপনার আগের কোড)
  Future<void> signInUser() async {
    isLoading = true;
    update();

    final Map<String, String> body = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final response = await ApiService.post(
      ApiEndPoint.signIn,
      body: body,
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      await _handleLoginSuccessAndNavigation(response.data, email: emailController.text);
      emailController.clear();
      passwordController.clear();
    } else {
      Utils.errorSnackBar('Error', response.message);
    }

    isLoading = false;
    update();
  }

  /// 🌟 ২. নতুন মেথড: Firebase Google Sign-In (নতুন ব্যাকএন্ড ফরম্যাট অনুযায়ী)
  /// UI থেকে কল করার সময় রোল পাস করবেন: signInWithGoogleFirebase('CUSTOMER') অথবা 'CHEF'
  Future<void> signInWithGoogleFirebase(String selectedRole) async {
    isLoading = true;
    update();

    try {
      // গুগলের পপআপ স্ক্রিন ওপেন করা
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading = false;
        update();
        return; // ইউজার ক্যানসেল করলে ব্যাক করবে
      }

      // গুগল অ্যাকাউন্ট থেকে সিকিউরিটি টোকেন নেওয়া
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // ফায়ারবেসের জন্য ক্রেডেনশিয়াল তৈরি করা
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // ফায়ারবেস অথেনটিকেশনে সাইন-ইন সম্পন্ন করা
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 🌟 আপনার নতুন ব্যাকএন্ডের হুবহু ডিমান্ড করা বডি স্ট্রাকচার
        final Map<String, String> body = {
          "email": firebaseUser.email ?? googleUser.email,
          "name": firebaseUser.displayName ?? googleUser.displayName ?? "No Name",
          "type": "google",
          "role":"CUSTOMER"
        };

        final response = await ApiService.post(
          "auth/social-signin",
          body: body,
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          await _handleLoginSuccessAndNavigation(response.data, email: firebaseUser.email);
        } else {
          Utils.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      Utils.errorSnackBar("Google Auth Failed", e.toString());
      debugPrint("=================== GOOGLE AUTH ERROR: $e ===================");
    }

    isLoading = false;
    update();
  }

  /// 🌟 ৩. নতুন মেথড: Firebase Apple Sign-In (নতুন ব্যাকএন্ড ফরম্যাট অনুযায়ী)
  /// UI থেকে কল করার সময় রোল পাস করবেন: signInWithAppleFirebase('CUSTOMER') অথবা 'CHEF'
  Future<void> signInWithAppleFirebase(String selectedRole) async {
    isLoading = true;
    update();

    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      // ফায়ারবেসের মাধ্যমে অ্যাপল সাইন-ইন ট্রিগার করা
      final UserCredential userCredential = await _auth.signInWithProvider(appleProvider);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 🌟 আপনার নতুন ব্যাকএন্ডের হুবহু ডিমান্ড করা বডি স্ট্রাকচার
        final Map<String, String> body = {
          "email": firebaseUser.email ?? "",
          "name": firebaseUser.displayName ?? "No Name",
          "type": "apple",
          "role":"CUSTOMER"
        };

        final response = await ApiService.post(
          "auth/social-signin",
          body: body,
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          await _handleLoginSuccessAndNavigation(response.data, email: firebaseUser.email);
        } else {
          //Utils.errorSnackBar('Error', response.message);
        }
      }
    } catch (e) {
      Utils.errorSnackBar("Apple Auth Failed", e.toString());
      debugPrint("=================== APPLE AUTH ERROR: $e ===================");
    }

    isLoading = false;
    update();
  }

  /// 🌟 ৪. সব লগইনের সাকসেস ডাটা সেভ, সকেট কানেক্ট এবং নেভিগেশন করার কমন মেথড (DRY Rule)
  Future<void> _handleLoginSuccessAndNavigation(dynamic responseData, {String? email}) async {
    final data = responseData['data'] ?? responseData;

    LocalStorage.token = data['accessToken'] ?? "";
    LocalStorage.userId = data['userId'] ?? "";
    LocalStorage.myRole = data['role'] ?? "";
    LocalStorage.isLogIn = true;

    if (email != null && email.isNotEmpty) {
      LocalStorage.setString(LocalStorageKeys.myEmail, email);
      Get.put(SignUpController()).emailController.text = email;
    }

    await LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
    await LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);
    await LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
    await LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);

    // সকেট রিকানেক্ট (আপনার আগের আর্কিটেকচার অনুযায়ী)
    SocketServices.connectToSocket();

    if (data["is_onboarding_completed"] != null && data["is_onboarding_completed"] == false) {
      Get.toNamed(AppRoutes.nameScreen);
      return;
    }
    if (data['role'] == 'CHEF') {
      Get.offAllNamed(AppRoutes.chefHomeScreen);
    } else if (data['role'] == 'CUSTOMER') {
      Get.offAllNamed(AppRoutes.customerHomeScreen);
    } else {
      Utils.successSnackBar('Message', responseData['message'] ?? "Login Successful");
    }
  }
}