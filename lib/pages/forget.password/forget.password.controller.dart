import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/services/http.service.dart';

class ForgetPasswordController extends GetxController {
  final appController = Get.find<AppController>();
  RxString mobile = "".obs;
  RxString countryNetworkCode = "".obs;
  RxBool loading = false.obs;
  RxBool rightFormat = false.obs;
  late String simCountryCode;

  final storage = GetStorage();
  var number = PhoneNumber(isoCode: '').obs;
  TextEditingController mobilePhone = TextEditingController();

  writeMobileNumber(String num) {
    storage.write('mobileNumber', num);
  }

  writeCountryCode(code) {
    storage.write('countryCode', code);
  }

  Future checkNumber(context, phoneNumber) async {
    loading(true);
    final response = await http.get(
      Uri.parse("${Request.urlBase}checkMobile/$phoneNumber"),
    );
    var responseDecoded = json.decode(response.body);

    log(responseDecoded.toString(), name: 'FORGET PASSWORD');
    if (responseDecoded['rowsCount'] == 0) {
      loading(false);
      // Get.toNamed(
      //   '/sms_verification',
      //   arguments: [mobile.value, 'register-landing', mobilePhone.text],
      // );

      Get.offAllNamed('/RegisterLandingView');

      return json.decode(response.body);
    } else {
      loading(false);
      Get.snackbar("خطأ", "هذا الرقم مُسجل من قبل، يرجى تسجيل الدخول",
          backgroundColor: Colors.black54);
    }
  }

  @override
  void onInit() {
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
    print('placemarks $placemarks');

    if (placemarks.isEmpty) return;
    Placemark place = placemarks[0];

    simCountryCode = place.isoCountryCode ?? '';
    number.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
  }
}
