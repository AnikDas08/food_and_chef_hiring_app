import 'package:flutter/material.dart';
import '../../Widget/UploadSectionWidget.dart';
import '../Model/UploadedFileModel.dart';
import '../controller/SingleUploadController.dart';

class ProofOfAddressPage extends StatefulWidget {
  final VoidCallback? onSkip;
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final void Function(List<UploadedFileModel>) onFilesSelected;

  const ProofOfAddressPage({
    super.key,
    required this.onContinue,
    required this.onFilesSelected,
    this.onBack,
    this.onSkip,
  });

  @override
  State<ProofOfAddressPage> createState() => _ProofOfAddressPageState();
}

class _ProofOfAddressPageState extends State<ProofOfAddressPage> {
  final _ctrl = SingleUploadController();

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
        currentStep: 1,
        totalSteps: 5,        // ← এখানে
        title: 'Proof of Address',
        onSkip: widget.onSkip,
        description: 'Submit a recent utility bill or bank statement to confirm your current address.',
        onBack: widget.onBack,
        onContinue: () {
          widget.onFilesSelected(_ctrl.files);
          widget.onContinue();
        },
        body: UploadSectionWidget(
          files: _ctrl.files,
          onPick: _ctrl.pickFile,
          onDelete: _ctrl.removeFile,
        ),
      ),
    );
  }
}