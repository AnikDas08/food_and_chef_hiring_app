class BookingTimeModel {
  final bool success;
  final String message;
  final BookingData data;

  BookingTimeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingTimeModel.fromJson(Map<String, dynamic> json) {
    return BookingTimeModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final List<MappedTime> mappedData;
  final AvgCountOrder avgCountOrder;

  BookingData({required this.mappedData, required this.avgCountOrder});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      mappedData: (json['mappedData'] as List)
          .map((e) => MappedTime.fromJson(e))
          .toList(),
      avgCountOrder: AvgCountOrder.fromJson(json['avgCountOrder']),
    );
  }
}

class MappedTime {
  final String time;
  final int count;

  MappedTime({required this.time, required this.count});

  factory MappedTime.fromJson(Map<String, dynamic> json) {
    return MappedTime(
      time: json['time'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class AvgCountOrder {
  final double avgDuration;
  final double avgPrice;
  final int avgMenus;
  final int totalBooking;

  AvgCountOrder({
    required this.avgDuration,
    required this.avgPrice,
    required this.avgMenus,
    required this.totalBooking,
  });

  factory AvgCountOrder.fromJson(Map<String, dynamic> json) {
    return AvgCountOrder(
      avgDuration: (json['avg_duration'] as num).toDouble(),
      avgPrice: (json['avg_price'] as num).toDouble(),
      avgMenus: json['avg_menus'] ?? 0,
      totalBooking: json['total_booking'] ?? 0,
    );
  }
}