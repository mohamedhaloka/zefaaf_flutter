import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'payment.controller.dart';

class PaymentView extends GetView<PaymentController> {
  @override
  PaymentController controller = Get.put(PaymentController());

  PaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(controller.paymentUrl + controller.pageIndex),
            headers: {'Authorization': 'Bearer ${controller.apiToken}'}),
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform:
                InAppWebViewOptions(clearCache: true, cacheEnabled: false)),
        onWebViewCreated: (InAppWebViewController webcontroller) {
          controller.webView = webcontroller;
        },
        onLoadStart: (InAppWebViewController controller, Uri? url) {},
        onLoadStop: (InAppWebViewController controller, Uri? url) async {},
        onProgressChanged: (InAppWebViewController controller, int progress) {},
        onConsoleMessage: (controller, consoleMessage) {
          if (consoleMessage.message == "CAPTURED") {
            Get.back();
            Get.offAllNamed('/PurchaseSuccess');
          }
          if (consoleMessage.message == "DECLINED" ||
              consoleMessage.message == "closeFailed") {
            Get.back();
            Get.dialog(AlertDialog(
              title: const Text("حدث خطأ"),
              content: const Text("تأكد من معلومات البطاقة وأعد المحاولة"),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        this.controller.appController.isMan.value == 0
                            ? Get.theme.primaryColor
                            : Get.theme.colorScheme.secondary,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("حسناً"),
                )
              ],
            ));
          }
        },
        onUpdateVisitedHistory: (InAppWebViewController controller, Uri? url,
            bool? androidIsReload) {},
      ),
    );
  }
}
