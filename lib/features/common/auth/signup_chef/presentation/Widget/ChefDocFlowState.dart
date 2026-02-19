import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/features/common/auth/signup_chef/presentation/screen/Cafe_Setup_Profile_Screen.dart';
import '../../../../../../config/route/app_routes.dart';
import '../add documents/Model/UploadedFileModel.dart';
import '../add documents/screen/ChefVerificationReviewPage.dart';
import '../add documents/screen/CulinaryCertPage.dart';
import '../add documents/screen/FoodSafetyPage.dart';
import '../add documents/screen/ProofOfAddressPage.dart';
import '../add documents/screen/government_issued_Page.dart';

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
      Get.back();
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
          onSubmit: () {

            //Get.toNamed(AppRoutes.dietaryPreferences);
            Get.to(CafeSetupProfileScreen());

            Get.snackbar(
              'Success',
              'Documents submitted successfully ok',
              backgroundColor: Colors.black,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
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