// lib/features/customer/cart/presentation/controller/tax_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/utils/app_utils.dart';
import '../../../../../services/api/api_service.dart';
import '../../data/tax_model.dart';

class TaxController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  TaxModel? businessTax;
  TaxModel? personalTax;
  bool isLoading = false;
  bool isSubmitting = false;

  // ── Form Controllers ───────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final postalController = TextEditingController();
  final taxIdController = TextEditingController();
  bool isDefault = false;

  @override
  void onClose() {
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    postalController.dispose();
    taxIdController.dispose();
    super.onClose();
  }

  // ── Fetch Tax Details ──────────────────────────────────────────────────────
  Future<void> fetchTaxDetails() async {
    isLoading = true;
    update();
    try {
      final response = await ApiService.get("tax-details");
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        final list = data.map((e) => TaxModel.fromJson(e)).toList();
        businessTax = list.firstWhereOrNull(
                (e) => e.organization.toLowerCase() == 'business');
        personalTax = list.firstWhereOrNull(
                (e) => e.organization.toLowerCase() == 'personal');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  // ── Pre-fill form for editing ──────────────────────────────────────────────
  void loadForEdit(TaxModel tax) {
    nameController.text = tax.name;
    streetController.text = tax.streetAddress;
    cityController.text = tax.city;
    postalController.text = tax.postalCode;
    taxIdController.text = tax.taxId;
    isDefault = tax.isDefault;
    update();
  }

  // ── Clear form ─────────────────────────────────────────────────────────────
  void clearForm() {
    nameController.clear();
    streetController.clear();
    cityController.clear();
    postalController.clear();
    taxIdController.clear();
    isDefault = false;
    update();
  }

  void onChangeDefault(dynamic val) {
    isDefault = val ?? false;
    update();
  }

  // ── POST (create) ──────────────────────────────────────────────────────────
  Future<void> submitTax(String organization) async {
    isSubmitting = true;
    update();
    try {
      final body = {
        'orgnaization': organization,
        'name': nameController.text.trim(),
        'street_address': streetController.text.trim(),
        'city': cityController.text.trim(),
        'postal_code': postalController.text.trim(),
        'tax_id': taxIdController.text.trim(),
        'is_default': isDefault,
      };
      final response = await ApiService.post("tax-details", body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTaxDetails();
        Get.back();
        Utils.successSnackBar('Success', 'Tax details saved successfully');
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Failed');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isSubmitting = false;
      update();
    }
  }

  // ── PATCH (update) ─────────────────────────────────────────────────────────
  Future<void> updateTax(String id, String organization) async {
    isSubmitting = true;
    update();
    try {
      final body = {
        'orgnaization': organization,
        'name': nameController.text.trim(),
        'street_address': streetController.text.trim(),
        'city': cityController.text.trim(),
        'postal_code': postalController.text.trim(),
        'tax_id': taxIdController.text.trim(),
        'is_default': isDefault,
      };
      final response =
      await ApiService.patch("tax-details/$id", body: body);
      if (response.statusCode == 200) {
        await fetchTaxDetails();
        await Utils.successSnackBar('Success', 'Tax details updated successfully');
        //Get.back();
      } else {
        Utils.errorSnackBar('Error', response.data['message'] ?? 'Failed');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isSubmitting = false;
      update();
    }
  }
}