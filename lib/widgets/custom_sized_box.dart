import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSizedBox extends StatelessWidget {
  const CustomSizedBox({required this.heightNum, required this.widthNum});
  final double heightNum;
  final double widthNum;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * heightNum,
      width: Get.width * widthNum,
    );
  }
}
