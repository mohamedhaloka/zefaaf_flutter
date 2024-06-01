import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';

class MessageDetailsController extends GetxController {
  final appController = Get.find<AppController>();

  TextEditingController replyController = TextEditingController();

  Rx<File> attachment = File('').obs;
  final picker = ImagePicker();

  RxBool loading = false.obs;

  Future replyMessage(id, reply) async {
    if (replyController.text.isEmpty) {
      Get.snackbar("إنتبه!", "يجب كتابة رد", backgroundColor: Colors.black54);
      return;
    }
    String url = "${Request.urlBase}replyMessage";
    loading(true);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers
        .addAll({'Authorization': 'Bearer ${appController.apiToken.value}'});

    request.fields['id'] = id;
    request.fields['reply'] = reply;

    if (attachment.value.path != '') {
      request.files.add(await http.MultipartFile.fromPath(
          'attachment', attachment.value.path));
      print(request.files);
      print(attachment.value.path);
    }
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((event) {
      loading(false);
      var responseData = json.decode(event);
      if (response.statusCode == 200) {
        Get.back(result: true);
        replyController.clear();
        Get.snackbar("تم إرسال رسالتك", "بنجاح",
            backgroundColor: Colors.black54);
      } else {
        Get.snackbar(
            "خطاء!", "لم يتم إرسال الرساله .. تأكد من إتصالك بالإنترنت",
            backgroundColor: Colors.black54);
      }
    });
  }

  Future getImage() async {
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
        imageQuality: 40);

    if (pickedFile != null) {
      print(pickedFile.path);
      attachment.value = File(pickedFile.path);
    } else {}
  }
}
