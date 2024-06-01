import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/models/country.code.dart';
import 'package:zeffaf/pages/auto.search/auto.search.controller.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/utils/input_data.dart';

import '../../utils/toast.dart';

class AutoSearchSettingController extends GetxController {
  final appController = Get.find<AppController>();
//First:Get My Setting
  //الحاله الجتماعية
  RxList<String> socialStatus = RxList([]);
  RxList<String> socialStatusNameSelected = RxList([]);
  RxString socialStatusCount = RxString("0");
  //نوع الزواج
  RxList<String> marriageType = RxList([]);
  RxList<String> marriageTypeNameSelected = RxList([]);
  RxString marriageTypeCount = RxString("0");
  //الصلاة
  RxList<String> prayer = RxList([]);
  RxList<String> prayerNameSelected = RxList([]);
  RxString prayerCount = RxString("0");
  //الحجاب
  RxList<String> barrier = RxList([]);
  RxList<String> barrierNameSelected = RxList([]);
  RxString barrierCount = RxString("0");
  //حالة التدخين
  RxList<String> smoking = RxList([]);
  RxList<String> smokingNameSelected = RxList([]);
  RxList<String> sendSmoking = RxList([]);
  RxList<String> receiveSmoking = RxList([]);
  RxString smokingCount = RxString("0");
  //الدولة
  RxList<String> residentCountryId = RxList([]);
  RxList<String> residentCountryNameSelected = RxList([]);
  RxString residentCountryCount = RxString("0");
  //الجنسية
  RxList<String> nationalityCountryId = RxList([]);
  RxList<String> nationalityNameSelected = RxList([]);
  RxString nationalityCountryCount = RxString("0");
  //المدينة
  // RxList<String> cityId = RxList([]);
  // RxList<String> cityNameSelected = RxList([]);
  // RxString cityCount = RxString("0");
  //لون البشرة
  RxList<String> skinColor = RxList([]);
  RxList<String> skinColorNameSelected = RxList([]);
  RxString skinColorCount = RxString("0");
  //التعليم
  RxList<String> education = RxList([]);
  RxList<String> educationNameSelected = RxList([]);
  RxString educationCount = RxString("0");
  //مستوى المعيشه
  RxList<String> financial = RxList([]);
  RxList<String> financialNameSelected = RxList([]);
  RxString financialCount = RxString("0");
  //العمل
  RxList<String> workField = RxList([]);
  RxList<String> workFieldNameSelected = RxList([]);
  RxString workFieldCount = RxString("0");
  //الدخل الشهرى
  RxList<String> income = RxList([]);
  RxList<String> incomeNameSelected = RxList([]);
  RxString incomeCount = RxString("0");
  //الحالة الصحية
  RxList<String> health = RxList([]);
  RxList<String> healthNameSelected = RxList([]);
  RxString healthCount = RxString("0");

  //Age Slider
  RxString ageFrom = RxString("");
  RxString ageTo = RxString("");
  //Width Slider
  RxString weightFrom = RxString("");
  RxString weightTo = RxString("");
  //Height Slider
  RxString heightFrom = RxString("");
  RxString heightTo = RxString("");
  //Prayer

  //Smoking
  // RxBool yes = false.obs;
  // RxBool no = false.obs;
  // RxBool smoking = RxBool();
  //Resident and Nationality
  RxList<CountryData> countryList = RxList([]);
  RxList<String> countrySelectedList = RxList([]);
  RxList<String> countryIdList = RxList([]);
  RxList<String> countryNameList = RxList([]);
  RxList<String> countryShortNameList = RxList([]);
  RxBool countryLoading = true.obs;
  //Loading
  RxBool loadingGetSetting = RxBool(true);
  RxBool loadingSaveSetting = RxBool(false);

