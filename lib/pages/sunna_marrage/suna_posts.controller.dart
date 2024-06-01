import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/post.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';
import '../posts/posts.api.dart';

class SunnaMarriageController extends GetxController {
  final appController = Get.find<AppController>();
  ScrollController scrollController = ScrollController();
  int category = 1;
  RxList<Post> posts = RxList([]);
  RxBool loading = true.obs;
  RxBool fetch = false.obs;
  RxInt currentPage = RxInt(0);
  late Request request;
  RxBool isNotConnectedToInternet = false.obs;

  @override
  void onInit() {
    request = Request(apiToken: appController.apiToken.value);
    pagination();
    getSunnaPosts(category: category, page: currentPage.value, val: false);
    super.onInit();
  }

  Future<void> getSunnaPosts({category, page, val}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    isNotConnectedToInternet(false);

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      fetch(val);
      String url = "${Request.urlBase}getPosts/$category/$page";
      http.Response response = await http.get(Uri.parse(url));
      if (json.decode(response.body)['status'] == 'success') {
        List data = json.decode(response.body)['data'];

        if (data.isEmpty) {
          fetch(false);
          currentPage(page - 1);
        }
        for (var categoryPostList in data) {
          posts.add(Post.fromJson(categoryPostList));
        }
        loading(false);
        Future.delayed(const Duration(milliseconds: 500), () {
          fetch(false);
        });
      } else {}
    } else {
      isNotConnectedToInternet(true);
    }
  }

  updateBlogViews(blogId) async {
    await PostsAPI.increaseBlogView(
        appController: appController, blogId: blogId);
  }

  pagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage.value++;
        getSunnaPosts(category: category, page: currentPage.value, val: true);
      }
    });
  }
}
