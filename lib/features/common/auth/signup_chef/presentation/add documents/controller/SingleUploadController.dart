import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/UploadedFileModel.dart';

class SingleUploadController extends ChangeNotifier {
  final List<UploadedFileModel> _files = [];
  List<UploadedFileModel> get files => List.unmodifiable(_files);

  Future<void> pickFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.length();
      _files.add(UploadedFileModel(
        name: picked.name,
        size: '${(bytes / 1024).toStringAsFixed(0)} kb',
        type: FileType.image,
        path: picked.path,
      ));
      notifyListeners();
    }
  }

  void removeFile(UploadedFileModel file) {
    _files.remove(file);
    notifyListeners();
  }
}