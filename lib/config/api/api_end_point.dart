class ApiEndPoint {

  static const baseUrl = "http://10.10.7.9:5014/api/v1/";
  static const imageUrl = "http://10.10.7.9:5014/files";
  static const image = "http://10.10.7.9:5014";
  static const socketUrl = "http://10.10.7.9:5014";

  // static const baseUrl = "http://187.124.93.197:5014/api/v1/";
  // static const imageUrl = "http://187.124.93.197:5014/files";
  // static const image = "http://187.124.93.197:5014";
  // static const socketUrl = "http://187.124.93.197:5014";

  static const signUp = "user";
  static const verifyEmail = "auth/verify-email";
  static const signIn = "auth/login";
  static const support = "/support";
  static const forgotPassword = "auth/forget-password";
  static const verifyOtp = "auth/verify-email";
  static const googleMapsApiKey = "AIzaSyCZTRv24vE1zWXiLgKt5LbktOVGb1AeX_E";
  static const resetPassword = "auth/reset-password";
  static const changePassword = "users/change-password";
  static const user = "user/profile";
  static const address = "address";
  static const String createConnectedAccount = 'user/create-connected-account';
  static const notifications = "notifications";
  static const privacyPolicies = "privacy-policies";
  static const termsOfServices = "terms-and-conditions";
  static const chats = "chat";
  static const messages = "message";
  static const cuisine = "/cusine";
  static const AddMenuSection = "/menu/section?id=";
  static const String getUnits = "/menu/units";
  static const String getEquipments = "/equipment";
  static const String addMenuItem = "/menu?id=";
  static const String chefProfile = 'user/profile';
  static const String wallet = '/user/wallet';
  static const String order = '/order';
  static const String totalEarning = 'transaction/chef?range=';
  static const String topMenus = 'menu/top-menus';
  static const String changeOrderStatus = '/order/change-status/';
  static const String UpcomingBookingsOrder = 'order';
  static const String requestChangeSchedule = '/order/change-schedule/';
  static const String changeSchedule = '/order/change-schedule/';
  static const String deleteAccount = '/user/account-delete';
  static const String mostBookingTime = 'order/chef/most-booking-time?date=';
  static const String withdrawWallet = '/user/wallet/withdraw';
  static const String transaction = '/transaction';
  static const String singleOrder = '/order/';
  static const String ChefReview = '/review';
  static const String ChefChatNav = '/chat/';


}
