import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/services/http.service.dart';

import '../../appController.dart';
import '../../models/user.dart';
import '../../utils/toast.dart';

class SearchResultController extends GetxController {
  final _appController = Get.find<AppController>();
  ScrollController scrollController = ScrollController();

  RxList<User> result = <User>[].obs;
  RxInt totalCount = RxInt(2);
  RxInt currentPage = RxInt(0);
  RxBool loading = true.obs;
  RxBool fetch = false.obs;
  RxString choose = "lastAccess".obs;

  RxBool searchByUserOnly = RxBool(false);
  RxBool connectToInternet = RxBool(false);

  static String lastAccess = 'الأحدث دخولاً';
  static String id = 'الأحدث تسجيلاً';

  List<String> choices = <String>[lastAccess, id];

  Future<void> search(
      {context,
      page,
      userName,
      countryId,
      cityId,
      nationality,
      mariageStatues,
      mariageKind,
      education,
      veil,
      financial,
      lastAccess,
      workField,
      weightFrom,
      weightTo,
      heightFrom,
      heightTo,
      ageTo,
      ageFrom,
      fetchVal}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    connectToInternet(false);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        searchByUserOnly(true);
        fetch(fetchVal);
        Map body = {
          'page': page == '' ? "0" : "$page",
          'orderBy': lastAccess == null || lastAccess == ''
              ? "lastAccess"
              : "$lastAccess",
          'userName': userName == '' ? "" : "$userName",
          'residentCountryId':
              countryId == 2 || countryId == '' ? "0" : "$countryId",
          'cityId': cityId == 2 || cityId == '' ? "0" : "$cityId",
          'nationalityCountryId': nationality == -1 ? "0" : "$nationality",
          'mariageStatues': mariageStatues == -1 ? "0" : "$mariageStatues",
          'mariageKind': mariageKind == -1 ? "0" : "$mariageKind",
          'education': education == -1 ? "0" : "$education",
          'veil': veil == -1 ? "0" : "$veil",
          'financial': financial == -1 ? "0" : "$financial",
          'workField': workField == -1 ? "0" : "$workField",
          'ageTo': ageTo == 0 ? "18" : "$ageTo",
          'ageFrom': ageFrom == 100 ? "65" : "$ageFrom",
          'weightFrom': weightFrom == '' ? "0" : "$weightFrom",
          'weightTo': weightTo == '' ? "0" : "$weightTo",
          'heightFrom': heightFrom == '' ? "0" : "$heightFrom",
          'heightTo': heightTo == '' ? "0" : "$heightTo",
        };

        String url = "${Request.urlBase}search";
        http.Response response = await http.post(
          Uri.parse(url),
          body: body,
          headers: {'Authorization': 'Bearer ${_appController.apiToken}'},
        );
        var data = jsonDecode(response.body);
        if (data["status"] == "success") {
          List jsonUser = data['data'];
          if (jsonUser.isEmpty) {
            fetch(false);
            currentPage(page - 1);
          }

          for (var item in jsonUser) {
            result.add(User.fromJson(item));
          }
          loading(false);
          searchByUserOnly(false);
          fetch(false);
        } else {
          showToast("searchError".tr);
        }
      } catch (e) {
        print(e.toString());
        loading(false);
      }
    } else {
      connectToInternet(true);
      showToast("تأكد من إتصالك بالإنترنت");
    }
  }

  void choiceAction(String choice) {
    if (choice == lastAccess) {
      result.clear();
      loading(true);
      currentPage(0);
      choose("lastAccess");
      search(
              context: null,
              page: currentPage.value,
              userName: '',
              countryId: '',
              cityId: '',
              mariageKind: '',
              mariageStatues: '',
              nationality: '',
              workField: '',
              education: '',
              veil: '',
              financial: '',
              ageTo: '',
              ageFrom: '',
              weightFrom: '',
              weightTo: '',
              heightFrom: '',
              heightTo: '',
              lastAccess: 'lastAccess')
          .then((value) {
        loading(false);
      });
    } else if (choice == id) {
      result.clear();
      loading(true);
      currentPage(0);
      choose("id");
      search(
              context: null,
              page: currentPage.value,
              userName: '',
              countryId: '',
              cityId: '',
              mariageKind: '',
              mariageStatues: '',
              nationality: '',
              workField: '',
              education: '',
              veil: '',
              financial: '',
              ageTo: '',
              ageFrom: '',
              weightFrom: '',
              weightTo: '',
              heightFrom: '',
              heightTo: '',
              lastAccess: 'id')
          .then((value) {
        loading(false);
      });
    }
  }

  @override
  void onInit() {
    preSearch();
    scrollController = ScrollController();
    pagination(choose.value);
    super.onInit();
  }

  Future<void> preSearch(
      {int? page, bool? fetchVal, String? lastAccess}) async {
    await search(
      context: Get.arguments[0],
      page: page ?? Get.arguments[1],
      userName: Get.arguments[2],
      countryId: Get.arguments[3],
      cityId: Get.arguments[4],
      mariageKind: Get.arguments[5],
      mariageStatues: Get.arguments[6],
      nationality: Get.arguments[7],
      workField: Get.arguments[8],
      education: Get.arguments[9],
      veil: Get.arguments[10],
      financial: Get.arguments[11],
      ageTo: Get.arguments[12],
      ageFrom: Get.arguments[13],
      weightFrom: Get.arguments[14],
      weightTo: Get.arguments[15],
      heightFrom: Get.arguments[16],
      heightTo: Get.arguments[17],
      fetchVal: fetchVal,
      lastAccess: lastAccess,
    );
  }

  pagination(option) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage.value++;

        preSearch(
          page: currentPage.value,
          lastAccess: option,
          fetchVal: true,
        );
      }
    });
  }

  emptyValues() {
    totalCount.value = 0;
    currentPage.value = 0;
    result.clear();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
