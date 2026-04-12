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
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception("Request timed out. Please try again."),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final dynamic dataField = response.data['data'];
        String? stripeUrl;

        if (dataField is Map) {
          stripeUrl = dataField['data']?.toString();
        } else if (dataField is String) {
          stripeUrl = dataField;
        }

        if (stripeUrl != null && stripeUrl.isNotEmpty) {
          Get.to(() => StripeWebViewPage(url: stripeUrl!));
        } else {
          Get.snackbar("Error", "Invalid URL",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar(
          "Error",
          response.data['message']?.toString() ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    // ৩০ সেকেন্ড পর loading বন্ধ করবে
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() { isLoading = true; hasError = false; });
          },
          onPageFinished: (url) {
            if (mounted) setState(() => isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() { isLoading = false; hasError = true; });
            }
          },
          onNavigationRequest: (request) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/91.0.4472.120 Mobile Safari/537.36',
          'Accept-Language': 'en-US,en;q=0.9',
          'Cache-Control': 'no-cache',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xff1A1A1A)),
                    SizedBox(height: 16),
                    Text(
                      "Connecting to Stripe...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffAAAAAA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (hasError && !isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 52, color: Color(0xffCCCCCC)),
                    const SizedBox(height: 16),
                    const Text(
                      "Connection failed",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Please check your internet\nand try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xffAAAAAA)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() { hasError = false; isLoading = true; });
                        _controller.reload();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                      child: const Text(
                        "Try Again",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
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
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAFAFA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bank Management",
          style: TextStyle(
            color: Color(0xff1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff1A1A1A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Subtitle ──
              const Text(
                "Connect your bank account\nto receive payments.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff888888),
                  height: 1.6,
                  letterSpacing: -0.1,
                ),
              ),

              const SizedBox(height: 28),

              // ── Main Card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffF0F0F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Bank icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.account_balance_outlined,
                        size: 30,
                        color: Color(0xff1A1A1A),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Link Your Bank",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Securely connect via Stripe to\nstart receiving payments.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xffAAAAAA),
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),


                    const SizedBox(height: 12),
                    _featureTile(
                      icon: Icons.bolt_rounded,
                      title: "Instant Payouts",
                      subtitle: "Get paid within minutes",
                    ),
                    const SizedBox(height: 12),
                    _featureTile(
                      icon: Icons.tune_rounded,
                      title: "Easy Management",
                      subtitle: "Full control over transfers",
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.connectBankAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1A1A1A),
                    disabledBackgroundColor: const Color(0xff1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                      : const Text(
                    "Connect Bank Account",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              )),

              Obx(() => controller.isLoading.value
                  ? const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  "Setting up your account...",
                  style: TextStyle(fontSize: 12, color: Color(0xffAAAAAA)),
                ),
              )
                  : const SizedBox.shrink()),

              const SizedBox(height: 14),

              // ── Stripe badge ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 14, color: Color(0xffBBBBBB)),
                  const SizedBox(width: 5),
                  const Text(
                    "Secured by Stripe",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xffBBBBBB),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _featureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: const Color(0xff1A1A1A)),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffAAAAAA),
              ),
            ),
          ],
        ),
      ],
    );
  }
}