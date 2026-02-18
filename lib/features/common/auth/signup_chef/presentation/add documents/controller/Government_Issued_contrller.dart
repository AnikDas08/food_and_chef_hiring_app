import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/UploadedFileModel.dart';

class GovernmentIssuedController extends ChangeNotifier {
  final List<UploadedFileModel> _frontFiles = [];
  final List<UploadedFileModel> _backFiles = [];

  List<UploadedFileModel> get frontFiles => List.unmodifiable(_frontFiles);
  List<UploadedFileModel> get backFiles => List.unmodifiable(_backFiles);

  Future<void> pickFrontFile() async => _pick(_frontFiles);
  Future<void> pickBackFile() async => _pick(_backFiles);

  void removeFrontFile(UploadedFileModel f) {
    _frontFiles.remove(f);
    notifyListeners();
  }

  void removeBackFile(UploadedFileModel f) {
    _backFiles.remove(f);
    notifyListeners();
  }

  // 👇 নতুন replace methods
  Future<void> replaceFrontFile(UploadedFileModel old) async => _replace(_frontFiles, old);
  Future<void> replaceBackFile(UploadedFileModel old) async => _replace(_backFiles, old);

  Future<void> _pick(List<UploadedFileModel> target) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await File(picked.path).length();
      target.add(UploadedFileModel(
        name: picked.name,
        size: '${(bytes / 1024).toStringAsFixed(0)} kb',
        type: FileType.image,
        path: picked.path,
      ));
      notifyListeners();
    }
  }

  Future<void> _replace(List<UploadedFileModel> target, UploadedFileModel old) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await File(picked.path).length();
      final newFile = UploadedFileModel(
        name: picked.name,
        size: '${(bytes / 1024).toStringAsFixed(0)} kb',
        type: FileType.image,
        path: picked.path,
      );
      final index = target.indexOf(old);
      if (index != -1) target[index] = newFile;
      notifyListeners();
    }
  }
}