import 'package:get/get.dart';
import 'package:new_untitled/features/chef/chef_booking/presentation/widgets/booking_details_popup.dart';
import 'package:new_untitled/features/common/notifications/presentation/controller/notifications_controller.dart';
import 'package:new_untitled/utils/log/app_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../config/api/api_end_point.dart';
import '../../features/chef/home/presentation/controller/chef_home_controller.dart';
import '../../features/customer/home/presentation/controller/home_controller.dart';
import '../notification/notification_service.dart';
import '../storage/storage_services.dart';

class SocketServices {
  static io.Socket? _socket;
  bool show = false;

  ///<<<============ Connect with socket ====================>>>
  static void connectToSocket() {
    if (_socket != null) {
      appLog('Disconnecting existing socket...');
      _socket!.disconnect();
      _socket!.dispose();
    }

    _socket = io.io(
      ApiEndPoint.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((data) => appLog('=============> Connection $data'));
    _socket!.onConnectError((data) => appLog('========>Connection Error $data'));
    _socket!.connect();

    final userId = LocalStorage.userId;
    appLog('Setting up socket listeners for user: $userId');

    _socket!.on('get-notification::$userId', (data) {
      appLog('================> get Data on socket: $data');
      NotificationService.showNotification(data);
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().getNotificationsRepo();
      }
    });

    /*_socket!.on('getMessage::$userId', (data) {
      appLog('📨 getMessage received on socket for user $userId: $data');
      //_triggerUnreadCountUpdate();
      print("Hello from getMessage socket event: $data");
      Get.find<HomeController>().isRead();
    });*/

    _socket!.on('update-chatlist::$userId', (data) {
      appLog('📨 update-chatlist received on socket for user $userId');
      _triggerUnreadCountUpdate();
    });

    _socket!.on('get-notification::$userId', (data) {
      appLog('🔔 get-notification received on socket for user $userId: $data');
      NotificationService.showNotification(data);
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().getNotificationsRepo();
      }

      // If notification is message-related, update unread count
      if (data != null && (data['type'] == 'message' || data['type'] == 'chat')) {
        _triggerUnreadCountUpdate();
      }
    });
  }

  static void _triggerUnreadCountUpdate() {
    // We call it multiple times with increasing delays to ensure we catch the DB update
    // especially on slower connections or server processing time.
    for (int delay in [500, 2000, 5000]) {
      Future.delayed(Duration(milliseconds: delay), () {
        if (LocalStorage.isChef) {
          if (Get.isRegistered<ChefHomeController>()) {
            appLog('Triggering Chef unread count update (delay: ${delay}ms)');
            Get.find<ChefHomeController>().isRead();
          }
        } else {
          if (Get.isRegistered<HomeController>()) {
            appLog('Triggering Customer unread count update (delay: ${delay}ms)');
            Get.find<HomeController>().isRead();
          }
        }
      });
    }
  }

  static void on(String event, Function(dynamic data) handler) {
    if (_socket == null || !_socket!.connected) {
      connectToSocket();
    }
    _socket!.on(event, handler);
  }

  static void emit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      connectToSocket();
    }
    _socket!.emit(event, data);
  }

  static void emitWithAck(
    String event,
    Map<String, dynamic> data,
    Function(dynamic data) handler,
  ) {
    if (_socket == null || !_socket!.connected) {
      connectToSocket();
    }
    _socket!.emitWithAck(event, data, ack: handler);
  }

  static void off(String event) {
    _socket?.off(event);
  }
}
