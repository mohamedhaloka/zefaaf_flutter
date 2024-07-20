import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/utils/toast.dart';

class MobileNumberRequestsController extends GetxController {
  final _appController = Get.find<AppController>();

  RxBool connectToInternet = false.obs;
  RxList<User> result = <User>[].obs;
  RxBool fetch = false.obs;
  RxBool loading = true.obs;
  RxInt currentPage = 0.obs;

  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    _getMobileRequests();
    scrollController.addListener(_listenToScroll);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_listenToScroll);
    super.onClose();
  }

  void _listenToScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      currentPage.value++;

      _getMobileRequests();
    }
  }

  Future<void> _getMobileRequests() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    connectToInternet(false);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        currentPage.value++;
        if (currentPage.value > 1) {
          fetch(true);
        } else {
          loading(true);
        }

        String url = "${Request.urlBase}getMobileRequests/${currentPage.value}";
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer ${_appController.apiToken}'},
        );
        var data = jsonDecode(response.body);
        if (data["status"] == "success") {
          List jsonUser = data['data'];
          if (jsonUser.isEmpty) {
            fetch(false);
            currentPage(currentPage.value - 1);
          }

          for (var item in jsonUser) {
            result.add(User.fromJson(item));
          }
          fetch(false);

          loading(false);
        } else {
          showToast("searchError".tr);
        }
      } catch (e) {
        loading(false);
      }
    } else {
      loading(false);
      connectToInternet(true);
      showToast("تأكد من إتصالك بالإنترنت");
    }
  }
}
