import 'package:get/get.dart';

import '../../features/common/auth/change_password/presentation/screen/change_password_screen.dart';
import '../../features/common/auth/forgot password/presentation/screen/create_password.dart';
import '../../features/common/auth/forgot password/presentation/screen/forgot_password.dart';
import '../../features/common/auth/forgot password/presentation/screen/verify_screen.dart';
import '../../features/common/auth/sign in/presentation/screen/sign_in_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/address_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/create_password_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/dietary_preferences_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/name_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/review_detail_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/sign_up_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/verify_user.dart';
import '../../features/common/message/presentation/screen/chat_screen.dart';
import '../../features/common/message/presentation/screen/message_screen.dart';
import '../../features/common/notifications/presentation/screen/notifications_screen.dart';
import '../../features/common/onboarding_screen/onboarding_screen.dart';
import '../../features/common/profile/presentation/screen/edit_profile.dart';
import '../../features/common/profile/presentation/screen/profile_screen.dart';
import '../../features/common/setting/presentation/screen/privacy_policy_screen.dart';
import '../../features/common/setting/presentation/screen/setting_screen.dart';
import '../../features/common/setting/presentation/screen/terms_of_services_screen.dart';
import '../../features/common/splash/splash_screen.dart';
import '../../features/customer/cart/presentation/screen/cart_screen.dart';
import '../../features/customer/cart/presentation/screen/checkout_screen.dart';
import '../../features/customer/chef_details/presentation/screen/chef_details_screen.dart';
import '../../features/customer/home/presentation/screen/home_screen.dart';
import '../../features/customer/home/presentation/screen/search_screen.dart';

class AppRoutes {
  static const String test = "/test_screen.dart";
  static const String splash = "/splash_screen.dart";
  static const String onboarding = "/onboarding_screen.dart";
  static const String signUp = "/sign_up_screen.dart";
  static const String verifyUser = "/verify_user.dart";
  static const String signIn = "/sign_in_screen.dart";
  static const String forgotPassword = "/forgot_password.dart";
  static const String verifyEmail = "/verify_screen.dart";
  static const String createPassword = "/create_password.dart";
  static const String changePassword = "/change_password_screen.dart";
  static const String notifications = "/notifications_screen.dart";
  static const String chat = "/chat_screen.dart";
  static const String message = "/message_screen.dart";
  static const String profile = "/profile_screen.dart";
  static const String editProfile = "/edit_profile.dart";
  static const String privacyPolicy = "/privacy_policy_screen.dart";
  static const String termsOfServices = "/terms_of_services_screen.dart";
  static const String setting = "/setting_screen.dart";
  static const String createSignUpPassword = "/create_password_screen.dart";
  static const String nameScreen = "/name_screen.dart";
  static const String address = "/address_screen.dart";
  static const String dietaryPreferences = "/dietary_preferences_screen.dart";
  static const String reviewDetail = "/review_detail_screen.dart";
  static const String customerHome = "/home_screen.dart";
  static const String homeSearch = "/search_screen.dart";
  static const String chefDetails = "/chef_details_screen.dart";
  static const String cart = "/cart_screen.dart";
  static const String checkout = "/checkout_screen.dart";

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: verifyUser, page: () => const VerifyUser()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyScreen()),
    GetPage(name: createPassword, page: () => CreatePassword()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),
    GetPage(name: notifications, page: () => const NotificationScreen()),
    GetPage(name: chat, page: () => const ChatListScreen()),
    GetPage(name: message, page: () => const MessageScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfile()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: termsOfServices, page: () => const TermsOfServicesScreen()),
    GetPage(name: setting, page: () => const SettingScreen()),
    GetPage(name: createSignUpPassword, page: () => CreatePasswordScreen()),
    GetPage(name: nameScreen, page: () => NameScreen()),
    GetPage(name: address, page: () => AddressScreen()),
    GetPage(name: dietaryPreferences, page: () => DietaryPreferencesScreen()),
    GetPage(name: reviewDetail, page: () => ReviewDetailScreen()),
    GetPage(name: customerHome, page: () => CustomerHome()),
    GetPage(name: homeSearch, page: () => SearchScreen()),
    GetPage(name: chefDetails, page: () => ChefDetailsScreen()),
    GetPage(name: cart, page: () => CartScreen()),
    GetPage(name: checkout, page: () => CheckoutScreen()),
  ];
}
