import 'package:get/get.dart';
import 'package:new_untitled/features/chef/chef_booking/presentation/widgets/booking_details_popup.dart';
import 'package:new_untitled/features/common/notifications/presentation/controller/notifications_controller.dart';
import 'package:new_untitled/utils/log/app_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../config/api/api_end_point.dart';
import '../notification/notification_service.dart';
import '../storage/storage_services.dart';

class SocketServices {
  static late io.Socket _socket;
  bool show = false;

  ///<<<============ Connect with socket ====================>>>
  static void connectToSocket() {
    _socket = io.io(
      ApiEndPoint.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket.onConnect((data) => appLog("=============> Connection $data"));
    _socket.onConnectError((data) => appLog("========>Connection Error $data"));
    _socket.connect();

    _socket.on("get-notification::${LocalStorage.userId}", (data) {
      appLog("================> get Data on socket: $data");
      NotificationService.showNotification(data);
      Get.find<NotificationsController>().getNotificationsRepo();
    });

    _socket.on("order::${LocalStorage.userId}", (data) {
      appLog("================> get Data on socket: $data");
      //final String id = data['_id'];
      Map<String, dynamic> orderData = Map<String, dynamic>.from(data);

      bookingDetailsPopup(Get.context!, order: orderData, selectedTab: "Unconfirmed");
    });

  }

  static on(String event, Function(dynamic data) handler) {
    if (!_socket.connected) {
      connectToSocket();
    }
    _socket.on(event, handler);
  }

  static emit(String event, Function(dynamic data) handler) {
    if (!_socket.connected) {
      connectToSocket();
    }
    _socket.emit(event, handler);
  }

  static emitWithAck(
    String event,
    Map<String, dynamic> data,
    Function(dynamic data) handler,
  ) {
    if (!_socket.connected) {
      connectToSocket();
    }
    _socket.emitWithAck(event, data, ack: handler);
  }
}
