import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';

class NoMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/no-message.png",
          height: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          "لا يوجد رسائل حتى الآن!!",
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyText1!
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text("يرجى المحاولة لاحقاً",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyText1!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Get.find<AppController>().isMan.value == 0
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary)),
      ],
    ));
  }
}
