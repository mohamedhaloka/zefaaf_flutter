import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/country.code.dart';
import 'package:zeffaf/services/http.service.dart';

class CountryCodeController extends GetxController {
  final appController = Get.find<AppController>();
  //Country
  RxString countryCode = "".obs;
  RxString countryName = "".obs;
  RxString countryImage = "".obs;
  RxString countryId = "".obs;

  //Nationality
  RxString nationalityCode = "".obs;
  RxString nationalityName = "".obs;
  RxString nationalityImage = "".obs;
  RxString nationalityId = "".obs;

  RxBool countryLoading = true.obs;
  RxString filter = "".obs;
  TextEditingController searchController = TextEditingController(text: "");
  ScrollController scrollController = ScrollController();

  RxList<CountryData> countryDataList = RxList([]);

  Future<List<CountryData>?> getCountryList() async {
    String news = '${Request.urlBase}getCountries/';
    http.Response response = await http.get(Uri.parse(news));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var jsonArticles = body['data'];
      List<CountryData> countryData = [];
      for (var item in jsonArticles) {
        countryData.add(CountryData.fromJson(item));
      }
      return countryData;
    } else {
      return null;
    }
  }

  fetchData() {
    getCountryList().then((value) {
      countryDataList.add(CountryData(
        phoneCode: "",
        id: 0,
        shortcut: "all",
        nameEn: "All",
        nameAr: "الكل",
        currencyEn: "",
        currencyAr: "",
        timezone: 0,
      ));
      countryDataList.addAll(value!);

      countryLoading(false);
    });
  }

  @override
  void onInit() {
    searchController.addListener(() {
      filter.value = searchController.text;
    });
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.clear();
    searchController.dispose();
    super.onClose();
  }
}
