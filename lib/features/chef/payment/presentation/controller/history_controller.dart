
import 'package:get/get.dart';

class HistoryController extends GetxController {
  List<String> bookingHistoryList = ["Withdrawal", "Payment received"];

  String selectedBookingHistory = "Withdrawal";

  List<Map> history = [
    {
      "title": "Withdrawal",
      "date": "24 June 2025",
      "amount": "12,400",
      "status": "Completed",
      "subTitle": "To your PayPal account",
      "isWithdraw": true,
    },

    {
      "title": "Withdrawal",
      "date": "24 June 2025",
      "amount": "12,400",
      "status": "Pending",
      "subTitle": "To your PayPal account",
      "isWithdraw": false,
    },

    {
      "title": "Withdrawal",
      "date": "24 June 2025",
      "amount": "12,400",
      "status": "Failed",
      "subTitle": "To your PayPal account",
      "isWithdraw": false,
    },

    {
      "title": "Withdrawal",
      "date": "24 June 2025",
      "amount": "12,400",
      "status": "Completed",
      "subTitle": "From Christina Julia",
      "isWithdraw": false,
    },

    {
      "title": "Withdrawal",
      "date": "24 June 2025",
      "amount": "12,400",
      "status": "Completed",
      "subTitle": "To your PayPal account",
      "isWithdraw": true,
    },

    {
      "title": "Withdrawal",
      "date": "24 June 2025",
      "amount": "12,400",
      "status": "Completed",
      "subTitle": "To your PayPal account",
      "isWithdraw": true,
    },
  ];

  bool isLoading = true;

  onChangeBookingHistory(String value) {
    if (selectedBookingHistory == value) return;
    isLoading = true;
    selectedBookingHistory = value;
    update();
    Future.delayed(Duration(milliseconds: 300), () {
      isLoading = false;
      update();
    });
  }


}
