
import 'package:get/get.dart';

import '../../features/common/auth/change_password/presentation/controller/change_password_controller.dart';
import '../../features/common/auth/forgot password/presentation/controller/forget_password_controller.dart';
import '../../features/common/auth/sign in/presentation/controller/sign_in_controller.dart';
import '../../features/common/auth/sign up/presentation/controller/sign_up_controller.dart';
import '../../features/common/message/presentation/controller/chat_controller.dart';
import '../../features/common/message/presentation/controller/message_controller.dart';
import '../../features/common/notifications/presentation/controller/notifications_controller.dart';
import '../../features/common/setting/presentation/controller/privacy_policy_controller.dart';
import '../../features/common/setting/presentation/controller/setting_controller.dart';
import '../../features/common/setting/presentation/controller/terms_of_services_controller.dart';
import '../../features/customer/address/presentation/controller/address_controller.dart';
import '../../features/customer/booking/presentation/controller/booking_history_controller.dart';
import '../../features/customer/cart/presentation/controller/cart_controller.dart';
import '../../features/customer/home/presentation/controller/home_controller.dart';
import '../../features/customer/past_order/presentation/controller/past_order_controller.dart';
import '../../features/customer/payment/presentation/controller/payment_method_controller.dart';
import '../../features/customer/profile/presentation/controller/profile_controller.dart';



class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => MessageController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => SettingController(), fenix: true);
    Get.lazyPut(() => PrivacyPolicyController(), fenix: true);
    Get.lazyPut(() => TermsOfServicesController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => BookingHistoryController(), fenix: true);
    Get.lazyPut(() => AddressController(), fenix: true);
    Get.lazyPut(() => PaymentMethodController(), fenix: true);
    Get.lazyPut(() => PastOrderController(), fenix: true);
  }
}
