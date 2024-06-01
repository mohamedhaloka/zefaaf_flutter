import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';
import '../../utils/upgrade_package_dialog.dart';

class NewMessageController extends GetxController {
  final appController = Get.find<AppController>();

  RxString socialStatusId = "".obs;
  RxString socialStatus = "".obs;

  RxString kindOfMarriageId = "".obs;
  RxString kindOfMarriage = "".obs;

  RxString messageType = "".obs;
  RxString address = "".obs;
  late Rx<TextEditingController> aboutMe;
  late TextEditingController aboutOther;

  late TextEditingController thanksMessage;
  late Rx<TextEditingController> title;
  late TextEditingController whatsapp;
  late TextEditingController age;
  RxBool loading = false.obs;
  var pickedFile;
  Rx<File> image = File('').obs;
  final picker = ImagePicker();

  var whatsApp = PhoneNumber(isoCode: '').obs;
  late String simCountryCode;

  @override
  void onInit() async {
    aboutMe = TextEditingController().obs;
    aboutOther = TextEditingController();
    thanksMessage = TextEditingController();
    title = TextEditingController().obs;
    whatsapp = TextEditingController();
    age = TextEditingController();

    // simCountryCode = (await FlutterSimCountryCode.simCountryCode) ?? '';
    // whatsApp.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
    getCountryCode();
    super.onInit();
  }

  void getCountryCode() async {
    final permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) return;
    final Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isEmpty) return;
    Placemark place = placemarks[0];

    simCountryCode = place.isoCountryCode ?? '';
    whatsApp.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
  }

  @override
  void onReady() {
    // if(appController.isMan.value == 1){
    //   showUpgradePackageDialog(shouldUpgradeToSilverPackage);
    //   return;
    // }
    if (appController.userData.value.packageLevel! <= 3 &&
        appController.isMan.value != 1) {
      showUpgradePackageDialog(shouldUpgradeToPlatinumPackage);
      return;
    }
    super.onReady();
  }

  Future sendMessages() async {
    try {
      loading(true);
      String url = "${Request.urlBase}marriageRequest";

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // request.fields['reasonId'] = reasonId;
      request.fields['whats'] = whatsApp.value.phoneNumber.toString();
      request.fields['realName'] = title.value.text;
      request.fields['age'] = age.text;
      request.fields['mariageStatues'] = socialStatusId.value;
      request.fields['mariageKind'] = kindOfMarriageId.value;
      request.fields['thanksMessage'] = thanksMessage.text;
      request.fields['aboutMe'] = aboutMe.value.text;
      request.fields['aboutOther'] = aboutOther.text;
      // if (attachment != null) {
      //   request.files
      //       .add(await http.MultipartFile.fromPath('attachment', attachment));
      // }

      request.headers
          .addAll({'Authorization': 'Bearer ${appController.apiToken.value}'});

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((event) {
        // var responseData = json.decode(event);
        if (response.statusCode == 200) {
          Get.snackbar(
            "تهانينا",
            "تم إرسال طلبك للمراجعة ومن ثم النشر",
            backgroundColor: Colors.black54,
          );
          messageType.value = "";
          aboutMe.value.clear();
          title.value.clear();
          whatsapp.clear();
          aboutOther.clear();
          thanksMessage.clear();
          age.clear();
          socialStatusId('');
          socialStatus('');
          kindOfMarriageId('');
          kindOfMarriage('');

          // Get.find<AppMessageController>().messages.insert(
          //     0,
          //     NewMessagesModal(
          //         image: responseData['attachment'],
          //         id: int.parse(responseData['id']),
          //         message: responseData['message'],
          //         title: responseData['title'],
          //         messageDateTime: DateTime.now()
          //             .subtract(
          //                 Duration(hours: appController.timeZoneOffset.value))
          //             .toString(),
          //         userId: int.parse(responseData['otherId']),
          //         reasonId: int.parse(responseData['reasonId'])));

          image(File(''));
          pickedFile = null;
          loading(false);
        } else {
          String errorMessage = "";
          if (response.statusCode == 400)
            errorMessage = " يجب اكمال جميع البيانات لارسال الطلب";
          else
            errorMessage = "لم يتم إرسال رسالتك، يرجى معاودة إرسالها مرةً أخرى";

          Get.snackbar("خطأ!", errorMessage, backgroundColor: Colors.black54);
          loading(false);
        }
      });
    } catch (e) {
      Get.snackbar("خطأ!", "لم يتم إرسال رسالتك، يرجى معاودة إرسالها مرةً أخرى",
          backgroundColor: Colors.black54);
      loading(false);
    }
  }

  Future getImage() async {
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    } else {}
  }

  @override
  void onClose() {
    super.onClose();
    aboutMe.value.clear();
    aboutMe.value.dispose();
    title.value.clear();
    title.value.dispose();
  }
}
