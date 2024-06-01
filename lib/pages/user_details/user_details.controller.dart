import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/services/http.service.dart';

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
      print(user.value.allowMobile);
      loading(false);
    } else {
      loading(false);
    }
    return null;
  }

  Future<String?> checkAvailabilityOfChatting(String otherId) async {
    String url = "${Request.urlBase}openChat";
    http.Response response = await http.post(Uri.parse(url),
        body: {'otherId': otherId, 'reverse': 1.toString()},
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});
    var responseData = json.decode(response.body);

    if (responseData['status'] == "error") {
      if (responseData['errorCode'] == "free package") {
        return "هذه الخدمة لأصحاب الباقة الفضية";
      } else if (responseData['errorCode'] == "package4") {
        return "هذه الخدمة لأصحاب الباقة الذهبية";
      } else if (responseData['errorCode'] == "package5") {
        return "هذه الخدمة لأصحاب الباقة البلاتينية";
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
      print(data);

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
