import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../add documents/Model/UploadedFileModel.dart';
import '../add documents/screen/ChefVerificationReviewPage.dart';
import '../add documents/screen/CulinaryCertPage.dart';
import '../add documents/screen/FoodSafetyPage.dart';
import '../add documents/screen/ProofOfAddressPage.dart';
import '../add documents/screen/government_issued_Page.dart';
import '../controller/sign_up_chef_controller.dart';

class ChefDocFlow extends StatefulWidget {
  const ChefDocFlow({super.key});

  @override
  State<ChefDocFlow> createState() => _ChefDocFlowState();
}

class _ChefDocFlowState extends State<ChefDocFlow> {
  int _step = 0;

  List<UploadedFileModel> _govIdFront = [];
  List<UploadedFileModel> _govIdBack = [];
  List<UploadedFileModel> _proofOfAddress = [];
  List<UploadedFileModel> _foodSafety = [];
  List<UploadedFileModel> _culinary = [];

  void _next() => setState(() => _step++);

  void _back() {
    if (_step == 0) {
      Navigator.pop(Get.context!);
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return GovernmentIssuedPage(
          onBack: _back,
          onContinue: _next,
          onFilesSelected: (front, back) {
            _govIdFront = List.from(front);
            _govIdBack = List.from(back);
          },
        );

      case 1:
        return ProofOfAddressPage(
          onBack: _back,
          onContinue: _next,
          onFilesSelected: (files) => _proofOfAddress = List.from(files),
        );

      case 2:
        return FoodSafetyPage(
          onBack: _back,
          onContinue: _next,
          onFilesSelected: (files) => _foodSafety = List.from(files),
        );

      case 3:
        return CulinaryCertPage(
          onBack: _back,
          onContinue: _next,
          onSkip: _next,
          onFilesSelected: (files) => _culinary = List.from(files),
        );
      case 4:
        return ChefVerificationReviewPage(
          onBack: _back,
          govIdFront: _govIdFront,
          govIdBack: _govIdBack,
          proofOfAddress: _proofOfAddress,
          nonSexualOffender: const [],
          criminalBackground: const [],
          foodSafety: _foodSafety,
          culinaryCerts: _culinary,
          onSubmit: () async {
            final controller = SignUpChefController.instance;
            await controller.submitChefVerification(
              idCardFrontPath: _govIdFront.isNotEmpty ? _govIdFront.first.path : null,
              idCardBackPath: _govIdBack.isNotEmpty ? _govIdBack.first.path : null,
              proofOfAddressPath: _proofOfAddress.isNotEmpty ? _proofOfAddress.first.path : null,
              foodSafetyCertPath: _foodSafety.isNotEmpty ? _foodSafety.first.path : null,
              additionalCulinaryPath: _culinary.isNotEmpty ? _culinary.first.path : null,
            );
          },
        );
      default:
        return const Scaffold(
          body: Center(child: Text('Something went wrong')),
        );
    }
  }
}