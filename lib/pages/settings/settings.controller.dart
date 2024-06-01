import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/models/country.code.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';

class SettingsController extends GetxController {
  final storage = GetStorage();
  final appController = Get.find<AppController>();
  double maxAge = 65;
  double minAge = 18;
  RxBool notifications = RxBool(true);
  RxBool nightMode = RxBool(false);
  RxBool loading = RxBool(false);
  RxBool loadingToLoadMultiData = RxBool(true);
  RxBool fingerPrint = RxBool(false);
  List<String> countrySelections = [];
  List<String> fontSizeSelections = [];

  RxString countryCode = "".obs;
  RxString countryName = "".obs;
  RxString countryImage = "".obs;
  RxString placeCode = "".obs;
  RxString placeName = "".obs;
  RxString placeImage = "".obs;
  RxString fontSizeType = "".obs;
  late RxString valueFromFontSize;
  RxString ageFrom = "".obs;
  RxString ageTo = "".obs;

  //Country List
  RxList<String> contactsNationalityNameList = RxList([]);
  RxList<String> contactResidentNameList = RxList([]);
  RxList<CountryData> countryList = RxList([]);
  RxList<String> countrySelectedList = RxList([]);
  RxList<String> countryIdList = RxList([]);
  RxList<String> countryNameList = RxList([]);
  RxList<String> countryShortNameList = RxList([]);
  RxBool countryLoading = true.obs;

  updateDarkTheme(bool value) {
    appController.changeThemeMode(value);
  }

  updateNotification(bool value) {
    appController.changeNotification(value);
  }

  isDarkMode() {
    bool isDark = storage.read('darkmode');
    nightMode.value = isDark;
  }

  notificationStatue() {
    bool notificationStatue = storage.read('notificationStatue');
    notifications.value = notificationStatue;
  }

  fingerPrintStatue(bool val) {
    appController.updateFingerPrint(val);
  }

  Future<void> getSettings() async {
    String url = "${Request.urlBase}getMySettings";

    var loginByTokenHeader = {
      'Authorization': 'Bearer ${appController.apiToken.value}'
    };

    http.Response response = await http.get(
      Uri.parse(url),
      headers: loginByTokenHeader,
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      ageFrom(
          getValue(decodedResponse['data'][0]['contactAgesFrom'].toString()));
      ageTo(getValue(decodedResponse['data'][0]['contactAgesTo'].toString()));
      Get.find<CountryCodeController>().getCountryList().then((value) {
        countryList.add(CountryData(
          phoneCode: "",
          id: 0,
          shortcut: "all",
          nameEn: "All",
          nameAr: "الكل",
          currencyEn: "",
          currencyAr: "",
          timezone: 0,
        ));
        countryList.addAll(value!);
        countryLoading(false);
        print(countryList.length);
        for (int i = 0; i < countryList.length; i++) {
          countryIdList.add(countryList[i].id.toString());
          countryNameList.add(countryList[i].nameAr ?? '');
          countryShortNameList.add(countryList[i].shortcut!.toLowerCase());
        }
        getLists();
      });
    }
  }

  @override
  void onInit() {
    getSettings();
    fontSizeSelections = [
      "صغير",
      "متوسط (الإفتراضي)",
      "كبير",
    ].obs;
    valueFromFontSize = appController.fontSize.value == 6.0
        ? "كبير".obs
        : appController.fontSize.value == -3.0
            ? "صغير".obs
            : "متوسط (الإفتراضي)".obs;
    fingerPrint.value = appController.fingerprintStatue.value;
    isDarkMode();
    notificationStatue();
    super.onInit();
  }

  String getValue(String value) {
    if (value == '0') {
      return 'الكل';
    }
    return value;
  }

  getLists() {
    contactsNationalityNameList.value = getListOfNamedSelected(
        list: appController.contactsNationalityList.value,
        listName: contactsNationalityNameList.value,
        listId: countryIdList.value,
        customList: countryNameList.value);

    contactResidentNameList.value = getListOfNamedSelected(
        list: appController.contactResidentList.value,
        listName: contactResidentNameList.value,
        listId: countryIdList.value,
        customList: countryNameList.value);

    loadingToLoadMultiData(false);
  }

  getListOfNamedSelected({list, listName, listId, customList}) {
    for (int i = 0; i < list.length; i++) {
      int index = listId.indexOf(list[i]);
      listName.add(customList.elementAt(index == -1 ? 0 : index));
    }
    return listName;
  }

  Future saveSettings(
      {notifications, nationalities, residents, agesFrom, agesTo}) async {
    loading(true);
    String url = "${Request.urlBase}updateMySettings";
    http.Response response = await http.post(Uri.parse(url), body: {
      'notifications': notifications,
      'nationalities': nationalities,
      'residents': residents,
      'agesFrom': "$agesFrom",
      'agesTo': "$agesTo",
    }, headers: {
      'Authorization': 'Bearer ${appController.apiToken.value}'
    });
    var data = json.decode(response.body);

    if (data['status'] == "success") {
      loading(false);
      return data['rowsCount'];
    } else {
      loading(false);
    }
  }
}
