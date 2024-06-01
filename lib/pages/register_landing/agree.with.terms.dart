import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register.landing.controller.dart';

class AgreeWithTerms extends GetView<RegisterLandingController> {
  AgreeWithTerms({required this.val, required this.onChanged});
  ValueChanged<bool?> onChanged;
  RxBool val;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Obx(() => Checkbox(
                  onChanged: onChanged,
                  value: val.value,
                  activeColor: Colors.blue[700],
                )),
            const Text(
              "موافق وأقسم على ما سبق",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }
}
