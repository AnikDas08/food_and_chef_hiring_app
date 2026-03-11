// lib/features/orders/controller/past_order_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/customer/past_order/presentation/widgets/past_item_details_popup.dart';
import '../../repository/past_order_repository.dart';
import '../data/past_order_model.dart';

class PastOrderController extends GetxController {
  // ── State ─────────────────────────────────────────────────
  List<PastOrderModel> orderList = [];
  bool isLoading = false;
  bool isFetchingMore = false;

  PastOrderModel? selectedOrder;
  bool isLoadingDetail = false;

  int _currentPage = 1;
  int _totalPage = 1;
  final int _limit = 10;

  bool get hasMorePages => _currentPage < _totalPage;

  // ── Scroll ────────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _listenScroll();
    fetchOrders();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _listenScroll() {
    scrollController.addListener(() {
      final pos = scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        loadMoreOrders();
      }
    });
  }

  // ── Initial Fetch / Pull-to-Refresh ───────────────────────
  Future<void> fetchOrders() async {
    if (isLoading) return;
    isLoading = true;
    _currentPage = 1;
    orderList.clear();
    update();

    try {
      final result = await PastOrderRepository.getPastOrders(
        page: _currentPage,
        limit: _limit,
      );
      if (result != null) {
        orderList = result.data;
        _totalPage = result.pagination.totalPage;
      }
    } catch (_) {
      Get.snackbar("Error", "Failed to load orders",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  // ── Load Next Page ────────────────────────────────────────
  Future<void> loadMoreOrders() async {
    if (isFetchingMore || isLoading || !hasMorePages) return;
    isFetchingMore = true;
    _currentPage++;
    update();

    try {
      final result = await PastOrderRepository.getPastOrders(
        page: _currentPage,
        limit: _limit,
      );
      if (result != null) {
        orderList.addAll(result.data);
        _totalPage = result.pagination.totalPage;
      }
    } catch (_) {
      _currentPage--;
      /*Get.snackbar("Error", "Failed to load more orders",
          snackPosition: SnackPosition.BOTTOM);*/
    } finally {
      isFetchingMore = false;
      update();
    }
  }

  Future<void> fetchAndShowDetail(BuildContext context, String orderId) async {
    // ── Show loading indicator on the list screen (not sheet yet) ──
    isLoadingDetail = true;
    selectedOrder = null;
    update();

    try {
      final result = await PastOrderRepository.getOrderById(orderId);
      if (result != null) {
        selectedOrder = result;
        isLoadingDetail = false;
        update();
        // ── Open sheet ONLY after data is ready ──
        bookingDetailsShow(context);
      } else {
        isLoadingDetail = false;
        update();
        Get.snackbar("Error", "Failed to load order details",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (_) {
      isLoadingDetail = false;
      update();
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}