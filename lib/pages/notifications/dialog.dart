import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/utils/theme.dart';

import 'notifications.controller.dart';

class NotificationActions {
  static showDialog(NotificationsController controller) {
    return Get.defaultDialog(
        title: "choiceFilter".tr,
        content: Column(
          children: [
            buildRadioList(
                tittle: "all".tr,
                controller: controller,
                notificationType: "-",
                value: 1),
            buildRadioList(
                tittle: "عام",
                controller: controller,
                notificationType: "0",
                value: 2),
            buildRadioList(
                tittle: "watchMyAccount".tr,
                controller: controller,
                notificationType: "1",
                value: 3),
            buildRadioList(
                tittle: "معجب بي".tr,
                controller: controller,
                notificationType: "2",
                value: 4),
            buildRadioList(
                tittle: "طلبات الصور",
                controller: controller,
                notificationType: "3",
                value: 5),
            buildRadioList(
                tittle: "موافقة طلب الصورة",
                controller: controller,
                notificationType: "4",
                value: 6),
            buildRadioList(
                tittle: "رفض طلب الصورة",
                controller: controller,
                notificationType: "5",
                value: 7),
            buildRadioList(
                tittle: "طلبات رقم الهاتف",
                controller: controller,
                notificationType: "7",
                value: 8),
          ],
        ),
        titleStyle: Get.textTheme.bodyText2!.copyWith(color: AppTheme.WHITE),
        backgroundColor: Get.find<AppController>().isMan.value == 0
            ? Get.theme.primaryColor
            : Get.theme.colorScheme.secondary);
  }

  static onChanged(
      val, String notificationType, NotificationsController controller) {
    controller.activeRadioTile(val);
    Get.back();
    controller.notificationType(notificationType);
    controller.currentPage(0);
    controller.notifications.clear();
    controller.loading(true);
    controller.fetchNotificationData(
        notificationType, controller.currentPage.value);
  }

  static Widget buildRadioList(
          {tittle,
          notificationType,
          value,
          required NotificationsController controller}) =>
      RadioListTile(
          title: Text(tittle,
              style: Get.textTheme.headline4!.copyWith(color: AppTheme.WHITE)),
          value: value,
          groupValue: controller.activeRadioTile.value,
          activeColor: Get.find<AppController>().isMan.value == 0
              ? Get.theme.colorScheme.secondary
              : Get.theme.primaryColor,
          onChanged: (value) {
            onChanged(value, notificationType, controller);
          });
}
