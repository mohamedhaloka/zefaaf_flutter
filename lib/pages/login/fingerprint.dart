import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/login/login.controller.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

class Fingerprint extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isAuth.value
        ? Column(
            children: [
              CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Get.theme.primaryColor)),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              const Text("تم التسجيل بنجاح، جاري إعادة توجيهك للرئيسية"),
            ],
          )
        : Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                    spreadRadius: 3)
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                controller.authenticateByFinger(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
              ),
              child: Image.asset(
                "assets/images/log_in/fingerprint.png",
                width: 70,
              ),
            ),
          ));
  }
}
