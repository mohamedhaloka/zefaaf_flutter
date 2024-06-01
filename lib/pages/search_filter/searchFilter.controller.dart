import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/user.dart';
import 'package:zeffaf/pages/city.list/city.list.controller.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';

import '../../appController.dart';

class SearchFilterController extends GetxController {
  final appController = Get.find<AppController>();
  CountryCodeController countryCodeController =
      Get.put(CountryCodeController());
  CityListController cityListController = Get.put(CityListController());
  TextEditingController searchController = TextEditingController(text: "");
  ScrollController scrollController = ScrollController();
  RxList<User> userDataList = RxList([]);
  RxBool searching = RxBool(false);
  RxBool searchByUserOnly = RxBool(false);
  RxBool connectToInternet = RxBool(false);

  /// filter data id
  RxString nationality = "".obs;
  RxString socialStatusId = "".obs;
  RxString marriageTypeId = "".obs;
  RxString workFieldId = "".obs;
  RxString financialStatusId = "".obs;
  RxString educationId = "".obs;
  RxString barrierId = "".obs;

  /// filter data
  RxString socialStatus = "".obs;
  RxString marriageType = "".obs;
  RxString workField = "".obs;
  RxString financialStatus = "".obs;
  RxString education = "".obs;
  RxString barrier = "".obs;
  RxString userName = "".obs;
  RxString weightFrom = "".obs;
  RxString weightTo = "".obs;
  RxString heightFrom = "".obs;
  RxString heightTo = "".obs;
  RxString ageFrom = "".obs;
  RxString ageTo = "".obs;

  RxInt countryId = 0.obs;

  emptyValues() {
    // result.emptyValues();
  }

  @override
  void onInit() {
    searchController.addListener(() {
      userName.value = searchController.text;
    });
    super.onInit();
  }

  @override
  void onClose() {
    countryCodeController.nationalityName.value = "";
    countryCodeController.countryName.value = "";
    cityListController.cityName.value = "";
    super.onClose();
  }
}
