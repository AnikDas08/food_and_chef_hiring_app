import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class FileDownloadHelper {
  static Future<void> downloadAndOpen(String url, String fileName) async {
    try {
      // Show loading snackbar
      Get.snackbar(
        "Downloading",
        fileName,
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.transparent,
        progressIndicatorValueColor: const AlwaysStoppedAnimation(Color(0xffFD713F)),
        duration: const Duration(seconds: 30),
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: false,
      );

      // Build full URL if relative path
      final fullUrl = url.startsWith('http')
          ? url
          : 'YOUR_BASE_URL$url'; // replace with ApiEndPoint.imageUrl

      // Get save directory
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      final savePath = '${dir!.path}/$fileName';

      // Download
      await Dio().download(
        fullUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // optional: update progress
          }
        },
      );

      // Dismiss loading
      Get.closeAllSnackbars();
      Get.snackbar(
        "Downloaded",
        "Opening $fileName...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff4CAF50),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Open the file
      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        Get.snackbar(
          "Error",
          "Cannot open file: ${result.message}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.closeAllSnackbars();
      Get.snackbar(
        "Error",
        "Failed to download file",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}