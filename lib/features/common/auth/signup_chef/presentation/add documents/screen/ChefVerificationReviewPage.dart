import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../component/image/common_image.dart';
import '../../../../../../../utils/constants/app_icons.dart';
import '../Model/UploadedFileModel.dart';

class ChefVerificationReviewPage extends StatefulWidget {
  final List<UploadedFileModel> govIdFront;
  final List<UploadedFileModel> govIdBack;
  final List<UploadedFileModel> proofOfAddress;
  final List<UploadedFileModel> nonSexualOffender;
  final List<UploadedFileModel> criminalBackground;
  final List<UploadedFileModel> foodSafety;
  final List<UploadedFileModel> culinaryCerts;
  final Future<void> Function() onSubmit;
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
  State<ChefVerificationReviewPage> createState() =>
      _ChefVerificationReviewPageState();
}

class _ChefVerificationReviewPageState
    extends State<ChefVerificationReviewPage> {
  static const _textPrimary = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8A8A8A);
  static const _border = Color(0xFFE0E0E0);
  static const _bg = Color(0xFFFFFFFF);
  static const _red = Color(0xFFE53935);

  bool _isLoading = false;
  bool _showErrors = false;

  late List<UploadedFileModel> _govIdFront;
  late List<UploadedFileModel> _govIdBack;
  late List<UploadedFileModel> _proofOfAddress;
  late List<UploadedFileModel> _foodSafety;
  late List<UploadedFileModel> _culinaryCerts;

  @override
  void initState() {
    super.initState();
    _govIdFront = List.from(widget.govIdFront);
    _govIdBack = List.from(widget.govIdBack);
    _proofOfAddress = List.from(widget.proofOfAddress);
    _foodSafety = List.from(widget.foodSafety);
    _culinaryCerts = List.from(widget.culinaryCerts);
  }

  bool get _allRequiredFilled =>
      _govIdFront.isNotEmpty &&
          _govIdBack.isNotEmpty &&
          _proofOfAddress.isNotEmpty &&
          _foodSafety.isNotEmpty;

  void _deleteFile(List<UploadedFileModel> list, UploadedFileModel file) {
    setState(() => list.remove(file));
  }

  Future<void> _editFile(
      List<UploadedFileModel> list, UploadedFileModel file) async {
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

  Future<void> _handleSubmit() async {
    if (!_allRequiredFilled) {
      setState(() => _showErrors = true);

      final missing = <String>[];
      if (_govIdFront.isEmpty) missing.add('Gov ID Front');
      if (_govIdBack.isEmpty) missing.add('Gov ID Back');
      if (_proofOfAddress.isEmpty) missing.add('Proof of Address');
      if (_foodSafety.isEmpty) missing.add('Food Safety Cert');

    }

    setState(() => _isLoading = true);

    try {
      await widget.onSubmit();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final sections = [
      _DocSection('Government-issued Photo ID (Front)', _govIdFront,
          required: true),

      _DocSection('Government-issued Photo ID (Back)', _govIdBack,
          required: true),

      _DocSection('Proof of Address', _proofOfAddress, required: true),

      _DocSection('Food Safety Certification', _foodSafety, required: true),

      _DocSection(
          'Additional Culinary Certifications', _culinaryCerts,
          required: false),

    ];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : (widget.onBack ?? () => Navigator.of(context).maybePop()),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? const Color(0xffE0E0E0)
                          : const Color(0xffF6F6F6),
                      shape: BoxShape.circle,
                    ),
                    child: CommonImage(
                      imageSrc: AppIcons.backIcon,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Chef verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary),
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
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _textPrimary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _textPrimary,
                disabledForegroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : const Text(
                'Continue',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSection(_DocSection section) {
    final isEmpty = section.files.isEmpty;
    final showError = _showErrors && section.required && isEmpty;

    if (!section.required && isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              section.title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary),
            ),
            if (section.required)
              const Text(
                ' *',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _red),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (!isEmpty)
          ...section.files.map((f) => _fileTile(section.files, f))
        else
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: showError ? _red : const Color(0xFFFFCDD2),
                width: showError ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.upload_file_outlined,
                    size: 18,
                    color: showError ? _red : const Color(0xFFEF9A9A)),
                const SizedBox(width: 8),
                Text(
                  maxLines: 5,
                  showError ? 'If you don’t submit all the required documents,\nYour profile will not be visible to customers.' : 'If you don’t submit all the required documents,\nYour profile will not be visible to customers.',
                  style: TextStyle(
                    fontSize: 13,
                    color: showError ? _red : const Color(0xFFEF9A9A),
                    fontWeight: showError
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
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
          child: isPdf
              ? Container(
            width: 34,
            height: 34,
            color: const Color(0xFFFFEBEE),
            child: Icon(Icons.picture_as_pdf_rounded,
                size: 17, color: Colors.red[400]),
          )
              : Image.file(File(file.path),
              width: 34, height: 34, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(file.name,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary),
                overflow: TextOverflow.ellipsis),
            Text(file.size,
                style: const TextStyle(fontSize: 11, color: _textMuted)),
          ]),
        ),
        IconButton(
          onPressed: _isLoading ? null : () => _editFile(list, file),
          icon: const Icon(Icons.edit_outlined, size: 18, color: _textMuted),
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
        IconButton(
          onPressed: _isLoading ? null : () => _deleteFile(list, file),
          icon: const Icon(Icons.delete_outline_rounded,
              size: 18, color: _textMuted),
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
      ]),
    );
  }
}

class _DocSection {
  final String title;
  final List<UploadedFileModel> files;
  final bool required;
  _DocSection(this.title, this.files, {this.required = true});
}