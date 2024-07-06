import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:zeffaf/appController.dart';

import '../models/newMessage.modal.dart';
import '../services/http.service.dart';

const shouldUpgradeYourPackage = 'يجب ترقية باقتك للإستفاده من الخدمة';

const shouldUpgradeToSilverPackage = 'هذه الخدمة لأصحاب الباقة الفضية';
const shouldUpgradeToGoldenPackage = 'هذه الخدمة لأصحاب الباقة الذهبية';
const shouldUpgradeToPlatinumPackage = 'هذه الخدمة لأصحاب الباقة البلاتينية';
const shouldUpgradeToFeaturedPackage = 'هذه الخدمة لأصحاب الباقات المميزة';
const shouldUpgradeToDiamondPackage = 'هذه الخدمة لأصحاب الباقة الماسية';
const shouldUpgradeToFlowerPackage = 'هذه الخدمة للمشتركات بالباقة الوردية';
const shouldUpgradeToFlowerToGet60NumberPackage =
    'لهواتف عرسان زفاف اشتركي الآن';
const shouldUpgradeToGetPhoneNumberFeatured = 'لهواتف عرائس زفاف اشترك الآن';

void showUpgradePackageDialog(bool isMan,
        [String content = shouldUpgradeYourPackage]) =>
    Get.dialog(AlertDialog(
      // actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text(
        isMan ? "قم بترقية باقتك" : "قومي بترقية باقتك",
        style: Get.theme.textTheme.bodyText1!.copyWith(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.toNamed('/packages');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
          ),
          child: const Text(
            "أرغب بترقية الباقة",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.errorColor,
          ),
          child: const Text(
            "شكراً لا أريد",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));

void thisFeatureAvailableFor(String content) => Get.dialog(AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text(
        "ميزة طلب رقم الهاتف لحسابك متاحة فقط للفتيات الباحثات عن",
        style: Get.theme.textTheme.bodyText1!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
          ),
          child: const Text(
            "حسناً",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));

void showRatingDialog(bool isMan,
        [String content = shouldUpgradeYourPackage]) =>
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "لإرسال طلب زواج",
              style: Get.theme.textTheme.bodyText1!.copyWith(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 30,
                ))
          ],
        ),
        content: Text("${isMan ? 'وجّه' : 'وجهي'} كلمة شكر لمنصة زفاف",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              InAppReview.instance.openStoreListing();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
            ),
            child: const Text(
              "قيمي التطبيق",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              // final appController = Get.find<AppController>();
              //find appcontroller
              var appController = Get.find<AppController>();
              // var messagesController = Get.find<AppMessageController>();
              await appController.checkIfHasPreviousRequest(
                  girRatedTheApp: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.errorColor,
            ),
            child: const Text(
              "تم التقييم",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

Future getMessages() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  RxBool isConnectedToInternet = true.obs;
  final appController = Get.find<AppController>();

  isConnectedToInternet(false);
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = "${Request.urlBase}getMessagesList";

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${appController.apiToken}'});
    if (response.statusCode == 200) {
      List<NewMessagesModal> newMessage = [];
      var data = json.decode(response.body)['data'];
      for (var message in data) {
        newMessage.add(NewMessagesModal.fromJson(message));
      }
      return newMessage;
    } else {}
  } else {
    isConnectedToInternet(true);
  }
}
