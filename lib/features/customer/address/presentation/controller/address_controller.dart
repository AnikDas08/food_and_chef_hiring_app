// lib/features/address/controller/address_controller.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_untitled/utils/app_utils.dart';
import 'package:new_untitled/utils/constants/app_string.dart';

import '../../data/address_model.dart';
import '../../repsozitory/address_repository.dart';

class AddressController extends GetxController {
  // ── Address Type ──────────────────────────────────────────
  List<String> addressTypeList = ["Office", "Home", "Work", "Other"];
  bool isDefault = false;

  AddressModel? editingAddress;      // currently loaded address for edit
  bool isLoadingEdit = false;        // loading single address

  // ── Form Controllers ──────────────────────────────────────
  TextEditingController addressLabelController =
  TextEditingController(text: "Home");
  TextEditingController addressController = TextEditingController();
  TextEditingController detailsAddressController = TextEditingController();
  TextEditingController additionalAddressController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // ── Location ──────────────────────────────────────────────
  double? selectedLatitude;
  double? selectedLongitude;

  // ── Address Suggestions ───────────────────────────────────
  List<Map<String, dynamic>> addressSuggestions = [];
  List<Map<String, dynamic>> additionalSuggestions = [];
  bool isLoadingSuggestions = false;
  bool isLoadingAdditionalSuggestions = false;
  bool showAddressSuggestions = false;
  bool showAdditionalSuggestions = false;

  // ── Pagination (Address List) ─────────────────────────────
  List<AddressModel> addressList = [];
  int _currentPage = 1;
  int _totalPage = 1;
  final int _limit = 10;
  bool isLoading = false;
  bool isFetchingMore = false;
  bool isDeleting = false;
  bool isSubmitting = false;

