import 'package:flutter/material.dart';
import 'package:get/get.dart';

registrationAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: Get.back),
  );
}
