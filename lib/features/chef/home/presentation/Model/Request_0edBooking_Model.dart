class RequestedBookingModel {
  final String id;
  final String status;
  final String scheduledAt;
  final int totalItems;
  final double total;
  final String customerName;
  final String customerImage;
  final String address;

  RequestedBookingModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    required this.totalItems,
    required this.total,
    required this.customerName,
    required this.customerImage,
    required this.address,
  });

  factory RequestedBookingModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final items = json['items'] as List? ?? [];
    return RequestedBookingModel(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      scheduledAt: json['scheduledAt'] ?? json['createdAt'] ?? '',
      totalItems: items.length,
      total: (json['total'] ?? 0).toDouble(),
      customerName: user['name'] ?? '',
      customerImage: user['image'] ?? '',
      address: json['address'] ?? '',
    );
  }
}