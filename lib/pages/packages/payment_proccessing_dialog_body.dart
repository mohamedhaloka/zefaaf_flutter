import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentProccessingDialogBody extends StatefulWidget {
  const PaymentProccessingDialogBody({super.key});

  @override
  State<PaymentProccessingDialogBody> createState() =>
      _PaymentProccessingDialogBodyState();
}

class _PaymentProccessingDialogBodyState
    extends State<PaymentProccessingDialogBody> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
