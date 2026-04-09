import 'package:get/get.dart';
import 'package:new_untitled/features/chef/availaility/presentation/screen/availabiity_screen.dart';
import 'package:new_untitled/features/chef/chef_public_profile/presentation/screen/chef_public_profile.dart';
import 'package:new_untitled/features/chef/home/presentation/screen/App_Information_Screen.dart';
import 'package:new_untitled/features/chef/home/presentation/screen/chef_home.dart';
import 'package:new_untitled/features/chef/menu/presentation/screen/add_menu_screen.dart';
import 'package:new_untitled/features/chef/menu/presentation/screen/edit_menu.dart';
import 'package:new_untitled/features/chef/menu/presentation/screen/menu_screen.dart';
import 'package:new_untitled/features/chef/profile/presentation/screen/account_setting.dart';
import 'package:new_untitled/features/chef/profile/presentation/screen/chef_Update_Location_Screen.dart';
import 'package:new_untitled/features/common/auth/sign%20up/presentation/screen/signup_chef_screen.dart';
import 'package:new_untitled/features/common/auth/signup_chef/presentation/screen/chef_name_screen.dart';
import 'package:new_untitled/features/common/auth/signup_chef/presentation/screen/chef_verify_user.dart';
import 'package:new_untitled/features/common/auth/signup_chef/presentation/screen/create_password_chef_screen.dart';
import 'package:new_untitled/features/customer/address/presentation/screen/add_address_screen.dart';
import 'package:new_untitled/features/customer/address/presentation/screen/edit_address_screen.dart';
import 'package:new_untitled/features/customer/cart/presentation/screen/promo_code_screen.dart';
import 'package:new_untitled/features/customer/home/presentation/screen/customer_home_screen.dart';
import '../../features/chef/chef_booking/presentation/screen/chef_booking_screen.dart';
import '../../features/chef/payment/presentation/screen/add_payment_method.dart';
import '../../features/chef/payment/presentation/screen/chef_payment_screen.dart';
import '../../features/chef/payment/presentation/screen/history_screen.dart';
import '../../features/chef/payment/presentation/screen/withdraw_method_screen.dart';
import '../../features/chef/payment/presentation/screen/withdraw_screen.dart';
import '../../features/chef/profile/presentation/screen/chef_edit_profile.dart';
import '../../features/chef/profile/presentation/screen/chef_profile_screen.dart';
import '../../features/common/auth/change_password/presentation/screen/change_password_screen.dart';
import '../../features/common/auth/forgot password/presentation/screen/create_password.dart';
import '../../features/common/auth/forgot password/presentation/screen/forgot_password.dart';
import '../../features/common/auth/forgot password/presentation/screen/verify_screen.dart';
import '../../features/common/auth/sign in/presentation/screen/sign_in_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/create_password_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/dietary_preferences_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/name_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/review_detail_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/sign_up_screen.dart';
import '../../features/common/auth/sign up/presentation/screen/verify_user.dart';
import '../../features/common/message/presentation/screen/message_screen.dart';
import '../../features/common/notifications/presentation/screen/notifications_screen.dart';
import '../../features/common/onboarding_screen/onboarding_screen.dart';
import '../../features/common/setting/presentation/screen/privacy_policy_screen.dart';
import '../../features/common/setting/presentation/screen/setting_screen.dart';
import '../../features/common/setting/presentation/screen/terms_of_services_screen.dart';
import '../../features/common/splash/splash_screen.dart';
import '../../features/customer/address/presentation/screen/profile_address_screen.dart';
import '../../features/customer/booking/presentation/screen/request_change_screen.dart';
import '../../features/customer/cart/presentation/screen/business_tax_details_screen.dart';
import '../../features/customer/cart/presentation/screen/cart_screen.dart';
import '../../features/customer/cart/presentation/screen/checkout_screen.dart';
import '../../features/customer/cart/presentation/screen/personal_tax_details_screen.dart';
import '../../features/customer/chef_details/presentation/screen/chef_details_screen.dart';
import '../../features/customer/dietary/presentation/screen/dietary_screen.dart';
import '../../features/customer/home/presentation/screen/search_screen.dart';
import '../../features/customer/kitchen/presentation/screen/add_equipment_screen.dart';
import '../../features/customer/kitchen/presentation/screen/kitchen_screen.dart';
import '../../features/customer/past_order/presentation/screen/past_order_screen.dart';
import '../../features/customer/past_order/presentation/screen/reorder_screen.dart';
import '../../features/customer/past_order/presentation/screen/review_screen.dart';
import '../../features/customer/payment/presentation/screen/add_card_screen.dart';
import '../../features/customer/payment/presentation/screen/edit_card_screen.dart';
import '../../features/customer/payment/presentation/screen/payment_method_screen.dart';
import '../../features/customer/profile/presentation/screen/edit_profile.dart';

