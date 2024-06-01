import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'favorites.controller.dart';

class NoItemsInFavList extends GetView<FavoritesController> {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            controller.appController.isMan.value == 0
                ? 'assets/images/empty-list-woman.png'
                : 'assets/images/empty-list-man.png',
            height: 120,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "لم تتم إضافة أي شخص حتى الآن",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyText1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
