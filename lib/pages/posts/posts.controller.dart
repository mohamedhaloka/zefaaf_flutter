import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/post.categories.dart';
import 'package:zeffaf/models/post.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';
import 'posts.api.dart';

class PostsController extends GetxController {
  final appController = Get.find<AppController>();

  RxList<PostsCategoriesModal> categories = RxList([]);
  RxList<Post> posts = RxList([]);
  ScrollController scrollController = ScrollController();
  RxBool loadingCategory = true.obs;
  RxBool loadingCategoryPosts = true.obs;
  RxBool isNotConnectedToInternet = false.obs;
  RxBool fetch = false.obs;
  RxInt category = 2.obs;
  RxInt currentPage = 0.obs;
  RxInt activeTab = RxInt(0);

  Future getCategories() async {
    String url = "${Request.urlBase}getPostsCategories";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      categories.clear();
      for (var postCategories in data['data']) {
        categories.add(PostsCategoriesModal.fromJson(postCategories));
      }
      loadingCategoryPosts(false);
      activeTab.value = categories.first.id ?? 0;

      return categories.first.id;
    } else {}
    loadingCategoryPosts(false);
  }

  Future<void> getCategoryPosts(category, page, val) async {
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
        loadingCategory(false);
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
        getCategoryPosts(category.value, currentPage.value, true);
      }
    });
  }

  @override
  void onInit() {
    getCategories().then((value) {
      getCategoryPosts(value, 0, false);
    });
    pagination();
    super.onInit();
  }
}
