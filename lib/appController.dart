import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeffaf/models/app.settings.modal.dart';
import 'package:zeffaf/models/static.data.dart';
import 'package:zeffaf/pages/more/more.view.dart';
import 'package:zeffaf/services/http.service.dart';
import 'package:zeffaf/widgets/system_dialog.dart';

import 'models/country.code.dart';
import 'models/newMessage.modal.dart';
import 'models/owner.dart';
import 'models/user.dart';
import 'pages/new.message/newMessage.view.dart';
import 'utils/input_data.dart';
import 'utils/toast.dart';
import 'utils/upgrade_package_dialog.dart';

class AppController extends GetxController {
  RxBool checkingForPreviousRequest = false.obs;

  final facebookAppEvents = FacebookAppEvents();
  final storage = GetStorage();
  Rx<Owner> userData = Owner().obs;
  RxList<User> latest = RxList<User>();
  var apiToken = "".obs;
  var profileImg = "".obs;
  var timeZoneOffset = 0.obs;
  RxInt isMan = RxInt(0);
  List<String> countriesCode = [];

  RxDouble fontSize = RxDouble(0.0);
  RxString registerLicense = "".obs;
  RxList<StaticData> fixedData = RxList([]);
  RxString detectedCountryCode = RxString("");
  //Country And Nationality List
  RxString contactsNationality = RxString("");
  RxList<String> contactsNationalityList = RxList([]);
  RxString nationalityCount = RxString("0");
  RxString contactResident = RxString("");
  RxList<String> contactResidentList = RxList([]);
  RxString countryCount = RxString("0");
  PackageInfo? packageInfo;

  //Log In - notificationOpenDate
  RxString notificationOpenDate = RxString("");

  RxInt contactAgesFrom = RxInt(0);
  RxInt receiveNotification = RxInt(0);
  RxInt contactAgesTo = RxInt(100);
  RxString newViews = RxString("0");
  Rx<AppSettingsModal> appSetting = AppSettingsModal().obs;
  RxString newInterest = RxString("0");
  RxInt newMessages = RxInt(0);
  RxInt newChats = RxInt(0);
  RxInt statueVal = 0.obs;
  RxInt newPosts = RxInt(0);
  RxBool fingerprintStatue = RxBool(true);

  @override
  void onInit() async {
    packageInfo = await PackageInfo.fromPlatform();
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    storage.writeIfNull('darkmode', false);
    storage.writeIfNull('notificationStatue', false);
    storage.writeIfNull('fingerprint', false);
    storage.writeIfNull('notificationOpenDate', "");
    storage.writeIfNull('detectedCountry', "");
    getAppSettings().then((value) {
      appSetting.value = AppSettingsModal.fromJson(value['data'][0]);
      registerLicense.value = appSetting.value.registerLicense ?? '';
      checkHasANewVersion();
      for (var data in value['fixedData']) {
        fixedData.add(StaticData.fromJson(data));
      }
      loadFixedData();
      storage.write('registerLicense', registerLicense.value);
      writeDataToMorePage(
          faceLink: appSetting.value.facebook,
          instaLink: appSetting.value.instagram,
          whatsLink: appSetting.value.whatsapp,
          termsAndConditions: appSetting.value.registerConditions,
          privacy: appSetting.value.privacy,
          aboutUS: appSetting.value.aboutUs,
          androidLink: appSetting.value.androidLink,
          iphoneLink: appSetting.value.iphoneLink,
          shareText: appSetting.value.shareText,
          displayPackages: appSetting.value.displayPackages);
    });
    getGender();
    getStatue();
    getCountryList().then((value) {
      for (var i in value ?? []) {
        countriesCode
            .add(i.currencyEn.toString().toUpperCase().substring(0, 2));
      }
    });
    initPlatformState();
    getNotificationOpenDate();
    getFingerPrint();
    storage.writeIfNull('apiToken', 'null');
    storage.writeIfNull('fontSize', 0.0);
    storage.writeIfNull('userData', json.encode({'id': null}));
    updateUserDate(json.decode(storage.read('userData')));
    getApiToken();
    getFontSize();
    updateGender(isMan.value);
    getCountryCode();
    // WidgetsBinding.instance.addPostFrameCallback(
    //     (_) => DynamicTheme.of(Get.context!)?.setTheme(1));
    super.onInit();
  }

