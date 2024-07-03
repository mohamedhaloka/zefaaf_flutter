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
          ? const Center(child: Text('انتظر قليلاً'))
          : InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse(controller.checkoutUrl.value)),
              onLoadStart: (_, Uri? uri) async {
                String url = uri.toString();
                if (url.contains(controller.returnURL)) {
                  final uri = Uri.parse(url);
                  final payerID = uri.queryParameters['PayerID'];
                  if (payerID != null) {
                    Get.dialog(Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.white,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Image.asset(
                          'assets/images/payment_processing.png',
                          height: Get.height,
                          width: Get.width,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ));
                    await Future.delayed(const Duration(seconds: 1));
                    await controller.services
                        .executePayment(
                      controller.executeUrl.value,
                      payerID,
                      controller.accessToken,
                    )
                        .then((_) async {
                      final paypalConfirmed = await controller.confirmPaypal();

                      if (paypalConfirmed) {
                        Get.back();
                        Get.back();
                        Get.offAllNamed(
                          '/PurchaseSuccess',
                          arguments: controller.zefaafPackageTittle,
                        );
                      }
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
