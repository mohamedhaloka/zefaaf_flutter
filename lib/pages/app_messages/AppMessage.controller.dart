import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/newMessage.modal.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';

class AppMessageController extends GetxController {
  final appController = Get.find<AppController>();
  RxBool checkingForPreviousRequest = false.obs;
  RxList<NewMessagesModal> messages = <NewMessagesModal>[].obs;
  RxBool loading = true.obs;
  RxBool isConnectedToInternet = true.obs;

  @override
  void onInit() {
    getMessageList();
    super.onInit();
  }

  // static getM()async{
  //   return await getMessageList();
  // }
  getMessageList() {
    print("get message list");
    messages.clear();
    getMessages().then((value) {
      messages.addAll(value);
      loading(false);
    });
  }
  setCheckPreviousRequest(bool value) {
    checkingForPreviousRequest(value);
  }

  Future getMessages() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    isConnectedToInternet(false);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String url = "${Request.urlBase}getMessagesList";

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken}'});
      if (response.statusCode == 200) {
        List<NewMessagesModal> newMessage = [];
        var data = json.decode(response.body)['data'];
        for (var message in data) {
          newMessage.add(NewMessagesModal.fromJson(message));
        }
        return newMessage;
      } else {}
    } else {
      isConnectedToInternet(true);
    }
  }

  getMessageDetails(messageId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    isConnectedToInternet(false);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String url = "${Request.urlBase}getMessageDetails/$messageId";

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken}'});
      if (response.statusCode == 200) {
      } else {}
    } else {
      isConnectedToInternet(true);
    }
  }
}