class AppRoutes {

  static const String test = "/test_screen.dart";
  static const String splash = "/splash_screen.dart";
  static const String onboarding = "/onboarding_screen.dart";
  static const String signUp = "/sign_up_screen.dart";
  static const String signUpChef = "/sign_up_screen_chef.dart";
  static const String verifyUser = "/verify_user.dart";
  static const String signIn = "/sign_in_screen.dart";
  static const String forgotPassword = "/forgot_password.dart";
  static const String verifyEmail = "/verify_screen.dart";
  static const String createPassword = "/create_password.dart";
  static const String changePassword = "/change_password_screen.dart";
  static const String notifications = "/notifications_screen.dart";
  static const String message = "/message_screen.dart";

  // static const String profile = "/profile_screen.dart";
  static const String create_password_chef_screen = "/create_password_chef_screen.dart";
  static const String chef_name_screen = "/chef_name_screen.dart";
  static const String chef_verify_user = "/chef_verify_user.dart";
  static const String editProfile = "/edit_profile.dart";
  static const String privacyPolicy = "/privacy_policy_screen.dart";
  static const String termsOfServices = "/terms_of_services_screen.dart";
  static const String setting = "/setting_screen.dart";
  static const String createSignUpPassword = "/create_password_screen.dart";
  static const String createChefSignUpPassword = "/create_password_chef_screen.dart";
  static const String nameScreen = "/name_screen.dart";
  static const String dietaryPreferences = "/dietary_preferences_screen.dart";
  static const String reviewDetail = "/review_detail_screen.dart";
  // static const String customerHome = "/home_screen.dart";
  static const String homeSearch = "/search_screen.dart";
  static const String chefDetails = "/chef_details_screen.dart";
  static const String cart = "/cart_screen.dart";
  static const String checkout = "/checkout_screen.dart";
  static const String businessTaxDetails = "/business_tax_details_screen.dart";
  static const String personalTaxDetails = "/personal_tax_details_screen.dart";

  // static const String bookingHistory = "/booking_history_screen.dart";
  static const String requestChange = "/request_change_screen.dart";
  static const String addressScreen = "/profile_address_screen.dart";
  static const String addAddress = "/add_address_screen.dart";
  static const String paymentMethod = "/payment_method_screen.dart";
  static const String addCard = "/add_card_screen.dart";
  static const String App_Information_Screen = "/App_Information_Screen.dart";
  static const String editCard = "/edit_card_screen.dart";
  static const String pastOrder = "/past_order_screen.dart";
  static const String reorder = "/reorder_screen.dart";
  static const String edit_address = "/edit_address.dart";
  static const String review = "/review_screen.dart";
  static const String chefHomeScreen = "/chef_home_screen.dart";
  static const String chefBooking = "/chef_booking_screen.dart";
  static const String chefProfile = "/chef_profile_screen.dart";
  static const String chefPublicProfile = "/chef_public_profile_screen.dart";
  static const String chefEditProfile = "/chef_edit_profile.dart";
  static const String availability = "/availabiity_screen.dart";
  static const String menu = "/menu_screen.dart";
  static const String addMenu = "/add_menu_screen.dart";
  static const String editMenu = "/edit_menu.dart";
  static const String accountSetting = "/account_setting.dart";
  // static const String analytics = "/analytics_screen.dart";
  static const String kitchen = "/kitchen_screen.dart";
  static const String dietary = "/dietary_screen.dart";
  static const String addEquipment = "/add_equipment_screen.dart";
  static const String addPaymentMethod = "/add_payment_method.dart";
  static const String chefPayment = "/chef_payment_screen.dart";
  static const String withdraw = "/withdraw_screen.dart";
  static const String withdrawMethod = "/withdraw_method_screen.dart";
  static const String history = "/history_screen.dart";
  static const String promoCode = "/promo_code_screen.dart";
  static const String chefUpdateLocationScreen = "/chefUpdateLocationScreen.dart";
  static const String customerHomeScreen = "/customer_home_screen.dart";


