import 'dart:io';
import 'package:flutter/material.dart';
import '../../Widget/UploadSectionWidget.dart';
import '../Model/UploadedFileModel.dart';
import '../controller/SingleUploadController.dart';

class CulinaryCertPage extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(List<UploadedFileModel>) onFilesSelected;

  const CulinaryCertPage({
    super.key,
    required this.onContinue,
    required this.onFilesSelected,
    this.onBack,
    this.onSkip,
  });

  @override
  State<CulinaryCertPage> createState() => _CulinaryCertPageState();
}

class _CulinaryCertPageState extends State<CulinaryCertPage> {
  final _ctrl = SingleUploadController();
  bool _showAddMore = false;

  static const _textPrimary = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8A8A8A);
  static const _border = Color(0xFFE0E0E0);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => BaseDocPage(
        currentStep: 3,
        totalSteps: 5,
        title: 'Additional Culinary Certifications (Optional)',
        description: 'Showcase your extra culinary qualifications to strengthen your profile.',
        onBack: widget.onBack,
        trailingAction: TextButton(
          onPressed: widget.onSkip,
          child: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ),
        onContinue: () {
          widget.onFilesSelected(_ctrl.files);
          widget.onContinue();
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (_ctrl.files.isNotEmpty) ...[
              const Text(
                'File',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              ..._ctrl.files.map((f) => _fileTile(f)),

              const SizedBox(height: 8),

              if (!_showAddMore)
                GestureDetector(
                  onTap: () => setState(() => _showAddMore = true),
                  child: Row(
                    children: const [
                      Icon(Icons.add, size: 16, color: _textPrimary),
                      SizedBox(width: 6),
                      Text(
                        'Add new file',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),
            ],

            if (_ctrl.files.isEmpty || _showAddMore)
              UploadSectionWidget(
                files: const [],
                onPick: () async {
                  await _ctrl.pickFile();
                  setState(() => _showAddMore = false);
                },
                onDelete: _ctrl.removeFile,
              ),
          ],
        ),
      ),
    );
  }

  Widget _fileTile(UploadedFileModel file) {
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
              : Image.file(
            File(file.path),
            width: 34,
            height: 34,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              file.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              file.size,
              style: const TextStyle(fontSize: 11, color: _textMuted),
            ),
          ]),
        ),
        IconButton(
          onPressed: () => _ctrl.removeFile(file),
          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: _textMuted),
          style: IconButton.styleFrom(minimumSize: const Size(32, 32)),
        ),
      ]),
    );
  }
}