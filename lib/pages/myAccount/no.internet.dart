import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: Get.width,
      color: lightMode ? Colors.black54 : Colors.white60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no-internet.png",
            width: 120,
            height: 120,
            color: Colors.red[500],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "لا يوجد إنترنت! تأكد من إتصالك وأعد المحاولة",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: lightMode ? Colors.white : Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
