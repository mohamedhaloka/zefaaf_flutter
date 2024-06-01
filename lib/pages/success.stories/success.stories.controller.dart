import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/success.stories.model.dart';

import '../../services/http.service.dart';

class SuccessStoriesController extends GetxController {
  RxList<SuccessStoriesModel> successStoriesList = RxList([]);
  final appController = Get.find<AppController>();
  ScrollController scrollController = ScrollController();
  RxBool loading = false.obs;
  RxInt currentPage = RxInt(0);
  RxBool fetch = false.obs;
  RxBool isNotConnectedToInternet = false.obs;

  Future getSuccessStoriesData({page, val, fetchVal}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isNotConnectedToInternet(false);
      if (loading.value != true) {
        loading(val);
        fetch(fetchVal);
        var response = await http
            .get(Uri.parse('${Request.urlBase}getSuccessStories/$page'));

        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List successPost = responseData['data'];
          if (successPost.isEmpty) {
            fetch(false);
            currentPage(page - 1);
          }
          for (var successStories in responseData['data']) {
            successStoriesList
                .add(SuccessStoriesModel.fromJson(successStories));
          }
          loading(false);
          Future.delayed(const Duration(milliseconds: 500), () {
            fetch(false);
          });
        } else {}
      }
    } else {
      isNotConnectedToInternet(true);
    }
  }

  @override
  void onInit() {
    getSuccessStoriesData(page: currentPage.value, val: true, fetchVal: false);
    pagination();
    super.onInit();
  }

  pagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage.value++;
        getSuccessStoriesData(
            page: currentPage.value, val: false, fetchVal: true);
      }
    });
  }
}
