import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:zeffaf/pages/settings/settings.provider.dart';
import 'package:zeffaf/services/notification.service.dart';

import '../../appController.dart';
import '../../services/http.service.dart';
import '../../services/socketService.dart';
import '../../utils/toast.dart';
import 'login.dart';

class LoginController extends GetxController {
  String username = "", password = "";
  final socket = Get.find<SocketService>();

  TextEditingController usernameController = TextEditingController();

  RxBool loading = false.obs;
  final appController = Get.find<AppController>();
  final notification = Get.find<NotificationsService>();
  final storage = GetStorage();
  late Request request;
  RxBool isAuth = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> validateLogin(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        login(username: username, password: password, context: context);
      } else {
        showToast("يرجى عدم ترك شئ فارغ");
      }
    } else {
      showToast("يرجى التأكد من إتصالك بالإنترنت وإعادة المحاولة");
    }
  }

  Future login({username, password, context}) async {
    FocusScope.of(context).requestFocus(FocusNode());
    LoginAPI.login(
        appController: appController,
        context: context,
        loading: loading,
        password: password,
        pushToken: notification.pushToken,
        request: request,
        username: username);
  }

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), () {
      bool haveAccess = Get.arguments == null ? false : Get.arguments[0];

      if (haveAccess) {
        Get.dialog(AlertDialog(
          title: const Text("خطأ!"),
          content: const Text("يوجد مشكلة بالحساب برجاء تسجيل الدخول"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
              ),
              child: const Text("حسناً"),
            )
          ],
        ));
      }
    });

    request = Request(apiToken: appController.apiToken.value);
    super.onInit();
  }

  //  created object of localauthentication class
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> authenticateByFinger(context) async {
    // this method opens a dialog for fingerprint authentication.
    //    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      if (appController.fingerprintStatue.value) {
        authenticated = await _localAuthentication.authenticate(
          localizedReason:
              "Touch your finger on the sensor to login", // message for dialog
          options: const AuthenticationOptions(
            useErrorDialogs: true, // show error in dialog
            stickyAuth: true, // native process
          ),
        );
        loginByToken(context, authenticated);
      } else {
        Get.snackbar('إنتبه!', 'لم تقم بتفعيل البصمة',
            backgroundColor: Colors.black54);
      }
    } catch (_) {}

    isAuth(authenticated ? true : false);
  }

  Future loginByToken(BuildContext context, bool authenticated) async {
    if (authenticated) {
      isAuth(true).obs;
      request.post('loginByToken', {
        'deviceToken': notification.pushToken,
        'notificationOpenDate': "${appController.notificationOpenDate}",
        'detectedCountry': 'unknown',
      }).then((response) {
        var data = json.decode(response.body);
        if (data['status'] == "success") {
          var result = json.decode(response.body);
          appController.updateUserDate(result);
          appController.updateAPiToken(json.decode(response.body)['token']);

          var fontSize = Provider.of<ChangeFontSize>(context, listen: false);
          appController.changeFontSize(fontSize.fontSize);
          DynamicTheme.of(context)!.setTheme(0);
          //
          appController
              .updateGender(json.decode(response.body)['data'][0]['gender']);
          appController
              .saveStatue(json.decode(response.body)['data'][0]['available']);
          appController
              .changeNotificationOpenDate(DateTime.now().toUtc().toString());
          isAuth(false);
          Get.offAllNamed('/BottomTabsHome');
        } else {
          isAuth(false);
          Get.snackbar("خطأ", "يرجى التأكد من البصمة وإعادة المحاولة لاحقاً.",
              backgroundColor: Colors.black54);
        }
      });
    }
  }
}
