import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/utils/toast.dart';

class SendContactUSMessageController extends GetxController {
  final appController = Get.find<AppController>();

  TextEditingController title = TextEditingController(),
      message = TextEditingController();

  Rx<File> attachment = File('').obs;

  String? otherID = Get.arguments;
  RxString reasonID = MessageType.question.name.obs;

  RxBool sendMessageLoading = false.obs;

  Future<void> sendMessage() async {
    final reasonId = MessageType.values
        .firstWhereOrNull((element) => element.name == reasonID.value);
    if (reasonId == null) return;
    try {
      if (title.text.isEmpty ||
          message.text.isEmpty ||
          (reasonId.id).toString().isEmpty) {
        showToast('يرجي ملئ جميع البيانات المطلوبه');
        return;
      }

      String url = "${Request.urlBase}sendMessage";
      sendMessageLoading(true);
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers
          .addAll({'Authorization': 'Bearer ${appController.apiToken.value}'});

      if (attachment.value.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'attachment', attachment.value.path));
      }
      request.fields.addAll({
        'reasonId': (reasonId.id).toString(),
        'message': message.text,
        'title': title.text,
        if ((otherID ?? '').isNotEmpty) 'otherId': otherID!,
      });
      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((event) async {
        var responseData = json.decode(event);
        if (responseData['status'] == "success") {
          sendMessageLoading(false);
          showToast('تم إرسال الرسالة بنجاح');
        } else {
          sendMessageLoading(false);
          showToast('حدث خطأ يرجي إعادة إرسال الرسالة مرة أخري');
        }
      });
    } catch (e) {
      sendMessageLoading(false);
    }
  }

  Future getImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      attachment(File(pickedFile.path));
    } else {}
  }

  @override
  void onClose() {
    super.onClose();
    title.dispose();
    title.dispose();
  }
}

enum MessageType {
  question(0, 'سؤال'),
  complain(1, 'شكوي'),
  suggestion(2, 'اقتراح');

  final int id;
  final String name;
  const MessageType(this.id, this.name);
}
