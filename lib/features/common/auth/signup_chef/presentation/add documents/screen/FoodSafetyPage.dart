import 'package:flutter/cupertino.dart';
import '../../Widget/UploadSectionWidget.dart';
import '../Model/UploadedFileModel.dart';
import '../controller/SingleUploadController.dart';

class FoodSafetyPage extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final void Function(List<UploadedFileModel>) onFilesSelected;

  const FoodSafetyPage({
    super.key,
    required this.onContinue,
    required this.onFilesSelected,
    this.onBack,
    this.onSkip,
  });

  @override
  State<FoodSafetyPage> createState() => _FoodSafetyPageState();
}

class _FoodSafetyPageState extends State<FoodSafetyPage> {
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
        currentStep: 2,
        totalSteps: 5,
        title: 'Food Safety Certification',
        description: "Upload your NYC Food Handler's License or equivalent certification.",
        onBack: widget.onBack,
        onSkip: widget.onSkip,
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