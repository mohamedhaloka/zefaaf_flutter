import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/notification.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';

class NotificationsController extends GetxController {
  final appController = Get.find<AppController>();
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  ScrollController scrollController = ScrollController();
  RxString notificationType = RxString("-");
  RxInt currentPage = 0.obs;
  RxInt activeRadioTile = 1.obs;
  RxString notification = RxString("");
  RxInt activeIndex = RxInt(1);
  RxBool loading = true.obs;
  RxBool isNotConnectedToInternet = false.obs;
  @override
  void onInit() {
    pagination();
    super.onInit();
  }

  switchNotificationType(notifyType) {
    switch (notifyType) {
      case 0:
        return "تنبية عام";
      case 1:
        return "شاهد حسابي";
      case 2:
        return "أبدى إعجاباً بحسابي";
      case 3:
        return "طلب مشاهدة صورتي";
      case 4:
        return "الموافقة على مشاهدة الصورة";
      case 5:
        return "رفض مشاهدة الصورة";
      case 7:
        return "طلب مشاهدة رقم هاتفي";
      case 8:
        return "الموافقة على إظهار الهاتف";
      case 9:
        return "رفض إظهار الهاتف";
    }
  }

  Future<void> fetchNotificationData(notificationType, page) async {
    await getNotification(notificationType, page).then((value) {
      notifications.addAll(value);
      loading(false);
    });
  }

  Future<List<NotificationModel>> getNotification(
      notificationType, page) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String url =
          "${Request.urlBase}getMyNotifications/$notificationType/$page/";
      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

      print('ddd ${appController.apiToken.value}');

      var data = json.decode(response.body);
      if (data['status'] == "success") {
        List<NotificationModel> notificationList = [];
        for (var notifyData in data['data']) {
          notificationList.add(NotificationModel.fromJson(notifyData));
        }
        return notificationList;
      } else {
        return [];
      }
    } else {
      isNotConnectedToInternet(true);
      return [];
    }
  }

  pagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage.value++;
        fetchNotificationData(notificationType, currentPage.value);
      }
    });
  }
}