  getMySearchSetting() async {
    try {
      String url = "${Request.urlBase}getMySearchSettings";

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

      var responseDecoded = json.decode(response.body);
      if (responseDecoded['status'] == "success") {
        if (responseDecoded['data'].isNotEmpty) {
          Map<String, dynamic> data = responseDecoded['data'][0];
//Get Social Status List
          socialStatus.value = data['mariageStatues'] == ""
              ? []
              : data['mariageStatues'].toString().split(",");
          socialStatusCount("${socialStatus.length}");

          String socialString = socialStatus.toString().replaceAll(",", "و");

          socialStatusNameSelected.value = getListOfNamedSelected(
              list: socialStatus.value,
              listName: socialStatusNameSelected.value,
              listId: appController.isMan.value == 0
                  ? InputData.socialStatusWomanSearchListId
                      .map((e) => e.toString())
                      .toList()
                  : InputData.socialStatusManSearchListId
                      .map((e) => e.toString())
                      .toList(),
              customList: appController.isMan.value == 0
                  ? InputData.socialStatusWomanSearchList
                  : InputData.socialStatusManSearchList);

          marriageType.value = data['mariageKind'] == ""
              ? []
              : data['mariageKind'].toString().split(",");
          marriageTypeCount("${marriageType.length}");

          marriageTypeNameSelected.value = getListOfNamedSelected(
              list: marriageType.value,
              listName: marriageTypeNameSelected.value,
              listId: InputData.kindOfMarriageSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.kindOfMarriageSearchList);

          prayer.value =
              data['prayer'] == "" ? [] : data['prayer'].toString().split(",");
          prayerCount("${prayer.length}");

          prayerNameSelected.value = getListOfNamedSelected(
              list: prayer.value,
              listName: prayerNameSelected.value,
              listId:
                  InputData.praySearchListId.map((e) => e.toString()).toList(),
              customList: InputData.praySearchList);

          barrier.value =
              data['veil'] == null ? [] : data['veil'].toString().split(",");
          barrierCount("${barrier.length}");

          barrierNameSelected.value = getListOfNamedSelected(
              list: barrier.value,
              listName: barrierNameSelected.value,
              listId: InputData.barrierSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.barrierSearchList);

          receiveSmoking.value = data['smoking'] == ""
              ? []
              : data['smoking'].toString().split(",");

          for (var element in receiveSmoking) {
            if (element == "-1") {
              smoking.add("0");
            }
            if (element == "0") {
              smoking.add("2");
            }
            if (element == "1") {
              smoking.add("1");
            }
          }

          smokingCount("${smoking.length}");

          smokingNameSelected.value = getListOfNamedSelected(
              list: smoking.value,
              listName: smokingNameSelected.value,
              listId: ['0', '1', '2'],
              customList: ['الكل', 'نعم', 'لا']);

          residentCountryId.value = data['residentCountryId'] == ""
              ? []
              : data['residentCountryId'] == "-1" ||
                      data['residentCountryId'] == -1
                  ? ['0']
                  : data['residentCountryId'].toString().split(",");
          residentCountryCount("${residentCountryId.length}");

          residentCountryNameSelected.value = getListOfNamedSelected(
              list: residentCountryId.value,
              listName: residentCountryNameSelected.value,
              listId: countryIdList.value,
              customList: countryNameList.value);

          nationalityCountryId.value = data['nationalityCountryId'] == ""
              ? []
              : data['nationalityCountryId'] == "-1" ||
                      data['nationalityCountryId'] == -1
                  ? ['0']
                  : data['nationalityCountryId'].toString().split(",");
          nationalityCountryCount("${nationalityCountryId.length}");

          nationalityNameSelected.value = getListOfNamedSelected(
              list: nationalityCountryId.value,
              listName: nationalityNameSelected.value,
              listId: countryIdList.value,
              customList: countryNameList.value);

          skinColor.value = data['skinColor'] == ""
              ? []
              : data['skinColor'].toString().split(",");
          skinColorCount("${skinColor.length}");

          skinColorNameSelected.value = getListOfNamedSelected(
              list: skinColor.value,
              listName: skinColorNameSelected.value,
              listId: InputData.skinColourSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.skinColourSearchList);

          education.value = data['education'] == ""
              ? []
              : data['education'].toString().split(",");
          educationCount("${education.length}");

          educationNameSelected.value = getListOfNamedSelected(
              list: education.value,
              listName: educationNameSelected.value,
              listId: InputData.educationalQualificationSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.educationalQualificationSearchList);

          financial.value = data['financial'] == ""
              ? []
              : data['financial'].toString().split(",");
          financialCount("${financial.length}");

          financialNameSelected.value = getListOfNamedSelected(
              list: financial.value,
              listName: financialNameSelected.value,
              listId: InputData.financialStatusSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.financialStatusSearchList);

          workField.value = data['workField'] == ""
              ? []
              : data['workField'].toString().split(",");
          workFieldCount("${workField.length}");

          workFieldNameSelected.value = getListOfNamedSelected(
              list: workField.value,
              listName: workFieldNameSelected.value,
              listId:
                  InputData.jobSearchListId.map((e) => e.toString()).toList(),
              customList: InputData.jobSearchList);

          income.value =
              data['income'] == "" ? [] : data['income'].toString().split(",");
          incomeCount("${income.length}");
          incomeNameSelected.value = getListOfNamedSelected(
              list: income.value,
              listName: incomeNameSelected.value,
              listId: InputData.monthlyIncomeLevelSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.monthlyIncomeLevelSearchList);

          health.value =
              data['helath'] == "" ? [] : data['helath'].toString().split(",");
          healthCount("${health.length}");

          healthNameSelected.value = getListOfNamedSelected(
              list: health.value,
              listName: healthNameSelected.value,
              listId: InputData.healthStatusSearchListId
                  .map((e) => e.toString())
                  .toList(),
              customList: InputData.healthStatusSearchList);

          ageTo(value(data['ageTo'].toString()));
          ageFrom(value(data['ageFrom'].toString()));

          weightFrom(value(data['weightFrom'].toString()));
          weightTo(value(data['weightTo'].toString()));
          print(data['heightTo']);

          heightFrom(value(data['heightFrom'].toString()));
          heightTo(value(data['heightTo'].toString()));
        } else {}
        loadingGetSetting(false);
      }
    } catch (e) {
      loadingGetSetting(false);
    }
  }

