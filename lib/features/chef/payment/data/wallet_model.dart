class WalletModel {
  final bool success;
  final String message;
  final WalletData data;

  WalletModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: WalletData.fromJson(json['data'] ?? {}),
    );
  }
}

class WalletData {
  final double balance;
  final double lastMonthPercentage;
  final bool isUp;

  WalletData({
    required this.balance,
    required this.lastMonthPercentage,
    required this.isUp,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      balance: (json['balance'] as num? ?? 0).toDouble(),
      lastMonthPercentage: (json['last_month_percentage'] as num? ?? 0).toDouble(),
      isUp: json['isUp'] ?? false,
    );
  }
}
