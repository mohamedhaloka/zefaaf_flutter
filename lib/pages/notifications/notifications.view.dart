import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/cards/notification_card.dart';
import 'package:zeffaf/widgets/no-internet.dart';
import 'package:zeffaf/widgets/user_loader.dart';

import 'dialog.dart';
import 'no.notification.dart';
import 'notifications.controller.dart';

class Notifications extends StatefulWidget {
  const Notifications(
      {super.key, this.notification, this.activeIndex, this.notInTab});
  final String? notification;
  final int? activeIndex;
  final bool? notInTab;
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: InputData.animationTime, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return GetX<NotificationsController>(
      init: NotificationsController(),
      initState: (_) {
        final controller = Get.find<NotificationsController>();

        controller.activeRadioTile(widget.activeIndex);
        controller.notificationType(widget.notification);
        controller.fetchNotificationData(
          controller.notificationType.value,
          controller.currentPage.value,
        );
      },
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[400]
              : Colors.grey[700],
          body: BaseAppHeader(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[400]
                : Colors.grey[700],
            headerLength: 100,
            controller: controller.scrollController,
            refresh: () {
              controller.notifications.clear();
              controller.loading(true);
              controller.activeRadioTile(controller.activeRadioTile.value);
              controller.currentPage(0);
              controller.fetchNotificationData(
                  controller.notificationType.value,
                  controller.currentPage.value);
            },
            title: Text(
              "notification".tr,
              style: Get.textTheme.bodyText2!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset("assets/images/home/sort.svg"),
                onPressed: () {
                  NotificationActions.showDialog(controller);
                },
              ),
              Visibility(
                visible: widget.notInTab!,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_forward_outlined),
                ),
              )
            ],
            children: [
              controller.isNotConnectedToInternet.value
                  ? const NoInternetChecker()
                  : controller.loading.value
                      ? SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return UserLoader();
                          }, childCount: 6),
                        )
                      : controller.notifications.isEmpty
                          ? NoNotification()
                          : SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return NotificationCard(
                                  controller.notifications[index],
                                  animationController: animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval(
                                          (1 /
                                                  controller
                                                      .notifications.length) *
                                              index,
                                          1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                );
                              }, childCount: controller.notifications.length),
                            )
            ],
          ),
        ),
      ),
    );
  }
}

/*
* */
