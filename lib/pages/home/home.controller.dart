import 'dart:convert';
import 'dart:developer';

import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/services/notification.service.dart';

import '../../appController.dart';
import '../../services/socketService.dart';
import '../../utils/toast.dart';
import '../settings/settings.provider.dart';
import 'update.data.dart';

class HomeController extends GetxController {
  final appController = Get.find<AppController>();
  final storage = GetStorage();
  final socket = Get.find<SocketService>();
  RxList<User> users = <User>[].obs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  fa.FirebaseAuth auth = fa.FirebaseAuth.instance;
  RxString userNameForSocket = RxString("");
  RxString detectedCountryName = RxString("unknown");
  final notification = Get.find<NotificationsService>();
  final Request request =
      Request(apiToken: Get.find<AppController>().apiToken.value);
  RxBool available = RxBool(true);
  @override
  void onInit() {
    users = appController.latest;
    appController.changeNotificationOpenDate(DateTime.now().toUtc().toString());
    loginByToken();
    notification.isRecievedNotify.listen((val) {
      updateByToken(false);
    });

    super.onInit();
  }

  getToken() async {
    notification.firebaseMessaging.getToken().then((token) {
      notification.pushToken = token!;
      log(token, name: 'FCM TOKEN');
    });
  }

  changeStatue(statue, context) async {
    http.Response response = await http.post(
        Uri.parse('${Request.urlBase}changeMyStatus'),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
        body: {'status': statue.toString()});

    var data = json.decode(response.body);
    if (data['status'] == "success") {
      showToast(
          statue == 2 ? "تم تغيير حالتك إلى مشغول" : "تم تغيير حالتك إلى متصل");
    } else {
      showToast("حدث خطاء يرجي معاودة تغير الحالة لاحقاً");
    }
  }

  loginByToken() async {
    await getToken();
    await updateByToken(true);
  }

  Future<String?> getCountryCode() async {
    final permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) return null;
    final Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isEmpty) return null;
    Placemark place = placemarks[0];

    return place.isoCountryCode;
  }

  Future updateByToken(restart) async {
    try {
      detectedCountryName.value = (await getCountryCode()) ?? 'unknown';
      // detectedCountryName.value =
      //     (await FlutterSimCountryCode.simCountryCode) ?? 'unknown';
    } catch (_) {
      detectedCountryName('unknown');
    }
    await UpdateData.loginByToken(
        pushToken: notification.pushToken.toString(),
        appController: appController,
        apiToken: appController.apiToken.value,
        detectedCountryName: detectedCountryName.value,
        firebaseMessaging: _firebaseMessaging,
        logOut: logOut,
        mobileType: GetPlatform.isAndroid ? '1' : '2',
        notificationOpenDate: appController.notificationOpenDate.value,
        restart: restart,
        socket: socket);
  }

  logOut() {
    BuildContext context = Get.context!;
    DynamicTheme.of(context)?.setTheme(0);
    final fontSize = Provider.of<ChangeFontSize>(context, listen: false);

    appController.logOut(true);
    auth.signOut();
    fontSize.changeSize(0.0);
    appController.changeThemeMode(false);
    appController.updateGender(null);
    appController.changeNotificationOpenDate("");
    appController.notificationOpenDate.value = "";
    _firebaseMessaging.deleteToken();
    _firebaseMessaging.unsubscribeFromTopic('all');
    _firebaseMessaging.unsubscribeFromTopic('man');
    _firebaseMessaging.unsubscribeFromTopic('woman');

    socket.disconnectSocket();
  }
}
