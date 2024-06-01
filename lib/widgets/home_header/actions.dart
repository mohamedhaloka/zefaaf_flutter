import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/notifications/notifications.view.dart';
import 'package:zeffaf/utils/theme.dart';

class AccountActions extends GetView<AppController> {
  const AccountActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        width: Get.mediaQuery.size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            action("طلبات الزواج", null, controller.newMessages.value,
                () => Get.toNamed('/AppMessageView'),
                imagePath: 'assets/images/more-menu/contact-us.png'),
            buildDrawer,
            action("شاهدوا حسابي".tr, Icons.visibility_rounded,
                int.parse(controller.newViews.value), () async {
              Get.to(() => const Notifications(
                    activeIndex: 3,
                    notification: "1",
                    notInTab: true,
                  ));
            }),
            buildDrawer,
            action("admiredMe".tr, Icons.favorite,
                int.parse(controller.newInterest.value), () {
              Get.to(() => const Notifications(
                    activeIndex: 4,
                    notInTab: true,
                    notification: "2",
                  ));
            }),
            buildDrawer,
            action("topicsForRead".tr, Icons.person, controller.newPosts.value,
                () {
              Get.toNamed('/Posts');
            }),
          ],
        ),
      ),
    );
  }

  Widget get buildDrawer => const RotatedBox(
        quarterTurns: 3,
        child: Divider(
          color: Colors.white,
          height: 0,
          thickness: 1,
        ),
      );

  Widget action(String title, IconData? icon, number, Function onTap,
      {String? imagePath}) {
    return SizedBox(
      width: Get.width * 0.23,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 29,
              width: 29,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.isMan.value == 1
                    ? Get.theme.primaryColor
                    : Get.theme.colorScheme.secondary,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                ),
                padding: const EdgeInsets.all(2),
                child: icon == null
                    ? Image.asset(
                        imagePath ?? '',
                      )
                    : Icon(
                        icon,
                        size: 20,
                        color: AppTheme.WHITE,
                      ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number == 0
                      ? number.toString()
                      : number >= 10
                          ? number.toString()
                          : "0${number.toString()}",
                  maxLines: 1,
                  style: Get.textTheme.bodyText2!.copyWith(
                      height: 0.8,
                      color: controller.isMan.value == 0
                          ? AppTheme.WHITE
                          : Colors.black,
                      fontSize: 14),
                ),
                Text(
                  title,
                  maxLines: 1,
                  style: Get.textTheme.caption!.copyWith(
                      height: 0.8,
                      color: controller.isMan.value == 0
                          ? AppTheme.WHITE
                          : Colors.black,
                      fontSize: 7,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