  //===============================================================================

  static List<GetPage> routes = [
    GetPage(name: create_password_chef_screen, page: () =>  CreatePasswordChefScreen()),
    GetPage(name: create_password_chef_screen, page: () =>  CreatePasswordChefScreen()),
    GetPage(name: chef_name_screen, page: () =>  ChefNameScreen()),
    GetPage(name: chef_verify_user, page: () =>  ChefVerifyUser()),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: chefUpdateLocationScreen, page: () => ChefUpdateLocationScreen()),
    GetPage(name: signUpChef, page: () => SignupChefScreen()),
    GetPage(name: verifyUser, page: () => const VerifyUser()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyScreen()),
    GetPage(name: createPassword, page: () => CreatePassword()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),
    GetPage(name: notifications, page: () => const NotificationScreen()),
    GetPage(name: message, page: () => const MessageScreen()),
    GetPage(name: editProfile, page: () => EditProfile()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: termsOfServices, page: () => const TermsOfServicesScreen()),
    GetPage(name: setting, page: () => const SettingScreen()),
    GetPage(name: createSignUpPassword, page: () => CreatePasswordScreen()),
    GetPage(name: nameScreen, page: () => NameScreen()),
    GetPage(name: dietaryPreferences, page: () => DietaryPreferencesScreen()),
    GetPage(name: reviewDetail, page: () => ReviewDetailScreen()),
    GetPage(name: homeSearch, page: () => SearchScreen()),
    GetPage(name: chefDetails, page: () => ChefDetailsScreen()),
    GetPage(name: cart, page: () => CartScreen()),
    GetPage(name: checkout, page: () => CheckoutScreen()),
    GetPage(name: businessTaxDetails, page: () => BusinessTaxDetailsScreen()),
    GetPage(name: personalTaxDetails, page: () => PersonalTaxDetailsScreen()),
    GetPage(name: requestChange, page: () => RequestChangeScreen()),
    GetPage(name: App_Information_Screen, page: () => AppInformationScreen()),
    GetPage(name: edit_address, page: () => EditAddressScreen()),
    GetPage(name: addressScreen, page: () => ProfileAddressScreen()),
    GetPage(name: addAddress, page: () => AddAddressScreen()),
    GetPage(name: paymentMethod, page: () => PaymentMethodScreen()),
    GetPage(name: addCard, page: () => AddCardScreen()),
    GetPage(name: editCard, page: () => EditCardScreen()),
    GetPage(name: pastOrder, page: () => PastOrderScreen()),
    GetPage(name: reorder, page: () => ReorderScreen()),
    GetPage(name: review, page: () => ReviewScreen()),
    GetPage(name: chefHomeScreen, page: () => ChefHome()),
    GetPage(name: chefBooking, page: () => ChefBookingScreen()),
    GetPage(name: chefProfile, page: () => ChefProfileScreen()),
    GetPage(name: chefPublicProfile, page: () => ChefPublicProfile()),
    GetPage(name: chefEditProfile, page: () => ChefEditProfile()),
    GetPage(name: availability, page: () => AvailabiityScreen ()),
    GetPage(name: menu, page: () => MenuScreen()),
    GetPage(name: addMenu, page: () => AddMenuScreen()),
    GetPage(name: editMenu, page: () => EditMenu()),
    GetPage(name: accountSetting, page: () => AccountSetting()),
    GetPage(name: kitchen, page: () => KitchenScreen()),
    GetPage(name: dietary, page: () => DietaryScreen()),
    GetPage(name: addEquipment, page: () => AddEquipmentScreen()),
    GetPage(name: chefPayment, page: () => ChefPaymentScreen()),
    GetPage(name: addPaymentMethod, page: () => AddPaymentMethod()),
    GetPage(name: withdraw, page: () => WithdrawScreen()),
    GetPage(name: withdrawMethod, page: () => WithdrawMethodScreen()),
    GetPage(name: history, page: () => HistoryScreen()),
    GetPage(name: promoCode, page: () => PromoCodeScreen()),
    GetPage(name: customerHomeScreen, page: () => CustomerHomeScreen()),
  ];
}
