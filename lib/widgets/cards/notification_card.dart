import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/notification.dart';
import 'package:zeffaf/pages/notifications/notifications.controller.dart';
import 'package:zeffaf/pages/user_details/user_details.view.dart';
import 'package:zeffaf/utils/time.dart';

import '../user_image.dart';

class NotificationCard extends GetView<NotificationsController> {
  final NotificationModel notificationModel;

  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.dark;
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              100 * (1.0 - animation.value),
              0.0,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: InkWell(
                onTap: notificationModel.notiType == 0
                    ? null
                    : () {
                        if (notificationModel.notiType == 12) {
                          Get.toNamed('/AppMessageView');
                          return;
                        }
                        Get.to(() => UserDetails(
                              userId: notificationModel.userId!,
                              isFavourite: false,
                            ));
                      },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Get.theme.cardColor,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          height: 55,
                          width: 55,
                          child: UserImage(
                            notificationModel.image!,
                            notifyType: notificationModel.notiType ?? 0,
                            isPremium: notificationModel.isPremium ?? 0,
                            isLive: notificationModel.isLive ?? 0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${notificationModel.userName}",
                                  style: Get.textTheme.headline4!.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.primaryColor),
                                ),
                                Text(
                                  "${DateTimeUtil.convertTimeWithDate(notificationModel.date)}",
                                  style: Get.textTheme.headline4!.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.colorScheme.secondary),
                                )
                              ],
                            ),
                            GetBuilder<NotificationsController>(
                              init: NotificationsController(),
                              builder: (controller) => Text(
                                notificationModel.notiType == 0 ||
                                        notificationModel.notiType == 12
                                    ? notificationModel.title == null
                                        ? ""
                                        : "${notificationModel.title}"
                                    : "${controller.switchNotificationType(notificationModel.notiType)}",
                                style: Get.textTheme.headline4!.copyWith(
                                    fontSize: 11,
                                    color: isLightMode
                                        ? Colors.grey[300]
                                        : Colors.black),
                              ),
                            ),
                            Text(
                              notificationModel.subTitle == null
                                  ? ""
                                  : "${notificationModel.subTitle}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Get.textTheme.headline4!.copyWith(
                                fontSize: 11,
                                color: isLightMode
                                    ? Colors.grey[300]
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  const NotificationCard(this.notificationModel,
      {super.key, required this.animationController, required this.animation});
}
