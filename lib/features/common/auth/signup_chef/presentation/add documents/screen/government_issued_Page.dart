import 'package:flutter/material.dart';
import '../../Widget/UploadSectionWidget.dart';
import '../Model/UploadedFileModel.dart';
import '../controller/Government_Issued_contrller.dart';

class GovernmentIssuedPage extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(List<UploadedFileModel> front, List<UploadedFileModel> back) onFilesSelected;

  const GovernmentIssuedPage({
    super.key,
    required this.onContinue,
    required this.onFilesSelected,
    this.onBack,
    this.onSkip,
  });

  @override
  State<GovernmentIssuedPage> createState() => _GovernmentIssuedPageState();
}

class _GovernmentIssuedPageState extends State<GovernmentIssuedPage> {
  final _ctrl = GovernmentIssuedController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => BaseDocPage(
        currentStep: 0,
        totalSteps: 5,
        title: 'Government-issued Photo ID',
        description: "Upload a valid passport or driver's license to confirm your identity.",
        onBack: widget.onBack,
        onSkip: widget.onSkip,
        onContinue: () {
          widget.onFilesSelected(_ctrl.frontFiles, _ctrl.backFiles);
          widget.onContinue();
        },
        body: Column(children: [
          UploadSectionWidget(
            label: 'ID Front',
            isRequired: true,
            files: _ctrl.frontFiles,
            onPick: _ctrl.pickFrontFile,
            onDelete: _ctrl.removeFrontFile,
            onEdit: _ctrl.frontFiles.isNotEmpty
                ? () => _ctrl.replaceFrontFile(_ctrl.frontFiles.first)
                : null,
          ),
          const SizedBox(height: 20),
          UploadSectionWidget(
            label: 'ID Back',
            isRequired: true,
            files: _ctrl.backFiles,
            onPick: _ctrl.pickBackFile,
            onDelete: _ctrl.removeBackFile,
            onEdit: _ctrl.backFiles.isNotEmpty
                ? () => _ctrl.replaceBackFile(_ctrl.backFiles.first)
                : null,
          ),
        ]),
      ),
    );
  }
}