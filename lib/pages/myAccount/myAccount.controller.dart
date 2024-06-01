import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';
import '../../utils/toast.dart';

class MyAccountController extends GetxController {
  final appController = Get.find<AppController>();
  RxString user = "".obs;
  RxString fileName = "".obs;
  RxBool noInternet = RxBool(false);
  RxBool uploadImgLoading = RxBool(false);
  final picker = ImagePicker();
  late File filePath;

  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }

  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    noInternet(false);

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      noInternet(false);
    } else {
      noInternet(true);
    }
  }

  Future terminateMyAccount() async {
    String url = "${Request.urlBase}terminateMyAccount";
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});
    uploadImgLoading(true);
    var responseData = json.decode(response.body);
    if (responseData['status'] == "success") {
      uploadImgLoading(false);
      return true;
    } else {
      uploadImgLoading(false);
      return false;
    }
  }

  Future uploadMyPhoto(String attachment, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        String url = "${Request.urlBase}uploadMyPhoto";
        uploadImgLoading(true);
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(
            {'Authorization': 'Bearer ${appController.apiToken.value}'});
        request.files
            .add(await http.MultipartFile.fromPath('attachment', attachment));
        var response = await request.send();

        response.stream.transform(utf8.decoder).listen((event) async {
          var responseData = json.decode(event);
          if (responseData['status'] == "success") {
            await Future.delayed(const Duration(seconds: 1));
            appController
                .userData.value.tempProfileImage!(responseData['fileName']);
            uploadImgLoading(false);
          } else {
            uploadImgLoading(false);
            showToast("حجم الصورة كبير للغايه");
          }
        });
      } catch (e) {
        showToast("تأكد من إتصالك بالإنترنت أولاً");
      }
    }
  }

  void deleteProfilePhotoDialog() {
    Get.dialog(AlertDialog(
      content: const Text("هل تريد حقاً حذف الصورة؟"),
      actions: [
        ElevatedButton(
          onPressed: _deleteProfileImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
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
            backgroundColor: Colors.red,
          ),
          child: const Text("تراجع"),
        ),
      ],
    ));
  }

  Future _deleteProfileImage() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        Get.back();
        String url = "${Request.urlBase}deleteMyProfileImage";
        http.Response response = await http.post(Uri.parse(url), headers: {
          'Authorization': 'Bearer ${appController.apiToken.value}'
        });
        uploadImgLoading(true);
        var responseData = json.decode(response.body);
        if (responseData['status'] == "success") {
          await Future.delayed(const Duration(seconds: 1));
          appController.userData.value.tempProfileImage!('');
          appController.userData.value.profileImage!('');
          uploadImgLoading(false);
          showToast("تم حذف صورتك الشخصية");
        } else {
          uploadImgLoading(false);
          showToast("حدث خطأ، يرجي إعادة المحاولة لاحقاً!");
        }
      } catch (_) {
        showToast("تأكد من إتصالك بالإنترنت أولاً");
      }
    }
  }

  Future getImage() async {
    try {
      var image = await ImagePicker.platform.pickImage(
          source: ImageSource.gallery,
          imageQuality: 30,
          maxHeight: 550,
          maxWidth: 550);
      return image?.path;
    } catch (_) {}
  }
}
