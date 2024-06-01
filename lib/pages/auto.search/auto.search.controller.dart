import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/user.dart';

import '../../services/http.service.dart';

class AutoSearchController extends GetxController {
  final appController = Get.find<AppController>();
  ScrollController scrollController = ScrollController();

  RxList<User> resultUserList = RxList<User>([]);
  RxBool loading = RxBool(false);
  RxInt currentPage = RxInt(0);
  RxInt settingsExist = RxInt(0);
  RxString currentType = RxString('lastAccess');
  RxBool notConnectToInternet = RxBool(false);

  static String lastAccess = 'الأحدث دخولاً';
  static String id = 'الأحدث تسجيلاً';

  List<String> choices = <String>[lastAccess, id];

  void choiceAction(String choice) {
    if (choice == lastAccess) {
      currentPage(0);
      currentType('lastAccess');
      getMySearch(currentPage.value, currentType.value);
    } else if (choice == id) {
      currentPage(0);
      currentType('id');
      getMySearch(currentPage.value, currentType.value);
    }
  }

  getMySearch([page, type, isPagination]) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    notConnectToInternet(true);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      notConnectToInternet(false);
      isPagination ?? loading(true);
      String url = "${Request.urlBase}getMySearch/$page/$type";
      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

      var responseDecoded = json.decode(response.body);
      if (responseDecoded['status'] == "success") {
        isPagination ?? resultUserList.clear();
        List data = responseDecoded['data'];
        if (data.isEmpty) {
          currentPage.value == 0 ? null : currentPage(page - 1);
        }

        settingsExist.value = responseDecoded['settingsExist'];
        for (var searchResult in responseDecoded['data']) {
          resultUserList.add(User.fromJson(searchResult));
        }
        loading(false);
      } else {
        loading(false);
      }
    } else {
      notConnectToInternet(true);
    }
  }

  searchResultWithPagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage.value++;
        getMySearch(currentPage.value, currentType.value, true);
      }
    });
  }

  @override
  void onInit() {
    getMySearch(currentPage.value, currentType.value);
    searchResultWithPagination();
    super.onInit();
  }
}
