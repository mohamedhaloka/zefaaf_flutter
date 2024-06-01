import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:zeffaf/pages/settings/settings.provider.dart';

import '../../appController.dart';
import '../../services/socketService.dart';
import '../../utils/toast.dart';

class MoreController extends GetxController {
  final appController = Get.find<AppController>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessageing = FirebaseMessaging.instance;
  final storage = GetStorage();
  final socket = Get.find<SocketService>();
  late String facebookLink,
      instagramLink,
      whatsappLink,
      privacy,
      aboutUs,
      registerCondetions,
      androidLink,
      iphoneLink,
      shareText;
  late int displayPackages;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  void get() {
    facebookLink = storage.read('facebookLink') ?? '';
    instagramLink = storage.read('instagramLink') ?? '';
    whatsappLink = storage.read('whatsAppLink') ?? '';
    privacy = storage.read('privacy') ?? '';
    aboutUs = storage.read('aboutUS') ?? '';
    registerCondetions = storage.read('registerCondetions') ?? '';
    androidLink = storage.read('androidLink') ?? '';
    iphoneLink = storage.read('iphoneLink') ?? '';
    shareText = storage.read('shareText') ?? '';
    displayPackages = storage.read('displayPackages') ?? 0;
  }

  logOut(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Get.dialog(AlertDialog(
        content: const Text("هل تريد حقاً تسجيل الخروج؟"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              DynamicTheme.of(context)?.setTheme(0);
              var fontSize = Provider.of<ChangeFontSize>(
                context,
                listen: false,
              );
              final countryId = appController.userData.value.residentCountryId;
              firebaseMessageing.unsubscribeFromTopic('country-$countryId');
              appController.logOut();
              auth.signOut();
              appController.changeThemeMode(false);
              appController.updateGender(0);
              fontSize.changeSize(0.0);
              appController.changeNotificationOpenDate("");
              appController.notificationOpenDate.value = "";
              appController.changeFontSize(fontSize.fontSize);
              firebaseMessageing.deleteToken();
              firebaseMessageing.unsubscribeFromTopic('all');
              socket.disconnectSocket();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
            ),
            child: const Text(
              "نعم",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("تراجع"),
          ),
        ],
      ));
    } else {
      showToast("تأكد من إتصالك بالإنترنت أولاً");
    }
  }
}
