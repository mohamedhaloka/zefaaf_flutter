import 'package:flutter/material.dart';
import 'package:get/get.dart';

registerAppBar({onTap}) {
  return AppBar(
    backgroundColor: Colors.grey[100],
    elevation: 0.0,
    centerTitle: false,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: Get.back,
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "تسجيل حساب جديد",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        Text(
          "بيانات الحساب الشخصية",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    ),
  );
}
