import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/register/register.pages/about.you/about.you.controller.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/account.information.controller.dart';
import 'package:zeffaf/pages/register/register.pages/ask.about.his.life/ask.about.his.life.controller.dart';
import 'package:zeffaf/pages/register/register.pages/social.status/social.status.controller.dart';
import 'package:zeffaf/services/http.service.dart';

import '../login/login.dart';

class RegisterController extends GetxController {
  RxInt currentStep = 1.obs;
  RxInt gender = 1.obs;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static final appController = Get.find<AppController>();
  RxString fcmToken = "".obs;
  RxString mobile = "".obs;
  RxString countryCode = "".obs;
  RxBool loading = false.obs;
  final storage = GetStorage();
  final Request request = Request(apiToken: appController.apiToken.value);

  readMobileNumber() {
    mobile.value = storage.read('mobileNumber');
  }

  readCountryCode() {
    countryCode.value = storage.read('countryCode');
  }

  AccountInformationController accountInformationController =
      Get.put(AccountInformationController());

  SocialStatusController socialStatusController =
      Get.put(SocialStatusController());

  AskAboutHisLifeController aboutHisLifeController =
      Get.put(AskAboutHisLifeController());

  AboutYouController aboutYouController = Get.put(AboutYouController());

  @override
  void onInit() {
    gender.value = Get.arguments[0];
    readMobileNumber();
    readCountryCode();
    firebaseMessaging.getToken().then((token) {
      fcmToken(token);
    });
    super.onInit();
  }

  disposeAllTextEditingController() {
    //AccountInformation Step1
    accountInformationController.username.value.clear();
    accountInformationController.password.value.clear();
    accountInformationController.rePassword.value.clear();
    accountInformationController.fullName.clear();
    // accountInformationController.email.clear();
    accountInformationController.countryCodeController.nationalityName.value =
        "";
    accountInformationController.countryCodeController.countryName.value = "";
    accountInformationController.cityListController.cityName.value = "";
    //SocialStatue Step2
    socialStatusController.age.clear();
    socialStatusController.width.clear();
    socialStatusController.height.clear();
    socialStatusController.socialStatus.value = "";
    socialStatusController.skinColour.value = "";
    socialStatusController.healthStatus.value = "";
    //AboutHisLife Step3
    aboutHisLifeController.job.clear();
    aboutHisLifeController.prayId.value = "";
    aboutHisLifeController.monthlyIncomeLevel.value = "";
    aboutHisLifeController.educationalQualification.value = "";
    aboutHisLifeController.employment.value = "";
    aboutHisLifeController.financialStatus.value = "";
    //TalkAboutYou Step4
    aboutYouController.talkAboutYou.clear();
    aboutYouController.partnerSpecifications.clear();
  }

  Future register(
      {required String mobileCode,
      required String mobile,
      required String password,
      required String name,
      required String userName,
      required String email,
      required String gender,
      required String residentCountryId,
      required String nationalityCountryId,
      required String cityId,
      required String mariageStatues,
      required String mariageKind,
      required String age,
      required String kids,
      required String weight,
      required String height,
      required String veil,
      required String skinColor,
      required String smoking,
      required String prayer,
      required String education,
      required String financial,
      required String workField,
      required String job,
      required String income,
      required String helath,
      required String aboutMe,
      required String aboutOther,
      required String detectedCountry,
      required String telesalesCode,
      required String deviceToken}) async {
    try {
      loading(true);
      Map registerBody = {
        'mobileCode': mobileCode,
        'mobile': mobile,
        'password': password,
        'name': name,
        'userName': userName,
        'email': email,
        'gender': gender,
        'residentCountryId': residentCountryId,
        'nationalityCountryId': nationalityCountryId,
        'cityId': cityId,
        'mariageStatues': mariageStatues,
        'mariageKind': mariageKind,
        'age': age,
        'kids': kids,
        'weight': weight,
        'height': height,
        'skinColor': skinColor,
        'smoking': smoking,
        'prayer': prayer,
        'education': education,
        'financial': financial,
        'workField': workField,
        'job': job,
        'income': income,
        'helath': helath,
        'aboutMe': aboutMe,
        'aboutOther': aboutOther,
        'veil': veil,
        'detectedCountry': detectedCountry,
        // 'telesalesCode': telesalesCode,
        'deviceToken': deviceToken,
      };

      var response = await http.post(Uri.parse("${Request.urlBase}register"),
          body: registerBody);

      if (json.decode(response.body)['status'] == "success") {
        return json.decode(response.body);
      } else {
        loading(false);
        Get.snackbar(
            "خطأ!", returnError(json.decode(response.body)['errorCode']),
            backgroundColor: Colors.black54);
      }
    } catch (e) {
      loading(false);
      print(e);
    }
  }

  returnError(type) {
    switch (type) {
      case '1':
        return "رقم الهاتف أو اسم المستخدم ربما إستخدم من قبل، يرجى التأكد وإعادة المحاولة";
      case '2':
        return "يوجد كلمات غير مسموح بها في 'تحدث عن نفسك'";
      case '3':
        return "حدث خطأ، يرجي إعادة المحاولة لاحقاً";
      case '4':
        return "يوجد كلمات غير مسموح بها في 'عن شريك حياتك'";
      case '5':
        return "يوجد كلمات غير مسموح بها في 'الوظيفة'";
      case '6':
        return "مستخدم غير مسموح به، تأكد من إدخال جميع الببيانات بشكل صحيح";
    }
  }

  Future login({username, password, context}) async {
    LoginAPI.login(
        appController: appController,
        context: context,
        loading: loading,
        password: password,
        pushToken: fcmToken.value,
        request: request,
        username: username);
  }

  @override
  void onClose() {
    disposeAllTextEditingController();
    super.onClose();
  }
}
