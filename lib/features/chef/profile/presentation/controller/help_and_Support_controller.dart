import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../config/api/api_end_point.dart';
import '../../../../../../services/api/api_service.dart';

class HelpSupportController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<File> selectedFiles = [];
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      selectedFiles.add(File(file.path));
      update();
    }
  }

  void deleteFile(int index) {
    selectedFiles.removeAt(index);
    update();
  }

  Future<void> submitSupport() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        "Validation",
        "Please enter an issue title",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
      return;
    }
    if (description.isEmpty) {
      Get.snackbar(
        "Validation",
        "Please enter a description",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
      return;
    }

    isLoading = true;
    update();

    try {
      final List<Map<String, String>> files = selectedFiles
          .map((f) => {"name": "image", "image": f.path})
          .toList();

      final response = await ApiService.multipartImage(
        ApiEndPoint.baseUrl + ApiEndPoint.support.replaceFirst('/', ''),
        method: "POST",
        body: {
          "reason": title,
          "description": description,
        },
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearForm();
        Navigator.pop(Get.context!);
        Get.snackbar("Message", "Support submitted successfully",backgroundColor: Colors.green,colorText: Colors.white);

      } else {
        Get.snackbar("Message", "$e");


      }
    } catch (e) {
      Get.snackbar(
        "❌ Error",
        "Unexpected error: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedFiles.clear();
    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}