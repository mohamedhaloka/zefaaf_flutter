import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'paypal.controller.dart';

class PaypalPayment extends GetView<PaypalController> {
  const PaypalPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() => controller.checkoutUrl.value == ''
          ? const Center(child: Text('loading'))
          : InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse(controller.checkoutUrl.value)),
              onLoadStart: (_, Uri? uri) async {
                String url = uri.toString();
                if (url.contains(controller.returnURL)) {
                  final uri = Uri.parse(url);
                  final payerID = uri.queryParameters['PayerID'];
                  if (payerID != null) {
                    Get.toNamed('/PurchaseProcessing');
                    await controller.services
                        .executePayment(
                      controller.executeUrl.value,
                      payerID,
                      controller.accessToken,
                    )
                        .then((id) {
                      Get.back();
                      Get.back();
                      Get.offAllNamed(
                        '/PurchaseSuccess',
                        arguments: controller.zefaafPackageTittle,
                      );
                    });
                  } else {
                    Get.back();
                  }
                }
                if (url.contains(controller.cancelURL)) {
                  Get.back();
                }
              })),
    );
  }
}
