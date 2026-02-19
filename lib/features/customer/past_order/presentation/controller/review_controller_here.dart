// lib/features/orders/controller/review_controller.dart

import 'package:get/get.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/api/api_service.dart';
import '../data/past_order_model.dart';
import '../widgets/review_success_pop_up.dart';

class ReviewController extends GetxController {
  // ── Order passed via arguments ────────────────────────────
  late PastOrderModel order;

  // ── Form State ────────────────────────────────────────────
  String reviewText = '';
  double qualityAndTaste = 0;
  double cleanliness = 0;
  double timeliness = 0;
  double friendliness = 0;
  double communication = 0;

  bool isLoading = false;
  bool isSubmitting = false;
  bool isExpanded = true;

  // ── Computed average ──────────────────────────────────────
  double get averageRating {
    final ratings = [
      qualityAndTaste,
      cleanliness,
      timeliness,
      friendliness,
      communication,
    ].where((r) => r > 0).toList();
    if (ratings.isEmpty) return 0;
    final avg = ratings.reduce((a, b) => a + b) / ratings.length;
    return double.parse(avg.toStringAsFixed(1));
  }

  @override
  void onInit() {
    super.onInit();
    order = Get.arguments as PastOrderModel;
    _loadOrderDetail();
  }

  // ── GET order detail by ID ────────────────────────────────
  // Uses: order/:id
  // Pre-fills order data + existing review/rating if already rated
  Future<void> _loadOrderDetail() async {
    isLoading = true;
    update();

    try {
      final response = await ApiService.get(
        "order/${order.id}",
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          // ── Rebuild order with fresh data ──────────────
          order = PastOrderModel.fromJson(data);

          // ── Pre-fill review fields if already rated ────
          // rating > 0 means user already submitted a review
          if (order.rating > 0) {
            reviewText = order.review ?? '';
            // Rating fields are not in order API response,
            // so pre-fill all category ratings with the
            // overall rating as a starting point
            qualityAndTaste = order.rating;
            cleanliness = order.rating;
            timeliness = order.rating;
            friendliness = order.rating;
            communication = order.rating;
          }
        }
      }
    } catch (_) {
      Get.snackbar("Error", "Failed to load order details",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  // ── POST submit review ────────────────────────────────────
  // Uses: review/extra-review
  Future<void> submitReview() async {
    if (reviewText.trim().isEmpty) {
      Get.snackbar("Error", "Please write a review",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (averageRating == 0) {
      Get.snackbar("Error", "Please provide ratings",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting = true;
    update();

    try {
      final response = await ApiService.post(
        "review/extra-review",
        body: {
          "review": reviewText.trim(),
          "quality_and_taste": qualityAndTaste,
          "cleanliness": cleanliness,
          "timpleness": timeliness,       // keep API spelling
          "friendliness": friendliness,
          "communication": communication,
          "order_id": order.id,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        reviewSuccessPopUp();
      } else {
        Get.snackbar("Error", "Failed to submit review",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (_) {
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting = false;
      update();
    }
  }

  // ── Rating update handlers ────────────────────────────────
  void onQualityChanged(double v)       { qualityAndTaste = v; update(); }
  void onCleanlinessChanged(double v)   { cleanliness = v;     update(); }
  void onTimelinessChanged(double v)    { timeliness = v;      update(); }
  void onFriendlinessChanged(double v)  { friendliness = v;    update(); }
  void onCommunicationChanged(double v) { communication = v;   update(); }
  void onReviewChanged(String v)        { reviewText = v;               }
  void toggleExpanded()                 { isExpanded = !isExpanded; update(); }
}