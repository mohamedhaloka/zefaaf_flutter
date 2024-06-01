import 'dart:convert';

import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zeffaf/pages/settings/settings.provider.dart';

import '../../appController.dart';
import '../../services/http.service.dart';

class LoginAPI {
  static login(
      {required RxBool loading,
      required String username,
      required BuildContext context,
      required String password,
      required String pushToken,
      required Request request,
      required AppController appController}) {
    loading(true);
    request.post('login', {
      'mobile': username,
      'password': password,
      'notificationOpenDate': "${appController.notificationOpenDate}",
      'deviceToken': pushToken,
      'detectedCountry': ""
    }).then((response) {
      try {
        if (json.decode(response.body)['status'] == "success") {
          var result = json.decode(response.body);
          appController.updateUserDate(result);
          var token = json.decode(response.body)['token'];
          appController.updateAPiToken(token);
          //Set All Setting Data to Default
          var fontSize = Provider.of<ChangeFontSize>(context, listen: false);
          appController.changeFontSize(fontSize.fontSize);
          DynamicTheme.of(context)?.setTheme(0);

          appController
              .updateGender(json.decode(response.body)['data'][0]['gender']);
          appController
              .saveStatue(json.decode(response.body)['data'][0]['available']);

          appController
              .changeNotificationOpenDate(DateTime.now().toUtc().toString());
          loading(false);
          Get.offAllNamed('/BottomTabsHome');
        } else {
          Get.snackbar("خطأ", "خطأ بإسم المستخدم أو كلمة المرور",
              backgroundColor: Colors.black54);
          loading(false);
        }
      } catch (e) {
        loading(false);
      }
    });
  }
}
