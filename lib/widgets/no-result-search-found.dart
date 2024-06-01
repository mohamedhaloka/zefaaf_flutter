import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class NoResultSearchFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            lightMode
                ? "assets/images/no-result.png"
                : "assets/images/no-result-white.png",
            height: 120,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "عفواً!! لا توجد نتائج بحث",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyText1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text("برجاء إستخدام إعدادات بحث أخرى",
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyText1!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Get.find<AppController>().isMan.value == 0
                      ? Get.theme.primaryColor
                      : Get.theme.colorScheme.secondary)),
        ],
      ),
    );
  }
}
