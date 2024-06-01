import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoPostsYet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Padding(
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          Image.asset(
            "assets/images/no-posts.png",
            width: 150,
          ),
          Text(
            "لا توجد مقالات في هذا التصنيف",
            style: Get.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }
}
