import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/settings/settings.controller.dart';

class ListSelectMultiItemController extends GetxController {
  RxString filter = "".obs;
  TextEditingController searchController = new TextEditingController(text: "");
  final appController = Get.find<AppController>();
  final settingController = Get.find<SettingsController>();
  // final autoSearchSettingController = Get.find<AutoSearchSettingController>();
  RxBool valBool = RxBool(true);
  RxList<String> disabledList = RxList([]);

  @override
  void onInit() {
    searchController.addListener(() {
      filter.value = searchController.text;
    });
    // print(disabledList.value);
    // disabledList.value = InputData.financialStatusListId
    //         .map((e) => e.toString())
    //         .toList() +
    //     InputData.educationalQualificationListId
    //         .map((e) => e.toString())
    //         .toList() +
    //     // autoSearchSettingController.countryIdList
    //     //     .map((e) => e.toString())
    //     //     .toList() +
    //     // settingController.countryIdList.map((e) => e.toString()).toList() +
    //     InputData.skinColourListId.map((e) => e.toString()).toList() +
    //     InputData.barrierListId.map((e) => e.toString()).toList() +
    //     InputData.jobListId.map((e) => e.toString()).toList() +
    //     InputData.monthlyIncomeLevelListId.map((e) => e.toString()).toList() +
    //     InputData.healthStatusListId.map((e) => e.toString()).toList();

    disabledList.remove("0");

    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }
}
