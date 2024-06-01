import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/cards/mutual_card.dart';

import '../../widgets/app_header.dart';
import 'friends.controller.dart';

class Friends extends GetView<FriendsController> {
  @override
  Widget build(context) {
    return Scaffold(
      body: Obx(
        () => BaseAppHeader(
          centerTitle: true,
          title: Image.asset(
            "assets/images/logo.png",
            height: 30,
            width: 30,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tabHeader("interestList".tr, () {
                controller.isAttentions.value = true;
              }, controller.isAttentions.value == true),
              tabHeader("neglectList".tr, () {
                controller.isAttentions.value = false;
              }, controller.isAttentions.value == false),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter),
              onPressed: () {},
            ),
          ],
          children: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return MutualCard(controller.isAttentions.value == true
                    ? controller.attentions[index]
                    : controller.neglected[index]);
              },
                  childCount: controller.isAttentions.value == true
                      ? controller.attentions.length
                      : controller.neglected.length),
            )
          ],
        ),
      ),
    );
  }

  tabHeader(String title, Function onTap, bool isActive) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Text(
        title.toString(),
        style: Get.textTheme.titleMedium!.copyWith(
            color: isActive == true
                ? Get.theme.colorScheme.secondary
                : AppTheme.LIGHT_GREY),
      ),
    );
  }
}
