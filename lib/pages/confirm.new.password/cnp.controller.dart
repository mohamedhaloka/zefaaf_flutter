import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';

class ConfirmNewPasswordController extends GetxController {
  final _appController = Get.find<AppController>();
  Rx<IconData> checkSamePass = Icons.close.obs;
  late Rx<TextEditingController> password, rePassword;
  RxBool loading = RxBool(false);

  confirmNewPass(pass) async {
    String url = "${Request.urlBase}updateMyPassword";
    loading(true);
    http.Response response = await http.post(Uri.parse(url),
        body: {"password": pass},
        headers: {'Authorization': 'Bearer ${_appController.apiToken}'});
    var data = json.decode(response.body);
    if (data['status'] == "success") {
      loading(false);
      Get.back();
      Get.snackbar("مُبارك عليك", "تم تحديث كلمة المرور بنجاح",
          backgroundColor: Colors.black54);
    } else {
      loading(false);
      Get.snackbar("خطاء!", "تأكد من كتابة كلمة مرور صحيحية",
          backgroundColor: Colors.black54);
    }
  }

  createNewPassword({newPass, phone, context}) async {
    try {
      String url = "${Request.urlBase}changePasswordNew";
      loading(true);
      log({'mobile': phone, 'password': newPass}.toString());
      http.Response response = await http.post(
        Uri.parse(url),
        body: {'mobile': phone, 'password': newPass},
      );
      var data = json.decode(response.body);
      if (data['status'] == "success") {
        loading(false);
        Get.snackbar('تم بنجاح', 'تم تغيير كلمة المرور بنجاح',
            backgroundColor: Colors.black54);
        Get.offAllNamed('/Login', arguments: [false]);
      } else {
        loading(false);
        Get.snackbar('خطأ!', 'يرجى إعادة المحاولة مرة أخرى',
            backgroundColor: Colors.black54);
      }
    } catch (_) {}
  }

  RxBool checkPassInputEqualRePassInput(pass, rePass) {
    if (pass == rePass) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  @override
  void onInit() {
    password = TextEditingController().obs;
    rePassword = TextEditingController().obs;
    super.onInit();
  }

  @override
  void onClose() {
    password.value.dispose();
    rePassword.value.dispose();
    super.onClose();
  }
}
