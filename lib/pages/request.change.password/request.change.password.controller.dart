import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zeffaf/services/http.service.dart';

class RequestChangePasswordController extends GetxController {
  TextEditingController username = TextEditingController();
  RxString mobile = "".obs;
  RxString countryNetworkCode = "".obs;
  late String simCountryCode;
  var number = PhoneNumber(isoCode: '').obs;
  TextEditingController mobilePhone = TextEditingController();

  RxBool loading = false.obs;
  RxBool rightFormat = false.obs;

  void checkPhoneNumber() async {
    loading(true);
    final response = await http.get(
      Uri.parse("${Request.urlBase}checkMobile/${number.value.parseNumber()}"),
    );
    var responseDecoded = json.decode(response.body);

    if (responseDecoded['rowsCount'] == 1) {
      loading(false);
      Get.toNamed('/sms_verification', arguments: [
        mobile.value,
        'change-password',
        mobilePhone.text,
      ]);
    } else {
      loading(false);
      Get.snackbar("خطأ", "هذا الرقم غير مُسجل من قبل، يرجى تسجيل حساب",
          backgroundColor: Colors.black54);
    }
  }

  @override
  void onInit() async {
    // simCountryCode = (await FlutterSimCountryCode.simCountryCode) ?? '';
    // number.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
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
    number.value = PhoneNumber(isoCode: simCountryCode.toUpperCase());
  }
}
