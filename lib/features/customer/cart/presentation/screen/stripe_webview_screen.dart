import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_untitled/config/route/app_routes.dart';
import 'package:new_untitled/features/customer/cart/presentation/screen/checkout_screen.dart';
import 'package:new_untitled/utils/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../utils/constants/app_string.dart';

class StripeWebViewScreen extends StatelessWidget {
  final String checkoutUrl;
  const StripeWebViewScreen({super.key, required this.checkoutUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller:
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (request) {
                  if (request.url.contains('success')) {
                    Get.offAllNamed(AppRoutes.customerHomeScreen);
                    Get.snackbar(
                      'Successful',
                      'Your Payment has been successful',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    return NavigationDecision.prevent;
                  } else if (request.url.contains('cancel')) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                    Get.snackbar(
                      AppString.cancel,
                      'Your payment has been canceled',
                      backgroundColor: AppColors.red,
                      colorText: AppColors.white,
                    );
                    return NavigationDecision.navigate;
                  }
                  return NavigationDecision.navigate;
                },
                onPageStarted: (_) {},
                onPageFinished: (url) {
                  if (url.contains('success')) {
                    Get.offAllNamed(AppRoutes.customerHomeScreen);
                  } else if (url.contains('cancel')) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  }
                },
                onWebResourceError: (error) {},
              ),
            )
            ..loadRequest(Uri.parse(checkoutUrl)),
        ),
      ),
    );
  }
}