  String value(String dataValue) {
    if (dataValue == '0') {
      return 'الكل';
    }
    return dataValue;
  }

  getSaveSettingsData(List list, int dataSource, List listId) {
    try {
      var index = listId.indexOf(dataSource);
      var data = list.elementAt(index);
      return data.toString();
    } catch (e) {}
  }

//socialStatus.value  //socialSttatusNamed  //Full list Id  //Full List Named
  getListOfNamedSelected({list, listName, listId, customList}) {
    for (int i = 0; i < list.length; i++) {
      int index = listId.indexOf(list[i]);
      listName.add(customList.elementAt(index));
    }
    return listName;
  }

  saveSettings(
      {mariageStatues,
      mariageKind,
      ageFrom,
      ageTo,
      heightFrom,
      heightTo,
      weightFrom,
      weightTo,
      prayer,
      smoking,
      financial,
      education,
      nationalityCountryId,
      residentCountryId,
      workField,
      veil,
      skinColor,
      income,
      helath,
      context}) async {
    try {
      print(weightFrom);
      print(weightTo);
      print("=======");
      print(ageFrom);
      print(ageTo);
      print("=======");
      print(heightFrom);
      print(heightTo);
      print("=======");
      String allKey = 'الكل';
      Map data = {
        'mariageStatues': mariageStatues,
        'mariageKind': mariageKind,
        'ageFrom': ageFrom == allKey ? '0' : ageFrom,
        'ageTo': ageTo == allKey ? '0' : ageTo,
        'heightFrom': heightFrom == allKey ? '0' : heightFrom,
        'heightTo': heightTo == allKey ? '0' : heightTo,
        'weightFrom': weightFrom == allKey ? '0' : weightFrom,
        'weightTo': weightTo == allKey ? '0' : weightTo,
        'prayer': prayer,
        'smoking': smoking,
        'financial': financial,
        'education': education,
        'nationalityCountryId': nationalityCountryId,
        'residentCountryId': residentCountryId,
        'workField': workField,
        'skinColor': skinColor,
        'veil': veil,
        'income': income,
        'helath': helath,
      };

      loadingSaveSetting(true);

      String url = "${Request.urlBase}updateMySearchSetings";

      http.Response response = await http.post(Uri.parse(url),
          body: data,
          headers: {'Authorization': 'Bearer ${appController.apiToken.value}'});

      var responseDecoded = json.decode(response.body);

      print(responseDecoded);
      if (responseDecoded['status'] == "success") {
        loadingSaveSetting(false);
        showToast('تم حفظ الإعدادات بنجاح');
        Get.back(
            result:
                Get.find<AutoSearchController>().getMySearch(0, 'lastAccess'));
      } else {
        loadingSaveSetting(false);
      }
    } catch (e) {
      loadingSaveSetting(false);
    }
  }

  @override
  void onInit() {
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
      for (int i = 0; i < countryList.length; i++) {
        countryIdList.add(countryList[i].id.toString());
        countryNameList.add(countryList[i].nameAr ?? '');
        countryShortNameList.add(countryList[i].shortcut!.toLowerCase());
      }
      getMySearchSetting();
    });
    super.onInit();
  }
}