  void getCountryCode() async {
    final permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) return;
    final Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isEmpty) return;
    Placemark place = placemarks[0];

    detectedCountryCode(place.isoCountryCode ?? '');
  }

  void checkHasANewVersion() {
    String appVersion = packageInfo?.version ?? '';
    String storeVersion = appSettings.value.mobileVersion ?? '';
    log('appVersion $appVersion');
    log('storeVersion $storeVersion');
    final convertAppVersionToNumber =
        num.tryParse(appVersion.replaceAll(".", "")) ?? 0.0;
    final convertStoreVersionToNumber =
        num.tryParse(storeVersion.replaceAll(".", "")) ?? 0.0;

    if (convertAppVersionToNumber < convertStoreVersionToNumber) {
      Get.dialog(
        AlertDialog(
          content: SystemDialog(
            title: "يتوافر تحديث جديد للتطبيق يشمل العديد من المزايا",
            iconPath: 'assets/images/new_upgrade.svg',
            description: appSettings.value.mobileVersionDescription,
            buttonText: 'تحديث',
            onPress: _launchUrl,
            isMan: isMan.value == 0,
          ),
        ),
      );
    }
  }

  Future<void> _launchUrl() async {
    String link;
    if (Platform.isAndroid) {
      link =
          'https://play.google.com/store/apps/details?id=com.dreamsoft.zefaaf&hl=en_US';
    } else {
      link =
          'https://apps.apple.com/eg/app/%D9%85%D9%86%D8%B5%D8%A9-%D8%B2%D9%81%D8%A7%D9%81/id1550582488';
    }
    Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future getAppSettings() async {
    String url = "${Request.urlBase}getAppSettings";
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var dataDecoded = json.decode(response.body);
      return dataDecoded;
    } else {}
  }

  setCheckPreviousRequest(bool value) {
    checkingForPreviousRequest(value);
  }

  checkIfHasPreviousRequest({bool? girRatedTheApp}) async {
    // if (isMan.value == 1 && girRatedTheApp == null) {
    //   showRatingDialog();
    //   return;
    // } else
    if (isMan.value == 0 && userData.value.packageLevel! <= 4) {
      showUpgradePackageDialog(isMan.value == 0, shouldUpgradeToDiamondPackage);
      return;
    } else if (isMan.value == 1 && userData.value.premium == 11) {
      showUpgradePackageDialog(isMan.value == 0, shouldUpgradeToFlowerPackage);
      return;
    } else {
      checkingForPreviousRequest(true);
      List<NewMessagesModal>? messages = await getMessages();
      checkingForPreviousRequest(false);
      bool? hasAnotherRequestForThisMonth = messages!.any((element) =>
          element.userId == userData.value.id &&
          DateTime.parse(element.messageDateTime!).month ==
              DateTime.now().month);
      if (messages.any((element) =>
          element.userId == userData.value.id &&
          hasAnotherRequestForThisMonth == true)) {
        showToast(
          "لمنح فرصة للآخرين نشر طلب واحد شهرياً",
        );
        return;
      } else {
        Get.to(() => NewMessage(complaint: false));
      }
    }
  }

  void loadFixedData() {
    //Social Status Search Lists
    InputData.socialStatusManSearchList.add("الكل");
    InputData.socialStatusManSearchListId.add(-1);
    InputData.socialStatusWomanSearchList.add("الكل");
    InputData.socialStatusWomanSearchListId.add(-1);
    //Kind of Marriage Search Lists
    InputData.kindOfMarriageSearchList.add("الكل");
    InputData.kindOfMarriageSearchListId.add(-1);
    //Education Search Lists
    InputData.educationalQualificationSearchList.add("الكل");
    InputData.educationalQualificationSearchListId.add(-1);
    //Financial Search Lists
    InputData.financialStatusSearchList.add("الكل");
    InputData.financialStatusSearchListId.add(-1);
    //Job Search Lists
    InputData.jobSearchList.add("الكل");
    InputData.jobSearchListId.add(-1);
    //In Come Search Lists
    InputData.monthlyIncomeLevelSearchList.add("الكل");
    InputData.monthlyIncomeLevelSearchListId.add(-1);
    //Pray Search Lists
    InputData.praySearchList.add("الكل");
    InputData.praySearchListId.add(-1);
    //Barrier Search Lists
    InputData.barrierSearchList.add("الكل");
    InputData.barrierSearchListId.add(-1);
    //Health Search Lists
    InputData.healthStatusSearchList.add("الكل");
    InputData.healthStatusSearchListId.add(-1);
    //Skin Color Search Lists
    InputData.skinColourSearchList.add("الكل");
    InputData.skinColourSearchListId.add(-1);
    for (var element in fixedData) {
      if (element.type == 1) {
        if (element.gender == 1) {
          //Woman List
          //SearchList
          InputData.socialStatusWomanSearchList.add(element.title!);
          InputData.socialStatusWomanSearchListId.add(element.id!);
          //Register List
          InputData.socialStatusWomanList.add(element.title!);
          InputData.socialStatusWomanListId.add(element.id!);
        } else if (element.gender == 0) {
          //Man List
          //SearchList
          InputData.socialStatusManSearchList.add(element.title!);
          InputData.socialStatusManSearchListId.add(element.id!);

          //Register List
          InputData.socialStatusManList.add(element.title!);
          InputData.socialStatusManListId.add(element.id!);
        }
      } else if (element.type == 2) {
        InputData.kindOfMarriageSearchList.add(element.title!);
        InputData.kindOfMarriageSearchListId.add(element.id!);
        InputData.kindOfMarriageList.add(element.title!);
        InputData.kindOfMarriageListId.add(element.id!);
      } else if (element.type == 3) {
        InputData.educationalQualificationSearchList.add(element.title ?? '');
        InputData.educationalQualificationSearchListId.add(element.id!);
        InputData.educationalQualificationList.add(element.title ?? '');
        InputData.educationalQualificationListId.add(element.id!);
      } else if (element.type == 4) {
        InputData.financialStatusSearchList.add(element.title!);
        InputData.financialStatusSearchListId.add(element.id!);
        InputData.financialStatusList.add(element.title!);
        InputData.financialStatusListId.add(element.id!);
      } else if (element.type == 5) {
        InputData.monthlyIncomeLevelList.add(element.title!);
        InputData.monthlyIncomeLevelListId.add(element.id!);
        InputData.monthlyIncomeLevelSearchList.add(element.title!);
        InputData.monthlyIncomeLevelSearchListId.add(element.id!);
      } else if (element.type == 6) {
        InputData.jobSearchList.add(element.title!);
        InputData.jobSearchListId.add(element.id!);
        InputData.jobList.add(element.title!);
        InputData.jobListId.add(element.id!);
      } else if (element.type == 7) {
        InputData.healthStatusList.add(element.title!);
        InputData.healthStatusListId.add(element.id!);
        InputData.healthStatusSearchList.add(element.title!);
        InputData.healthStatusSearchListId.add(element.id!);
      } else if (element.type == 8) {
      } else if (element.type == 12) {
        InputData.barrierList.add(element.title!);
        InputData.barrierListId.add(element.id!);
        InputData.barrierSearchList.add(element.title!);
        InputData.barrierSearchListId.add(element.id!);
      } else if (element.type == 10) {
        InputData.prayList.add(element.title!);
        InputData.prayListId.add(element.id!);
        InputData.praySearchList.add(element.title!);
        InputData.praySearchListId.add(element.id!);
      } else if (element.type == 11) {
        InputData.skinColourList.add(element.title!);
        InputData.skinColourListId.add(element.id!);
        InputData.skinColourSearchList.add(element.title!);
        InputData.skinColourSearchListId.add(element.id!);
      }
    }
  }

  getStatue() {
    statueVal.value = storage.read('statue') ?? 0;
    return statueVal.value;
  }

  changeFontSize(fontSizee) {
    storage.write('fontSize', fontSizee);
    fontSize.value = fontSizee;
  }

  getFontSize() {
    fontSize.value = storage.read('fontSize') ?? 0;
    return fontSize.value;
  }

  changeThemeMode(bool newMode) {
    storage.write('darkmode', newMode);
  }

  changeNotificationOpenDate(String date) {
    storage.write('notificationOpenDate', date);
    notificationOpenDate.value = date;
  }

  getNotificationOpenDate() {
    String notificationOpen = storage.read('notificationOpenDate') ??
        DateTime.now().toUtc().toString();
    notificationOpenDate.value = notificationOpen;
  }

  changeNotification(bool newMode) {
    storage.write('notificationStatue', newMode);
  }

  getUserData() {
    return userData.value;
  }

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

  saveStatue(statue) {
    storage.write('statue', statue);
    statueVal.value = statue;
  }

  logOut([bool? value]) {
    storage.write('userData', json.encode({'id': null}));
    userData.value = Owner.fromJson({'id': null});
    Get.offAllNamed('/Login', arguments: [value ?? false]);
  }

  updateUserDate(Map newData) {
    storage.write('userData', json.encode(newData));
    updateAPiToken(newData["token"] ?? storage.read('apiToken'));
    userData.value =
        Owner.fromJson(newData['data'] != null ? newData['data'].first : {});
    newViews.value = newData['updates'] != null
        ? newData['updates']['newViews'] ?? "0"
        : '0';
    newInterest.value = newData['updates'] != null
        ? newData['updates']['newIntersest'] ?? "0"
        : '0';
    newMessages.value =
        newData['updates'] != null ? newData['updates']['newMessages'] ?? 0 : 0;
    newChats.value =
        newData['updates'] != null ? newData['updates']['newChats'] ?? 0 : 0;
    newPosts.value =
        newData['updates'] != null ? newData['updates']['newPosts'] : 0;
    if (newData['data'] != null) {
      contactResident.value = newData['data'][0]['contactResident'] ?? "";
      contactResidentList.value = contactResident.value == ""
          ? []
          : contactResident.value == "-1"
              ? ['0']
              : contactResident.value.split(',').toList();
      countryCount.value = contactResidentList.length.toString();
      contactsNationality.value =
          newData['data'][0]['contactsNationality'] ?? "";
      contactsNationalityList.value = contactsNationality.value == ""
          ? []
          : contactsNationality.value == "-1"
              ? ['0']
              : contactsNationality.value.split(',').toList();
      nationalityCount.value = contactsNationalityList.length.toString();

      contactAgesFrom.value = newData['data'][0]['contactAgesFrom'] ?? 18;
      contactAgesTo.value = newData['data'][0]['contactAgesTo'] ?? 65;
      profileImg.value = newData['data'][0]['profileImage'] ?? '';
      receiveNotification.value =
          newData['data'][0]['receiveNotification'] ?? 0;
      changeNotification(receiveNotification.value == 1 ? true : false);
    }
    latest.clear();
    if (newData['latestUsers'] != null) {
      newData['latestUsers'].forEach((element) {
        latest.add(User.fromJson(element));
      });
    }
  }

  getApiToken() {
    apiToken.value = storage.read('apiToken');
    return apiToken.value;
  }

  updateAPiToken(newToken) {
    storage.write('apiToken', newToken);
    apiToken.value = newToken;
  }

  updateGender(gender) {
    storage.write('gender', gender ?? 0);
    isMan.value = gender ?? 0;
  }

  getGender() {
    isMan.value = storage.read('gender') ?? 0;
  }

  updateFingerPrint(fingerprintVal) {
    storage.write('fingerprint', fingerprintVal);
    fingerprintStatue.value = fingerprintVal;
  }

  getFingerPrint() {
    bool fingerPrint = storage.read('fingerprint') ?? false;
    log(fingerPrint.toString(), name: 'FINGERPRINT BOOL');
    fingerprintStatue.value = fingerPrint;
  }

  writeDataToMorePage(
      {faceLink,
      instaLink,
      whatsLink,
      privacy,
      aboutUS,
      androidLink,
      termsAndConditions,
      iphoneLink,
      shareText,
      displayPackages}) {
    storage.write('facebookLink', faceLink);
    storage.write('instagramLink', instaLink);
    storage.write('registerCondetions', termsAndConditions);
    storage.write('whatsAppLink', whatsLink);
    storage.write('privacy', privacy);
    storage.write('aboutUS', aboutUS);
    storage.write('androidLink', androidLink);
    storage.write('iphoneLink', iphoneLink);
    storage.write('shareText', shareText);
    storage.write('displayPackages', displayPackages);
  }

  Future<void> initPlatformState() async {
    try {
      DateTime timezone = DateTime.now();
      timeZoneOffset(timezone.timeZoneOffset.inHours);
    } catch (_) {}
  }
}