  // ── Scroll ────────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _listenScroll();
    fetchAddresses();
    _listenAddressField();
    _listenAdditionalField();
  }

  @override
  void onClose() {
    scrollController.dispose();
    addressLabelController.dispose();
    addressController.dispose();
    detailsAddressController.dispose();
    additionalAddressController.dispose();
    ownerNameController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  // ══════════════════════════════════════════════════════════
  //  SCROLL + PAGINATION
  // ══════════════════════════════════════════════════════════

  void _listenScroll() {
    scrollController.addListener(() {
      final pos = scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        loadMoreAddresses();
      }
    });
  }

  Future<void> fetchAddresses() async {
    if (isLoading) return;
    isLoading = true;
    _currentPage = 1;
    addressList.clear();
    update();
    try {
      final result = await AddressRepository.getAddresses(
          page: _currentPage, limit: _limit);
      if (result != null) {
        addressList = result.data;
        _totalPage = result.pagination.totalPage;
      }
    } catch (_) {
      _showError("Failed to load addresses");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> loadMoreAddresses() async {
    if (isFetchingMore || isLoading || _currentPage >= _totalPage) return;
    isFetchingMore = true;
    _currentPage++;
    update();
    try {
      final result = await AddressRepository.getAddresses(
          page: _currentPage, limit: _limit);
      if (result != null) {
        addressList.addAll(result.data);
        _totalPage = result.pagination.totalPage;
      }
    } catch (_) {
      _currentPage--;
      _showError("Failed to load more addresses");
    } finally {
      isFetchingMore = false;
      update();
    }
  }

  bool get hasMorePages => _currentPage < _totalPage;

  // ══════════════════════════════════════════════════════════
  //  LOCATION — called from ShowGoogleMap widget
  // ══════════════════════════════════════════════════════════

  /// Called when user taps the map or uses current location
  void onLocationSelected(LatLng latLng,
      {String? area, String? details}) {
    selectedLatitude = latLng.latitude;
    selectedLongitude = latLng.longitude;
    if (area != null) addressController.text = area;
    if (details != null) detailsAddressController.text = details;
    showAddressSuggestions = false;
    update();
  }

  /// Call this when navigating to EditAddressScreen.
  /// Accepts the address object passed via Get.arguments.
  Future<void> loadAddressForEdit(AddressModel address) async {
    isLoadingEdit = true;
    editingAddress = null;
    _clearForm();
    update();

    try {
      // Fetch fresh data from API using the ID
      final fresh = await AddressRepository.getAddressById(address.id);
      final data = fresh ?? address; // fallback to passed object if fetch fails

      editingAddress = data;

      // ── Pre-fill all form fields ──
      addressLabelController.text = data.label;
      addressController.text = data.address;
      detailsAddressController.text = data.detailsAddress;
      additionalAddressController.text = data.additionalDetails;
      ownerNameController.text = data.ownerName;
      phoneNumberController.text = data.phoneNumber;
      isDefault = data.isDefault;
      selectedLatitude = data.latitude;
      selectedLongitude = data.longitude;

    } catch (_) {
      _showError("Failed to load address details");
    } finally {
      isLoadingEdit = false;
      update();
    }
  }

  /// Submit edited address via PUT
  Future<void> updateAddress() async {
    if (editingAddress == null) return;

    if (addressController.text.trim().isEmpty) {
      _showError("Please enter an address");
      return;
    }
    if (selectedLatitude == null || selectedLongitude == null) {
      _showError("Please select a location on the map");
      return;
    }

    isSubmitting = true;
    update();

    try {
      final body = <String, dynamic>{
        "label": addressLabelController.text.trim(),
        "address": addressController.text.trim(),
        "details_address": detailsAddressController.text.trim(),
        "status": "active",
        "is_default": isDefault,
        "latitude": selectedLatitude,
        "longitude": selectedLongitude,
      };

      // Optional fields — only send if not empty
      final additional = additionalAddressController.text.trim();
      if (additional.isNotEmpty) body["additional_details"] = additional;

      final owner = ownerNameController.text.trim();
      if (owner.isNotEmpty) body["owner_name"] = owner;

      final phone = phoneNumberController.text.trim();
      if (phone.isNotEmpty) body["phone_number"] = phone;

      final result = await AddressRepository.updateAddress(
          editingAddress!.id, body);

      if (result != null) {
        // Update the item in the local list so list screen refreshes
        final idx = addressList.indexWhere((e) => e.id == editingAddress!.id);
        if (idx != -1) addressList[idx] = result;
        //_clearForm();
        Get.back();
        Utils.successSnackBar("Successful", "Successfully update your location");
      } else {
        _showError("Failed to update address");
      }
    } catch (_) {
      _showError("Something went wrong");
    } finally {
      isSubmitting = false;
      update();
    }
  }

  void _clearForm() {
    addressLabelController.text = "Home";
    addressController.clear();
    detailsAddressController.clear();
    additionalAddressController.clear();
    ownerNameController.clear();
    phoneNumberController.clear();
    selectedLatitude = null;
    selectedLongitude = null;
    isDefault = false;
    editingAddress = null;
  }

  /// Called when ShowGoogleMapController resolves a current-location address
  // lib/features/address/controller/address_controller.dart

  void onCurrentLocationResolved({
    required double lat,
    required double lng,
    required String area,
    required String details,
  }) {
    selectedLatitude = lat;
    selectedLongitude = lng;

    // Only overwrite fields if we got actual data back
    if (area.isNotEmpty) addressController.text = area;
    if (details.isNotEmpty) detailsAddressController.text = details;

    showAddressSuggestions = false;
    update();
  }

  // ══════════════════════════════════════════════════════════
  //  PLACES AUTOCOMPLETE — address field
  // ══════════════════════════════════════════════════════════

  void _listenAddressField() {
    addressController.addListener(() {
      final q = addressController.text.trim();
      if (q.length >= 2) {
        _fetchAddressSuggestions(q);
      } else {
        addressSuggestions.clear();
        showAddressSuggestions = false;
        update();
      }
    });
  }

  Future<void> _fetchAddressSuggestions(String query) async {
    isLoadingSuggestions = true;
    showAddressSuggestions = true;
    update();
    try {
      addressSuggestions = await AddressRepository.getPlaceSuggestions(query);
    } catch (_) {
      addressSuggestions = [];
    } finally {
      isLoadingSuggestions = false;
      update();
    }
  }

  /// User picks a suggestion from the address field
  Future<void> onAddressSuggestionSelected(
      Map<String, dynamic> suggestion) async {
    final placeId = suggestion['place_id'] as String?;
    if (placeId == null) return;

    // Fill address field with the main text (area name only)
    addressController.text = suggestion['main_text'] ?? suggestion['description'] ?? '';
    showAddressSuggestions = false;
    update();

    // Fetch lat/lng + details for this place
    try {
      final detail = await AddressRepository.getPlaceDetail(placeId);
      if (detail != null) {
        selectedLatitude = detail['lat'];
        selectedLongitude = detail['lng'];
        detailsAddressController.text = detail['details'] ?? '';
      }
    } catch (_) {}
    update();
  }

  // ══════════════════════════════════════════════════════════
  //  PLACES AUTOCOMPLETE — additional address field (no lat/lng)
  // ══════════════════════════════════════════════════════════

  void _listenAdditionalField() {
    additionalAddressController.addListener(() {
      final q = additionalAddressController.text.trim();
      if (q.length >= 2) {
        _fetchAdditionalSuggestions(q);
      } else {
        additionalSuggestions.clear();
        showAdditionalSuggestions = false;
        update();
      }
    });
  }

  Future<void> _fetchAdditionalSuggestions(String query) async {
    isLoadingAdditionalSuggestions = true;
    showAdditionalSuggestions = true;
    update();
    try {
      additionalSuggestions =
      await AddressRepository.getPlaceSuggestions(query);
    } catch (_) {
      additionalSuggestions = [];
    } finally {
      isLoadingAdditionalSuggestions = false;
      update();
    }
  }

  /// User picks a suggestion from the additional address field (no lat/lng)
  void onAdditionalSuggestionSelected(Map<String, dynamic> suggestion) {
    // Build a 3-part label from the suggestion
    final parts = _buildThreePartLabel(suggestion);
    additionalAddressController.text = parts;
    additionalSuggestions.clear();
    showAdditionalSuggestions = false;
    update();
  }

  /// Builds a 3-field display string from a place suggestion.
  /// Uses: main_text, secondary_text parts — fills up to 3 meaningful segments.
  String _buildThreePartLabel(Map<String, dynamic> s) {
    final main = (s['main_text'] ?? '').toString().trim();
    final secondary = (s['secondary_text'] ?? '').toString().trim();

    // Split secondary by comma to get more granular parts
    final parts = secondary.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    List<String> result = [];
    if (main.isNotEmpty) result.add(main);
    for (final p in parts) {
      if (result.length >= 3) break;
      if (!result.contains(p)) result.add(p);
    }

    return result.join(', ');
  }

  // ══════════════════════════════════════════════════════════
  //  FORM ACTIONS
  // ══════════════════════════════════════════════════════════

  void onChangeDefaultAddress(dynamic v) {
    isDefault = !isDefault;
    update();
  }

  void onChangeAddressType(int value) {
    addressLabelController.text = addressTypeList[value];
    update();
    Get.back();
  }

  Future<void> submitAddress() async {
    if (addressController.text.trim().isEmpty) {
      _showError("Please enter an address");
      return;
    }
    if (selectedLatitude == null || selectedLongitude == null) {
      _showError("Please select a location on the map");
      return;
    }

    isSubmitting = true;
    update();

    try {
      final body = <String, dynamic>{
        "label": addressLabelController.text.trim(),
        "address": addressController.text.trim(),
        "details_address": detailsAddressController.text.trim(),
        "status": "active",
        "is_default": isDefault,
        "latitude": selectedLatitude,
        "longitude": selectedLongitude,
      };

      // Only send additional_details if not empty
      final additional = additionalAddressController.text.trim();
      if (additional.isNotEmpty) {
        body["additional_details"] = additional;
      }

      // Only send owner_name if not empty
      final owner = ownerNameController.text.trim();
      if (owner.isNotEmpty) body["owner_name"] = owner;

      // Only send phone_number if not empty
      final phone = phoneNumberController.text.trim();
      if (phone.isNotEmpty) body["phone_number"] = phone;

      final result = await AddressRepository.createAddress(body);
      if (result != null) {
        _resetForm();
        fetchAddresses();
        Get.back();
        Get.snackbar("Success", "Address added successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        _showError("Failed to add address");
      }
    } catch (_) {
      _showError("Something went wrong");
    } finally {
      isSubmitting = false;
      update();
    }
  }

  void _resetForm() {
    addressLabelController.text = "Home";
    addressController.clear();
    detailsAddressController.clear();
    additionalAddressController.clear();
    ownerNameController.clear();
    phoneNumberController.clear();
    selectedLatitude = null;
    selectedLongitude = null;
    isDefault = false;
  }

  // ══════════════════════════════════════════════════════════
  //  DELETE
  // ══════════════════════════════════════════════════════════

  Future<void> deleteAddress(String id) async {
    isDeleting = true;
    update();
    try {
      final success = await AddressRepository.deleteAddress(id);
      if (success) {
        addressList.removeWhere((e) => e.id == id);
        Get.snackbar("Success", "Address deleted successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        _showError("Failed to delete address");
      }
    } catch (_) {
      _showError("Something went wrong");
    } finally {
      isDeleting = false;
      update();
    }
  }

  // ══════════════════════════════════════════════════════════
  //  HELPERS
  // ══════════════════════════════════════════════════════════

  void _showError(String msg) {
    Get.snackbar("error", msg.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}