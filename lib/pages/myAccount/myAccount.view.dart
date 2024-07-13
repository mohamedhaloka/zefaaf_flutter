import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/appController.dart';
import 'package:zeffaf/pages/home/home.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/app_header.dart';

import 'header.dart';
import 'myAccount.controller.dart';
import 'no.internet.dart';

class MyAccount extends GetView<MyAccountController> {
  const MyAccount(this.visible, {super.key});
  final bool visible;
  @override
  Widget build(context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return MixinBuilder<MyAccountController>(
      init: MyAccountController(),
      builder: (controller) => Scaffold(
        primary: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            BaseAppHeader(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.grey[700],

              // backgroundColor: Get.find<AppController>().cur
              // ? Get.theme.primaryColorDark
              // : Get.theme.primaryColorLight,
              headerLength: 435,
              position: statusBarHeight > 50.0
                  ? Get.height * 0.13
                  : Get.height * 0.10,
              centerTitle: true,
              title: Image.asset(
                "assets/images/log_in/logo-white.png",
                height: 60,
                width: 60,
              ),
              actions: [
                Visibility(
                    visible: visible,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Get.find<HomeController>().updateByToken(false);
                        Get.back();
                      },
                    ))
              ],
              body: AccountHeader(controller),
              children: [
                SliverPadding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 60),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      section([
                        dataList(
                            "الجنسية".tr,
                            controller.appController.userData.value
                                    .nationalityCountryName ??
                                ''),
                        dataList(
                            "SelectedHome".tr,
                            controller.appController.userData.value
                                    .residentCountryName ??
                                ''),
                        dataList(
                            "المدينة".tr,
                            controller.appController.userData.value.cityName ??
                                ''),
                        dataList("name".tr,
                            controller.appController.userData.value.name ?? ''),
                      ], "personalData".tr),
                      section([
                        dataList(
                            "age".tr,
                            controller.appController.userData.value.age
                                .toString()),
                        dataList(
                            "socialStatus".tr,
                            getUserData(
                                Get.find<AppController>().isMan.value == 0
                                    ? InputData.socialStatusManList
                                    : InputData.socialStatusWomanList,
                                controller.appController.userData.value
                                        .mariageStatues ??
                                    0,
                                Get.find<AppController>().isMan.value == 0
                                    ? InputData.socialStatusManListId
                                    : InputData.socialStatusWomanListId)),
                        dataList(
                            "MarriageType".tr,
                            getUserData(
                                InputData.kindOfMarriageList,
                                controller.appController.userData.value
                                        .mariageKind ??
                                    0,
                                InputData.kindOfMarriageListId)),
                      ], "socialStatus".tr),
                      section([
                        dataList("weight".tr,
                            "${controller.appController.userData.value.weight}"),
                        dataList("length".tr,
                            "${controller.appController.userData.value.height}"),
                        dataList(
                            "SkinColor".tr,
                            getUserData(
                                InputData.skinColourList,
                                controller.appController.userData.value
                                        .skinColor ??
                                    0,
                                InputData.skinColourListId)),
                        dataList(
                            "medicalStatus".tr,
                            getUserData(
                                InputData.healthStatusList,
                                controller
                                        .appController.userData.value.helath ??
                                    0,
                                InputData.healthStatusListId)),
                      ], "physicalDes".tr),
                      section([
                        dataList(
                            "PrayLevel".tr,
                            getUserData(
                                InputData.prayList,
                                controller
                                        .appController.userData.value.prayer ??
                                    0,
                                InputData.prayListId)),
                        dataList(
                            "veilLevel".tr,
                            getUserData(
                                InputData.barrierList,
                                controller.appController.userData.value.veil ??
                                    0,
                                InputData.barrierListId),
                            visible: controller
                                        .appController.userData.value.gender ==
                                    1
                                ? true
                                : false),
                        dataList(
                            "smoke".tr,
                            controller.appController.userData.value.smoking == 1
                                ? 'yes'.tr
                                : 'no'.tr),
                      ], "religious".tr),
                      section([
                        dataList(
                            "Collage".tr,
                            getUserData(
                                InputData.educationalQualificationList,
                                controller.appController.userData.value
                                        .education ??
                                    0,
                                InputData.educationalQualificationListId)),
                        dataList(
                            "finance".tr,
                            getUserData(
                                InputData.financialStatusList,
                                controller.appController.userData.value
                                        .financial ??
                                    0,
                                InputData.financialStatusListId)),
                        dataList("field".tr,
                            "${getUserData(InputData.jobList, controller.appController.userData.value.workField ?? 0, InputData.jobListId) ?? ""}"),
                        dataList("job".tr,
                            "${controller.appController.userData.value.job}"),
                        dataList(
                            "intro".tr,
                            getUserData(
                                InputData.monthlyIncomeLevelList,
                                controller
                                        .appController.userData.value.income ??
                                    0,
                                InputData.monthlyIncomeLevelListId)),
                      ], "CollageAndWork".tr),
                      section([
                        dataList(
                            '',
                            controller
                                    .appController.userData.value.aboutOther ??
                                '',
                            oneTitle: true),
                      ], "عن شريك الحياة"),
                    ]),
                  ),
                )
              ],
            ),
            Visibility(
              visible: controller.noInternet.value,
              child: NoInternet(),
            ),
          ],
        ),
      ),
    );
  }

  section(List<Widget> data, String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(
              title,
              style: Get.textTheme.titleMedium!
                  .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Get.theme.cardColor),
            child: Column(
              children: data,
            ),
          ),
        ],
      ),
    );
  }

  dataList(String title, String data, {visible, bool oneTitle = false}) {
    return Visibility(
      visible: visible ?? true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: oneTitle
            ? SizedBox(
                width: Get.width,
                child: Text(
                  data,
                  textAlign: TextAlign.right,
                  style: Get.textTheme.titleMedium!
                      .copyWith(color: Colors.grey, fontSize: 14),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.titleMedium!
                        .copyWith(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Text(
                      data,
                      textAlign: TextAlign.left,
                      style: Get.textTheme.titleMedium!
                          .copyWith(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  getUserData(List list, int dataSource, List listId) {
    try {
      if (dataSource == 0) return '';
      // print("Data Source: $dataSource");
      var index = listId.indexOf(dataSource);
      // print("Index of ListID: $index");
      var data = list.elementAt(index);
      // print("List ${list.elementAt(index)}");
      return data.toString();
    } catch (e) {
      return '';
    }
  }
}
