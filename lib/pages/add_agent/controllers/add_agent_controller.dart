import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../../utils/toast.dart';

class AddAgentController extends GetxController {
  //init appController to use all vars in it
  final appController = Get.find<AppController>();
  //this var for showing loading before get data from api
  RxBool loading = false.obs;
  //vars for number
  late String simCountryCode;
  var phoneNumber = PhoneNumber(isoCode: '').obs;
  var whatsApp = PhoneNumber(isoCode: '').obs;

  //this var to put user inputs in it
  /*
  * 1- Agent name, 2- Agent email,
  * 3- Agent phone, 4- Agent whatsapp
  * 5- Paypal account
  * */
  late TextEditingController agentName, agentEmail, agentMobile, agentWhats;

  CountryCodeController countryCodeController =
      Get.put(CountryCodeController());

  //this var for photo
  var pickedFile;
  Rx<File> image = File('').obs;
  final picker = ImagePicker();

  @override
  void onInit() async {
    //init controllers
    agentName = TextEditingController();
    agentEmail = TextEditingController();
    agentMobile = TextEditingController();
    agentWhats = TextEditingController();

    getCountryCode();
    // simCountryCode = (await FlutterSimCountryCode.simCountryCode) ?? '';
    // phoneNumber.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
    // whatsApp.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());

    super.onInit();
  }

  void getCountryCode() async {
    final permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) return;
    final Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isEmpty) return;
    Placemark place = placemarks[0];

    simCountryCode = place.isoCountryCode ?? '';
    phoneNumber.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
    whatsApp.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
  }

  Future getImage() async {
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    } else {}
  }

  addAgent(attachment) async {
    try {
      loading(true);
      String url = "${Request.urlBase}addAgent";

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields.addAll({
        'name': agentName.text,
        'email': agentEmail.text,
        'mobile': phoneNumber.value.phoneNumber!,
        'whats': whatsApp.value.phoneNumber!,
        'countryId': countryCodeController.nationalityId.value,
        'paypalAccount': '',
      });

      request.files
          .add(await http.MultipartFile.fromPath('attachment', attachment));

      request.headers
          .addAll({'Authorization': 'Bearer ${appController.apiToken.value}'});

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((event) {
        var responseData = json.decode(event);
        if (response.statusCode == 200) {
          Get.snackbar("تهانينا", "تم إرسال طلب الإنضمام بنجاح!",
              backgroundColor: Colors.black54);

          clearData();
          loading(false);
        } else {
          Get.snackbar(
              "خطأ!", "لم يتم إرسال رسالتك، يرجى معاودة إرسالها مرةً أخرى",
              backgroundColor: Colors.black54);
          loading(false);
        }
      });
    } catch (e) {
      loading(false);
    }
  }

  clearData() {
    image(File(''));
    pickedFile = null;
    agentName.clear();
    agentEmail.clear();
    agentMobile.clear();
    agentWhats.clear();
    countryCodeController.nationalityName('');
    countryCodeController.nationalityImage('');
    countryCodeController.nationalityCode('');
    countryCodeController.nationalityId('');
  }

  validateAddAgent(attachment, context) {
    if (checkVal()) {
      addAgent(attachment);
    } else {
      showToast('يجب ملئ جميع البيانات');
    }
  }

  checkVal() =>
      agentName.text.isNotEmpty &&
      agentEmail.text.isNotEmpty &&
      agentMobile.text.isNotEmpty &&
      countryCodeController.nationalityId.value != '';

  @override
  void onClose() {}
}
