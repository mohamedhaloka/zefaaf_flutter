import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/utils/upgrade_package_dialog.dart';

import '../../appController.dart';
import '../../utils/toast.dart';

class UserDetailsController extends GetxController {
  final appController = Get.find<AppController>();
  Rx<User> user = User().obs;
  RxBool loading = true.obs;
  RxBool loadingReplyPhoto = false.obs;

  Future<User?> getUserDetails(userId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
    }

    String url = "${Request.urlBase}getUserDetails/$userId";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
    );
    var data = json.decode(response.body);
    if (data['status'] == "success") {
      user.value = User.fromJson(data['data'][0]);
      print(user.value.toJson());
      loading(false);
    } else {
      loading(false);
    }
    return null;
  }

  Future<String?> checkAvailabilityOfChatting(String otherId) async {
    final packageLevel = appController.userData.value.packageLevel ?? 0;
    final packageId = appController.userData.value.packageId ?? 0;
    final otherUserMarriageId = user.value.mariageKind ?? 0;
    if (packageLevel == 4 &&
        packageId == 10 &&
        otherUserMarriageId != 185 &&
        otherUserMarriageId != 183) {
      return null;
    } else if (packageLevel == 1 &&
        packageId == 5 &&
        otherUserMarriageId == 5) {
      return null;
    } else if (packageLevel < 1 && otherUserMarriageId == 5) {
      return shouldUpgradeToSilverPackage;
    } else if (packageLevel < 3 && otherUserMarriageId == 6) {
      return shouldUpgradeToGoldenPackage;
    } else if (packageLevel < 4 && otherUserMarriageId == 184) {
      return shouldUpgradeToPlatinumPackage;
    } else if (packageLevel < 5 &&
        (otherUserMarriageId == 185 || otherUserMarriageId == 183)) {
      return shouldUpgradeToDiamondPackage;
    }

    String url = "${Request.urlBase}openChat";
    http.Response response = await http.post(Uri.parse(url),
        body: {'otherId': otherId, 'reverse': 1.toString()},
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});
    var responseData = json.decode(response.body);

    if (responseData['status'] == "error") {
      if (responseData['errorCode'] == "free package") {
        return shouldUpgradeToSilverPackage;
      } else if (responseData['errorCode'] == "package3") {
        return shouldUpgradeToGoldenPackage;
      } else if (responseData['errorCode'] == "package4") {
        return shouldUpgradeToGoldenPackage;
      } else if (responseData['errorCode'] == "package5") {
        return shouldUpgradeToDiamondPackage;
      }
    }
    return null;
  }

  Future addToList(userId, listId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}addToMyFavorites";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId", 'listType': "$listId"});

      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        return data['rowsCount'];
      } else if (data['errorCode'] == 'ignore list') {
        userIsBlockYou(user.value.userName);
        return 2;
      } else {
        return data['rowsCount'];
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
    }
  }

  Future replyPhoto({userId, statues}) async {
    loadingReplyPhoto(true);
    String url = "${Request.urlBase}replyPhoto";
    http.Response response = await http.post(Uri.parse(url), body: {
      "otherId": "$userId",
      "statues": statues,
    }, headers: {
      'Authorization': 'Bearer ${appController.apiToken.value}'
    });

    var data = json.decode(response.body);
    if (data['rowsCount'] == 1) {
      return data['rowsCount'];
    } else {}
  }

  Future replyRequestMobile({userId, statues}) async {
    loading(true);
    String url = "${Request.urlBase}replyRequestMobile";
    http.Response response = await http.post(Uri.parse(url), body: {
      "otherId": "$userId",
      "statues": statues,
    }, headers: {
      'Authorization': 'Bearer ${appController.apiToken.value}'
    });

    var data = json.decode(response.body);
    if (data['rowsCount'] == 1) {
      return data['rowsCount'];
    } else {}
    loading(false);
  }

  Future requestPhoto(userId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}requestPhoto";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId"});

      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        return data['rowsCount'];
      } else if (data['errorCode'] == 'ignore list') {
        userIsBlockYou(user.value.userName);
      } else {
        return data['rowsCount'];
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
    }
  }

  Future requestMobile(userId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}requestMobile";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId"});

      var data = json.decode(response.body);

      print('mobile data ${response.body}');
      if (data['status'] == 'success') {
        if (user.value.packageLevel == 0 || user.value.packageLevel == 6) {
          showToast(
              'متبقي لك ${data['data']['count_limit'] ?? 0} طلب لرقم الهاتف من $packageMaxPhoneRequests خلال هذا الشهر');
        }
        return data['rowsCount'];
      } else if (data['errorCode'] == 'ignore list') {
        userIsBlockYou(user.value.userName);
      } else if (data['errorCode'] == 'reach out requests limit') {
        final String msg = appController.isMan.value == 0
            ? 'بلغت الحد الأقصى المسموح لك. للمزيد اشترك ثانيةً'
            : 'بلغتي الحد الأقصى المسموح لك. للمزيد اشتركي ثانيةً';

        showUpgradePackageDialog(
          appController.isMan.value == 0,
          msg,
        );
      } else {
        return data['rowsCount'];
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
    }
  }

  int get packageMaxPhoneRequests {
    switch (appController.userData.value.packageLevel) {
      case 5:
      case 7:
        return 60;
      case 4:
      case 3:
      case 2:
        return 30;
      case 1:
        return 7;
      default:
        return 0;
    }
  }

  Future cancelRequestPhoto(userId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}cancelRequestPhoto";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId"});

      var data = json.decode(response.body);

      if (data['status'] == 'success' && response.statusCode == 200) {
        showToast("تم إلغاء طلب الصورة");
        loading(false);
      } else {
        showToast("حدث خطأ! يرجى إعادة المحاولة لاحقاً");
        loading(false);
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
      loading(false);
    }
  }

  Future cancelRequestMobile(userId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}cancelRequestMobile";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId"});

      var data = json.decode(response.body);

      if (data['status'] == 'success' && response.statusCode == 200) {
        showToast("تم إلغاء طلب رقم الهاتف");
        loading(false);
      } else {
        showToast("حدث خطأ! يرجى إعادة المحاولة لاحقاً");
        loading(false);
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
      loading(false);
    }
  }

  Future removeFromList(userId, listId, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      loading(true);
      String url = "${Request.urlBase}removeFromFavorites";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
          body: {'otherId': "$userId", 'listType': "$listId"});

      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        return data['rowsCount'];
      } else {
        return data['rowsCount'];
      }
    } else {
      showToast("تأكد من إتصالك بالانترنت وأعد المحاولة لاحقاً");
    }
  }

  void userIsBlockYou(userName) {
    Get.dialog(AlertDialog(
      title: const Text("خطأ"),
      content: Text("لا تتوافق تطلعات $userName مع ملفك "),
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
}
