enum FileType { pdf, image }

class UploadedFileModel {
  final String name;
  final String size;
  final FileType type;
  final String path;

  UploadedFileModel({
    required this.name,
    required this.size,
    required this.type,
    required this.path,
  });
}






