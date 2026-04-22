import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/log/app_log.dart';

class HistoryController extends GetxController {
  List<String> bookingHistoryList = ['Withdrawal', 'Payment received'];
  String selectedBookingHistory = 'Withdrawal';
  List<Map> history = [];
  bool isLoading = true;

  String searchText = '';

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void onChangeBookingHistory(String value) {
    if (selectedBookingHistory == value) return;
    isLoading = true;
    selectedBookingHistory = value;
    update();
    fetchHistory();
  }

  void onSearch(String value) {
    searchText = value;
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading = true;
    update();

    try {
      // type: "Withdraw" or "Booking"
      final String type =
      selectedBookingHistory == 'Withdrawal' ? 'Withdraw' : 'Booking';

      String url = '${ApiEndPoint.transaction}?type=$type';

      // search থাকলে add করো
      if (searchText.isNotEmpty) {
        url += '&searchTerm=$searchText';
      }

      final response = await ApiService.get(url);

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];

        history = data.map<Map>((item) {

          final bool isDeduct = item['payment_type'] == 'deduct';

          return {
            'title': item['type'] ?? '',
            'date': _formatDate(item['createdAt']),
            'amount': item['total'].toString(),
            'status': item['status'] ?? 'Pending',
            'subTitle': item['user'] != null
                ? "From ${item['user']['name']}"
                : 'To your PayPal account',
            'isDeduct': isDeduct, // true = "-", false = "+"
          };
        }).toList();
      } else {
        history = [];
      }
    } catch (e) {
      appLog('HistoryController Error: $e');
      history = [];
    }

    isLoading = false;
    update();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final DateTime dt = DateTime.parse(isoDate);
      const months = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${dt.day} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}