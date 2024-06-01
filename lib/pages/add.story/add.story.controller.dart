import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../utils/toast.dart';

class AddStoryController extends GetxController {
  final appController = Get.find<AppController>();
  RxBool loading = false.obs;
  late Rx<TextEditingController> yourName;
  late Rx<TextEditingController> otherUserName;
  late Rx<TextEditingController> story;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    yourName = TextEditingController().obs;
    otherUserName = TextEditingController().obs;
    story = TextEditingController().obs;
    super.onInit();
  }

  Future addSuccessStories({otherUserName, story, context}) async {
    try {
      loading(true);
      String url = "${Request.urlBase}addSuccessStory";
      http.Response response = await http.post(Uri.parse(url), body: {
        'otherUserName': otherUserName,
        'story': story,
      }, headers: {
        'Authorization': 'Bearer ${appController.apiToken.value}'
      });

      var responseDecoded = json.decode(response.body);
      if (responseDecoded['status'] == "success") {
        yourName.value.clear();
        this.otherUserName.value.clear();
        this.story.value.clear();
        loading(false);
        showToast('تم إضافة القصة بنجاح');
      } else {
        loading(false);
        showToast('تأكد من اسم المستخدم وأعد المحاولة');
      }
    } catch (_) {}
  }
}
