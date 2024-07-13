import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/owner.dart';
import 'package:zeffaf/pages/city.list/city.list.controller.dart';
import 'package:zeffaf/utils/detect_urls_or_phone_number.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/toast.dart';

import '../../services/http.service.dart';

class EditAccountController extends GetxController {
  RxBool loading = false.obs;

  final appController = Get.find<AppController>();

  Owner get userData => appController.userData.value;

  final cityListController = Get.put(CityListController());

  TextEditingController jobController = TextEditingController(),
      aboutMeController = TextEditingController(),
      aboutOtherController = TextEditingController();

  RxString mariageKind = ''.obs;
  RxString mariageKindId = ''.obs;
  RxString mariageStatues = ''.obs;
  RxString mariageStatuesId = ''.obs;
  RxString workField = ''.obs;
  RxString workFieldId = ''.obs;
  RxString income = ''.obs;
  RxString incomeId = ''.obs;

  bool get isMan => appController.isMan.value == 0;

  @override
  void onInit() {
    _fillData();
    super.onInit();
  }

  void _fillData() {
    cityListController.countryCodeController
        .countryId((userData.residentCountryId ?? 0).toString());
    jobController.text = userData.job ?? '';
    cityListController.cityId(userData.cityId ?? 0);
    cityListController.cityName(userData.cityName ?? '');
    mariageKindId((userData.mariageKind ?? 0).toString());

    mariageKind(getName(
      InputData.kindOfMarriageList,
      InputData.kindOfMarriageListId,
      mariageKindId.value,
    ));

    mariageStatuesId((userData.mariageStatues ?? 0).toString());

    if (isMan) {
      mariageStatues(getName(
        InputData.socialStatusManList,
        InputData.socialStatusManListId,
        mariageStatuesId.value,
      ));
    } else {
      mariageStatues(getName(
        InputData.socialStatusWomanList,
        InputData.socialStatusWomanListId,
        mariageStatuesId.value,
      ));
    }

    aboutMeController.text = userData.aboutMe ?? '';
    aboutOtherController.text = userData.aboutOther ?? '';
    workFieldId((userData.workField ?? 0).toString());
    workField(getName(
      InputData.jobList,
      InputData.jobListId,
      workFieldId.value,
    ));
    incomeId((userData.income ?? 0).toString());
    income(getName(
      InputData.monthlyIncomeLevelList,
      InputData.monthlyIncomeLevelListId,
      incomeId.value,
    ));
  }

  String getName(List<String> list, List<int> listId, String value) {
    var index = listId.indexOf(int.tryParse(value) ?? 0);
    if (index == -1) return '';
    var name = list.elementAt(index);
    return name.toString();
  }

  Future updateProfile() async {
    final partnerSpecificationsContainInValidData = containsNoUrlOrPhoneNumber(
      aboutOtherController.text,
    );

    final aboutMeContainInValidData = containsNoUrlOrPhoneNumber(
      aboutMeController.text,
    );

    if (!partnerSpecificationsContainInValidData ||
        !aboutMeContainInValidData) {
      showToast('غير مسموح بإدخال أرقام الهواتف أو الايميلات');
      return;
    }

    try {
      if (aboutMeController.text.isEmpty ||
          aboutOtherController.text.isEmpty ||
          jobController.text.isEmpty) {
        showToast('يجب ملئ جميع البيانات');
        return;
      }

      loading(true);
      Map registerBody = {
        'cityId': cityListController.cityId.value.toString(),
        'mariageKind': mariageKindId.value,
        'mariageStatues': mariageStatuesId.value,
        'aboutMe': aboutMeController.text,
        'aboutOther': aboutOtherController.text,
        'workField': workFieldId.value,
        'job': jobController.text,
        'income': incomeId.value,
      };

      var response = await http.post(
        Uri.parse("${Request.urlBase}updateUserDetails"),
        body: registerBody,
        headers: {'Authorization': 'Bearer ${appController.apiToken.value}'},
      );

      print(response.body);
      if (json.decode(response.body)['status'] == "success") {
        Get.offAllNamed(
          '/',
          arguments: true,
        );
      } else {
        loading(false);
        Get.snackbar(
          "خطأ!",
          json.decode(response.body)['message'],
          backgroundColor: Colors.black54,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ!",
        'حدث خطأ يرجي إعادة المحاولة لاحقاً',
        backgroundColor: Colors.black54,
      );
      loading(false);
    }
  }
}
