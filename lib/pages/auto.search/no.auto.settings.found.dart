import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class NoAutoSettingsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no-result.png",
            width: 220,
            height: 220,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Text(
                  "لا يوجد إعدادات مُسبقة",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Get.find<AppController>().isMan.value == 0
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.secondary),
                  onPressed: () {
                    Get.toNamed('/auto_search_setting');
                  },
                  child: Text(
                    "إضغط هنا لإدخال الإعدادات",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[800]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
