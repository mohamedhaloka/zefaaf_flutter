import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';

class FavoritesController extends GetxController {
  ScrollController scrollController = ScrollController();

  final appController = Get.find<AppController>();

  RxInt activeTab = RxInt(1);
  RxInt currentPage = RxInt(0);
  RxList<User> list = <User>[].obs;
  RxBool loading = false.obs;
  RxBool connectWithInternet = false.obs;

  Future<List<User>?> getNetwork(listType, page, firstTime) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    connectWithInternet(false);

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print(listType);
      String url = "${Request.urlBase}getMyFavorites/$listType/$page/";
      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

      var data = json.decode(response.body);
      if (data['status'] == "success") {
        if (firstTime) {
          list.clear();
        }
        for (var dataList in data['data']) {
          list.add(User.fromJson(dataList));
        }
        return list;
      } else {}
    } else {
      connectWithInternet(true);
    }
    return null;
  }

  reFreshData() async {
    loading(true);
    currentPage(0);
    await getNetwork(activeTab.value, currentPage.value, true).then((value) {
      loading(false);
      currentPage.value++;
    });
  }

  Future changeActiveTab(index) async {
    loading(true);
    activeTab.value = index;
    await getNetwork(index, currentPage.value, true).then((value) {
      loading(false);
      currentPage.value++;
    });
  }

  @override
  void onInit() {
    scrollController = ScrollController();
    reFreshData();
    pagination();
    super.onInit();
  }

  pagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getNetwork(activeTab.value, currentPage.value, false);
        currentPage.value++;
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
