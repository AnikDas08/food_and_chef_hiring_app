class EarningModel {
  final bool success;
  final String message;
  final EarningData data;

  EarningModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: EarningData.fromJson(json['data'] ?? {}),
    );
  }
}

class EarningData {
  final double totalEarning;
  final double lastMonthPercentage;
  final bool isUp;
  final List<MonthEarning> formatArray;

  EarningData({
    required this.totalEarning,
    required this.lastMonthPercentage,
    required this.isUp,
    required this.formatArray,
  });

  factory EarningData.fromJson(Map<String, dynamic> json) {
    return EarningData(
      totalEarning: (json['totalEarning'] as num? ?? 0).toDouble(),
      lastMonthPercentage: (json['last_month_percentage'] as num? ?? 0).toDouble(),
      isUp: json['isUp'] ?? true,
      formatArray: (json['formatArray'] as List? ?? [])
          .map((e) => MonthEarning.fromJson(e))
          .toList(),
    );
  }
}

class MonthEarning {
  final String text;
  final double value;

  MonthEarning({required this.text, required this.value});

  factory MonthEarning.fromJson(Map<String, dynamic> json) {
    return MonthEarning(
      text: json['text'] ?? '',
      value: (json['value'] as num? ?? 0).toDouble(),
    );
  }
}
