import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';

class PurchaseProcessingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseProcessingController>(
        () => PurchaseProcessingController());
  }
}

class PurchaseProcessingController extends GetxController {}

class PurchaseProcessing extends GetView<PurchaseProcessingController> {
  const PurchaseProcessing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().blueBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Image.asset(
          'assets/images/payment_processing.png',
          height: Get.height,
          width: Get.width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
