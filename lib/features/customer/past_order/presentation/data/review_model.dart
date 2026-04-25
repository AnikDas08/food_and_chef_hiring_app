// lib/features/orders/data/review_model.dart

class ReviewModel {
  final String review;
  final double qualityAndTaste;
  final double cleanliness;
  final double timeliness;
  final double friendliness;
  final double communication;
  final double averageRating;

  ReviewModel({
    required this.review,
    required this.qualityAndTaste,
    required this.cleanliness,
    required this.timeliness,
    required this.friendliness,
    required this.communication,
    required this.averageRating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final q = (json['quality_and_taste'] ?? 0).toDouble();
    final c = (json['cleanliness'] ?? 0).toDouble();
    final t = (json['timpleness'] ?? 0).toDouble();
    final f = (json['friendliness'] ?? 0).toDouble();
    final cm = (json['communication'] ?? 0).toDouble();
    final avg = (q + c + t + f + cm) / 5;

    return ReviewModel(
      review: json['review'] ?? '',
      qualityAndTaste: q,
      cleanliness: c,
      timeliness: t,
      friendliness: f,
      communication: cm,
      averageRating: double.parse(avg.toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson(String orderId) => {
    'review': review,
    'quality_and_taste': qualityAndTaste,
    'cleanliness': cleanliness,
    'timpleness': timeliness,       // keep API spelling
    'friendliness': friendliness,
    'communication': communication,
    'order_id': orderId,
  };
}