
import '../../../../services/api/api_service.dart';
import '../presentation/data/past_order_model.dart';

class PastOrderRepository {
  static Future<PastOrderListResponse?> getPastOrders({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await ApiService.get(
      "order?status=Completed&page=$page&limit=$limit",
    );
    if (response.statusCode == 200) {
      return PastOrderListResponse.fromJson(response.data);
    }
    return null;
  }


  // lib/features/orders/repository/past_order_repository.dart

  static Future<PastOrderModel?> getOrderById(String id) async {
    final response = await ApiService.get("order/$id");
    if (response.statusCode == 200) {
      return PastOrderModel.fromJson(response.data['data']);
    }
    return null;
  }
}