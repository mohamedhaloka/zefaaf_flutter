import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/user.chats.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/services/socketService.dart';

class ChatListController extends GetxController {
  RxString filter = "".obs;
  RxBool loading = true.obs;
  final appController = Get.find<AppController>();
  final socketService = Get.find<SocketService>();
  TextEditingController searchController = TextEditingController(text: "");

  RxList<UserChats> usersList = RxList([]);

  @override
  void onInit() {
    searchController.addListener(() {
      filter.value = searchController.text;
    });
    socketService.updatedChatList.listen((val) {
      getChatsList();
    });
    getChatsList();
    super.onInit();
  }

  getChatsList() async {
    String url = "${Request.urlBase}getMyChatsList";
    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

    var responseData = json.decode(response.body);
    if (responseData['status'] == "success") {
      usersList.clear();
      for (var chats in responseData['data']) {
        usersList.add(UserChats.fromJson(chats));
      }
      loading(false);
    } else {
      loading(false);
    }
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  void showEnsureUserNeedToDeleteChatDialog(
          {required String content,
          bool deleteAllChats = true,
          String? chatId}) =>
      Get.dialog(AlertDialog(
        title: Row(
          children: [
            Text(
              content,
              style: Get.theme.textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 2),
            // const Icon(
            //   CupertinoIcons.trash,
            //   color: Colors.red,
            // ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (deleteAllChats) {
                _hideAllChats();
              } else {
                if (chatId == null) return;
                _hideChat(chatId);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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
              backgroundColor: Get.theme.primaryColor,
            ),
            child: const Text(
              "لا",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ));

  Future<void> _hideAllChats() async {
    loading(true);
    String url = "${Request.urlBase}hideAllChats";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
    );

    var responseData = json.decode(response.body);
    if (responseData['status'] == "success") {
      usersList.clear();

      loading(false);
    } else {
      loading(false);
    }
  }

  Future _hideChat(String chatId) async {
    loading(true);
    String url = "${Request.urlBase}hideChat";
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
        body: {'chatId': "$chatId"});

    var data = json.decode(response.body);

    if (data['status'] == 'success') {
      usersList.removeWhere((element) => element.id.toString() == chatId);
      Get.snackbar("تم بنجاح", "تم حذف المحادثة بنجاح");
    } else {
      Get.snackbar("حدث خطأ!", "يرجي إعادة المحاولة لاحقاً!");
    }
    loading(false);
  }
}
