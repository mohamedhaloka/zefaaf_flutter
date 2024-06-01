import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class SMSValidationHeader extends StatelessWidget {
  SMSValidationHeader({super.key, required this.mobileNumber});
  String mobileNumber;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/sms_verification/settings.png",
          width: 80,
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.02,
        ),
        const Text(
          "كود التحقق",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.028,
        ),
        Text(
          "لقد أرسلنا رسالة نصية إلى ${mobileNumber.isEmpty ? "" : mobileNumber.substring(10)}********",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.02,
        ),
        Text(
          "أدخل كود التحقق",
          style: TextStyle(
              fontSize: 14,
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.bold),
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.03,
        ),
      ],
    );
  }
}
