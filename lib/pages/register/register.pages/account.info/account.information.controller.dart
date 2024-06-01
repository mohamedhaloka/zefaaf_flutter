import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/city.list/city.list.controller.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/services/http.service.dart';

import '../../../../utils/toast.dart';

class AccountInformationController extends GetxController {
  //To get country data
  final countryCodeController = Get.put(CountryCodeController());
  //To get all shared vars in app
  final appController = Get.find<AppController>();
  //To get city data after choose country
  final cityListController = Get.put(CityListController());
  //for userName
  late Rx<TextEditingController> username;
  //for password
  late Rx<TextEditingController> password;
  //for rePass
  late Rx<TextEditingController> rePassword;
  //use it when check available userName or Not
  RxInt userNameLoading = 0.obs;
  //for full Name input
  late TextEditingController fullName;
  //for email input
  // late TextEditingController email;
  //To get urlBase
  final Request request = Request();
  //for username checker
  RxBool visible = RxBool(false);
  //before show the result to check userName
  RxBool loadingVisible = RxBool(true);
  //Icons for userName Ava. or Not
  Rx<IconData> checkUserName = Icons.check.obs;
  Rx<IconData> checkSamePass = Icons.close.obs;

  final userNameFocusNode = FocusNode();

  @override
  void onInit() {
    //init Controllers
    username = TextEditingController().obs;
    password = TextEditingController().obs;
    rePassword = TextEditingController().obs;
    fullName = TextEditingController();
    // email = TextEditingController();

    userNameFocusNode.addListener(() {
      if (username.value.text.length >= 8) {
        getUsers(username.value.text).then((value) {
          userNameLoading.value == 2
              ? checkUserName.value = Icons.close
              : checkUserName.value = Icons.check;
        });
      } else if (username.value.text.length < 8) {
        // showToast("يجب أن يكون إسم المستخدم أكثر من 8 حروف");
        userNameLoading(2);
        checkUserName.value = Icons.close;
      }
    });
    super.onInit();
  }

  //Method to check the username is available or not
  Future getUsers(username) async {
    visible(true);
    String url = Uri.encodeFull("${Request.urlBase}checkUserName/$username");
    final response = await http.get(Uri.parse(url));

    log(json.decode(response.body).toString());
    if (json.decode(response.body)['rowsCount'] == 0) {
      userNameLoading = 1.obs;
      visible(false);
    } else {
      userNameLoading = 2.obs;
      visible(false);
    }
    return json.decode(response.body)['rowsCount'];
  }

  //Method to check The password input and re password input are same
  RxBool checkPassInputEqualRePassInput(pass, rePass) {
    if (pass == rePass) {
      return true.obs;
    } else {
      return false.obs;
    }
  }
}
