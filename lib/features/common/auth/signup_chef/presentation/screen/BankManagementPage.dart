import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/api/api_end_point.dart';
import 'package:new_untitled/services/api/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BankManagementController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> connectBankAccount() async {
    isLoading.value = true;
    try {
      final response = await ApiService.post(
        ApiEndPoint.createConnectedAccount,
        body: {},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final dynamic dataField = response.data['data'];
        String? stripeUrl;

        if (dataField is Map) {
          stripeUrl = dataField['data']?.toString();
        } else if (dataField is String) {
          stripeUrl = dataField;
        }

        debugPrint("Stripe URL: $stripeUrl");

        if (stripeUrl != null && stripeUrl.isNotEmpty) {
          Get.to(() => StripeWebViewPage(url: stripeUrl!));
        } else {
          Get.snackbar("Error", "Invalid URL",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar(
          "Error",
          response.data?['message']?.toString() ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Bank connect error: $e");
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

class StripeWebViewPage extends StatefulWidget {
  final String url;
  const StripeWebViewPage({super.key, required this.url});

  @override
  State<StripeWebViewPage> createState() => _StripeWebViewPageState();
}
class _StripeWebViewPageState extends State<StripeWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true; // যোগ করুন

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true); // যোগ করুন
          },
          onPageFinished: (url) {
            setState(() => isLoading = false); // যোগ করুন
          },
          onWebResourceError: (error) => debugPrint("Error: ${error.description}"),
          onNavigationRequest: (request) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/91.0.4472.120 Mobile Safari/537.36',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Bank Account"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class BankManagementPage extends StatelessWidget {
  const BankManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BankManagementController());
    return Scaffold(
      appBar: AppBar(title: const Text("Bank Management")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.connectBankAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff343330),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
                  : const Text("Connect Bank Account",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          )),
        ),
      ),
    );
  }
}