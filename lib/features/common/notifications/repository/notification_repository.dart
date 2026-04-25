import '../../../../services/api/api_service.dart';
import '../../../../utils/log/app_log.dart';
import '../data/model/notification_model.dart';

Future<List<NotificationModel>> notificationRepository(int page) async {
  try {
    // Adjusted endpoint to include pagination params
    final response = await ApiService.get('notification?page=$page&limit=10');

    if (response.statusCode == 200) {
      // Your JSON structure is: data { unreadCount: X, data: [ ... ] }
      final List rawData = response.data['data']['data'];
      return rawData.map((e) => NotificationModel.fromJson(e)).toList();
    }
    return [];
  } catch (e) {
    appLog('Repository Error: $e');
    return [];
  }
}