import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/city.modal.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/services/http.service.dart';

class CityListController extends GetxController {
  final appController = Get.find<AppController>();
  RxString cityName = "".obs;
  RxString filter = "".obs;
  RxInt cityId = 0.obs;
  int pages = 5;
  int currentPage = 0;
  RxBool cityLoading = true.obs;
  TextEditingController searchController = TextEditingController(text: "");
  ScrollController scrollController = ScrollController();
  CountryCodeController countryCodeController =
      Get.put(CountryCodeController());

  RxList<CityModal> cityDataList = RxList([]);

  Future<List<CityModal>?> getCityList(page) async {
    String news =
        '${Request.urlBase}getCities/${countryCodeController.countryId}/';
    http.Response response = await http.get(Uri.parse(news));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var jsonArticles = body['data'];
      List<CityModal> cityData = [];
      for (var item in jsonArticles) {
        cityData.add(CityModal.fromJson(item));
      }
      return cityData;
    } else {
      return null;
    }
  }

  @override
  void onClose() {
    searchController.text = "";
    searchController.dispose();
    super.onClose();
  }
}
