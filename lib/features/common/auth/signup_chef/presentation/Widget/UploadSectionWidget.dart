import 'dart:io';
import 'package:flutter/material.dart';
import '../add documents/Model/UploadedFileModel.dart';

class UploadSectionWidget extends StatelessWidget {
  final String? label;
  final bool isRequired;
  final List<UploadedFileModel> files;
  final VoidCallback onPick;
  final void Function(UploadedFileModel) onDelete;
  final VoidCallback? onEdit;

  static const _textPrimary = Color(0xFF1A1A1A);
  static const _textMuted   = Color(0xFF8A8A8A);
  static const _border      = Color(0xFFE0E0E0);
  static const _uploadBg    = Color(0xFFF9F9F9);
  static const _required    = Color(0xFFE53935);

  const UploadSectionWidget({
    super.key,
    this.label,
    this.isRequired = false,
    required this.files,
    required this.onPick,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,          // ✅ overflow fix
      children: [
        if (label != null) ...[
          Row(children: [
            Text(label!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary)),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _required)),
          ]),
          const SizedBox(height: 10),
        ],
        if (files.isNotEmpty)
          _fileTile(files.first)
        else
          GestureDetector(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: _uploadBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,    // ✅ overflow fix
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.cloud_upload_outlined,
                        size: 20, color: _textMuted),
                  ),
                  const SizedBox(height: 12),
                  const Text('Drag & Drop file(s) to upload',
                      style: TextStyle(fontSize: 13, color: _textMuted)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _fileTile(UploadedFileModel file) {
    final isPdf = file.type == FileType.pdf;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          // ✅ thumbnail
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

          // ✅ Expanded — text overflow ঠেকায়
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  file.name,
                  maxLines: 1,                         // ✅ fix
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textPrimary),
                ),
                Text(
                  file.size,
                  maxLines: 1,                         // ✅ fix
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, color: _textMuted),
                ),
              ],
            ),
          ),

          // edit button
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined,
                  size: 18, color: _textMuted),
              style: IconButton.styleFrom(
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),

          // delete button
          IconButton(
            onPressed: () => onDelete(file),
            icon: const Icon(Icons.delete_outline_rounded,
                size: 18, color: _textMuted),
            style: IconButton.styleFrom(
                minimumSize: const Size(32, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────
//  BaseDocPage
// ─────────────────────────────────────────────
class BaseDocPage extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final String description;
  final Widget body;
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final Widget? trailingAction;
  final VoidCallback? onSkip;

  static const _textPrimary   = Color(0xFF1A1A1A);
  static const _border        = Color(0xFFE0E0E0);
  static const _securityGreen = Color(0xFF4CAF50);
  static const _bg            = Color(0xFFFFFFFF);

  const BaseDocPage({
    super.key,
    required this.currentStep,
    required this.title,
    required this.description,
    required this.body,
    required this.onContinue,
    this.onBack,
    this.totalSteps = 7,
    this.trailingAction,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── top bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(children: [
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: _textPrimary),
                ),
                const Spacer(),
                if (trailingAction != null) trailingAction!,
              ]),
            ),

            // ── progress bar ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: List.generate(totalSteps, (i) => Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i <= currentStep ? _textPrimary : _border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 28),
                    Text(title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                          letterSpacing: -0.3,
                        )),
                    const SizedBox(height: 8),
                    Text(description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8A8A8A),
                          height: 1.5,
                        )),
                    const SizedBox(height: 24),

                    body,                                  // ← page content

                    const SizedBox(height: 20),

                    // security notice
                    Row(children: const [
                      Icon(Icons.shield_outlined,
                          size: 14, color: _securityGreen),
                      SizedBox(width: 6),
                      Flexible(                           // ✅ fix — long text wraps
                        child: Text(
                          'Your documents are encrypted and kept private.',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF2F8328)),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── bottom buttons ───────────────────────
            Container(
              width: double.infinity,
              // ✅ keyboard-aware bottom padding
              padding: EdgeInsets.fromLTRB(
                20, 12, 20,
                28 + MediaQuery.of(context).viewInsets.bottom,
              ),
              color: _bg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _textPrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    ),
                    child: const Text('Continue'),
                  ),
                  if (onSkip != null) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onSkip,
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text('Skip',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8A8A8A))),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}