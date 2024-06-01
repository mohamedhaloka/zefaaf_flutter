import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no-notification.png",
            height: 120,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "لا يوجد أي إشعارات حتى الآن",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyText1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
