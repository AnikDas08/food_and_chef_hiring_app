import 'package:get/get.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../services/api/api_service.dart';

class CuisineModel {
  final String id;
  final String name;
  final String image;

  CuisineModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) => CuisineModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}

class CafeCookingExpertiseController extends GetxController {
  final RxList<CuisineModel> allCuisines = <CuisineModel>[].obs;
  final RxList<String> selectedIds = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool dropdownOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCuisines();
  }

  Future<void> fetchCuisines() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndPoint.cuisine);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List list = data['data'] ?? [];
          allCuisines.value = list.map((e) => CuisineModel.fromJson(e)).toList();
        } else {
          Get.snackbar("Message", data['message'] ?? "Failed to load cuisines");
        }
      } else {
        Get.snackbar("Message", "Something went wrong. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Message", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCuisine(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  bool isSelected(String id) => selectedIds.contains(id);

  void toggleDropdown() => dropdownOpen.value = !dropdownOpen.value;

  List<CuisineModel> get selectedCuisines =>
      allCuisines.where((c) => selectedIds.contains(c.id)).toList();

  void onContinue() {
    if (selectedIds.isEmpty) {
      Get.snackbar("Warning", "Please select at least one cuisine");
      return;
    }
    Get.back(result: {'cuisines': selectedIds.toList()});
  }
}