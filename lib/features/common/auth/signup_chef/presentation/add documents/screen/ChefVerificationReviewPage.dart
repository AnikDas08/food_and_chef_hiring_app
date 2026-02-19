import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/UploadedFileModel.dart';

class ChefVerificationReviewPage extends StatefulWidget {
  final List<UploadedFileModel> govIdFront;
  final List<UploadedFileModel> govIdBack;
  final List<UploadedFileModel> proofOfAddress;
  final List<UploadedFileModel> nonSexualOffender;
  final List<UploadedFileModel> criminalBackground;
  final List<UploadedFileModel> foodSafety;
  final List<UploadedFileModel> culinaryCerts;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;

  const ChefVerificationReviewPage({
    super.key,
    required this.govIdFront,
    required this.govIdBack,
    required this.proofOfAddress,
    required this.nonSexualOffender,
    required this.criminalBackground,
    required this.foodSafety,
    required this.culinaryCerts,
    required this.onSubmit,
    this.onBack,
  });

  @override
  State<ChefVerificationReviewPage> createState() => _ChefVerificationReviewPageState();
}

class _ChefVerificationReviewPageState extends State<ChefVerificationReviewPage> {
  static const _textPrimary = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8A8A8A);
  static const _border = Color(0xFFE0E0E0);
  static const _bg = Color(0xFFFFFFFF);

  late List<UploadedFileModel> _govIdFront;
  late List<UploadedFileModel> _govIdBack;
  late List<UploadedFileModel> _proofOfAddress;
  late List<UploadedFileModel> _nonSexualOffender;
  late List<UploadedFileModel> _criminalBackground;
  late List<UploadedFileModel> _foodSafety;
  late List<UploadedFileModel> _culinaryCerts;

  @override
  void initState() {
    super.initState();
    _govIdFront = List.from(widget.govIdFront);
    _govIdBack = List.from(widget.govIdBack);
    _proofOfAddress = List.from(widget.proofOfAddress);
    _nonSexualOffender = List.from(widget.nonSexualOffender);
    _criminalBackground = List.from(widget.criminalBackground);
    _foodSafety = List.from(widget.foodSafety);
    _culinaryCerts = List.from(widget.culinaryCerts);
  }

  // Delete
  void _deleteFile(List<UploadedFileModel> list, UploadedFileModel file) {
    setState(() => list.remove(file));
  }

  Future<void> _editFile(List<UploadedFileModel> list, UploadedFileModel file) async {
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
      setState(() {
        final index = list.indexOf(file);
        if (index != -1) list[index] = newFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _DocSection('Government-issued Photo ID (Front)', _govIdFront),
      _DocSection('Government-issued Photo ID (Back)', _govIdBack),
      _DocSection('Proof of Address', _proofOfAddress),
      _DocSection('Non-Sexual Offender Clearance', _nonSexualOffender),
      _DocSection('Criminal Background Check', _criminalBackground),
      _DocSection('Food Safety Certification', _foodSafety),
      _DocSection('Additional Culinary Certifications (Optional)', _culinaryCerts),
    ];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(children: [
              IconButton(
                onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _textPrimary),
              ),
              const Expanded(
                child: Text(
                  'Chef verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary),
                ),
              ),
              const SizedBox(width: 48),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...sections.map((s) => _buildSection(s)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            color: _bg,
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _textPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Text('Continue'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSection(_DocSection section) {
    if (section.files.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(section.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 10),
        ...section.files.map((f) => _fileTile(section.files, f)),
      ],
    );
  }

  Widget _fileTile(List<UploadedFileModel> list, UploadedFileModel file) {
    final isPdf = file.type == FileType.pdf;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isPdf || file.path == null
              ? Container(
            width: 34, height: 34,
            color: const Color(0xFFFFEBEE),
            child: Icon(Icons.picture_as_pdf_rounded, size: 17, color: Colors.red[400]),
          )
              : Image.file(File(file.path!), width: 34, height: 34, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(file.name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _textPrimary),
                overflow: TextOverflow.ellipsis),
            Text(file.size, style: const TextStyle(fontSize: 11, color: _textMuted)),
          ]),
        ),
        // Edit button
        IconButton(
          onPressed: () => _editFile(list, file),
          icon: const Icon(Icons.edit_outlined, size: 18, color: _textMuted),
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
        // Delete button
        IconButton(
          onPressed: () => _deleteFile(list, file),
          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: _textMuted),
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
      ]),
    );
  }
}

class _DocSection {
  final String title;
  final List<UploadedFileModel> files;
  _DocSection(this.title, this.files);
}