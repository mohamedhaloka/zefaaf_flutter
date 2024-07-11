import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zeffaf/pages/list.select.multi.item/view.dart';
import 'package:zeffaf/pages/settings/settings.controller.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/utils/upgrade_package_dialog.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/country_picker.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

import '../../utils/toast.dart';
import 'settings.provider.dart';

class Settings extends GetView<SettingsController> {
  @override
  final controller = Get.find<SettingsController>();
  @override
  Widget build(context) {
    return Scaffold(
      body: MixinBuilder<SettingsController>(
        init: SettingsController(),
        builder: (controller) => BaseAppHeader(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[700],
          headerLength: 100,
          title: Text(
            "settings".tr,
            style: Get.textTheme.bodyText2!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                Get.back();
              },
            ),
          ],
          children: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.cardColor,
                    ),
                    child: SwitchListTile(
                        value: controller.notifications.value,
                        activeColor: controller.appController.isMan.value == 0
                            ? Get.theme.primaryColor
                            : Get.theme.colorScheme.secondary,
                        title: Text(
                          "notifications".tr,
                          style: Get.textTheme.headline4!,
                        ),
                        onChanged: (value) {
                          controller.notifications.value = value;
                          final firebaseMessaging = FirebaseMessaging.instance;
                          final countryId = controller
                              .appController.userData.value.residentCountryId;

                          if (value) {
                            firebaseMessaging.subscribeToTopic('all');
                            firebaseMessaging
                                .subscribeToTopic('country-$countryId');

                            if (controller.appController.isMan.value == 0) {
                              firebaseMessaging.subscribeToTopic('man');
                            } else {
                              firebaseMessaging.subscribeToTopic('woman');
                            }
                            return;
                          }
                          firebaseMessaging.unsubscribeFromTopic('all');
                          firebaseMessaging
                              .unsubscribeFromTopic('country-$countryId');

                          if (controller.appController.isMan.value == 0) {
                            firebaseMessaging.unsubscribeFromTopic('man');
                          } else {
                            firebaseMessaging.unsubscribeFromTopic('woman');
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.cardColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("حجم الخط".tr),
                        SizedBox(
                          width: 170,
                          child: DropdownButton<String>(
                            value: controller.valueFromFontSize.value == ""
                                ? null
                                : controller.valueFromFontSize.value,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            hint: const Text("اختر الحجم"),
                            isExpanded: true,
                            elevation: 0,
                            onChanged: (String? newValue) {
                              controller.valueFromFontSize.value = newValue!;
                            },
                            items: controller.fontSizeSelections
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.cardColor,
                    ),
                    child: SwitchListTile(
                        value: controller.nightMode.value,
                        activeColor: controller.appController.isMan.value == 0
                            ? Get.theme.primaryColor
                            : Get.theme.colorScheme.secondary,
                        title: Text("nightMode".tr),
                        onChanged: (value) {
                          controller.nightMode(value);
                          DynamicTheme.of(context)!.setTheme(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 0
                                  : 1);
                          controller
                              .updateDarkTheme(controller.nightMode.value);
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.cardColor,
                    ),
                    child: SwitchListTile(
                        value: controller.fingerPrint.value,
                        activeColor: controller.appController.isMan.value == 0
                            ? Get.theme.primaryColor
                            : Get.theme.colorScheme.secondary,
                        title: Text("تفعيل البصمة".tr),
                        onChanged: (value) {
                          controller.fingerPrint(value);
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Get.theme.cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "allowedToMessageMe".tr,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "العمر",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const CustomSizedBox(
                                heightNum: 0.015, widthNum: 0.0),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownRegister(
                                    dropdownValue: controller.ageFrom.value,
                                    tittle: "من",
                                    list: InputData.ageList,
                                    onChange: (val) {
                                      controller.ageFrom.value = val!;
                                    },
                                  ),
                                ),
                                const CustomSizedBox(
                                  widthNum: 0.025,
                                  heightNum: 0.0,
                                ),
                                Expanded(
                                  child: DropdownRegister(
                                    dropdownValue: controller.ageTo.value,
                                    tittle: "إلى",
                                    list: InputData.ageList,
                                    onChange: (val) {
                                      controller.ageTo.value = val!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        controller.loadingToLoadMultiData.value
                            ? buildMultiDataShimmer(context, "country".tr)
                            : CountryPicker(
                                title: "country".tr,
                                value: controller.contactsNationalityNameList
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .replaceAll(",", " و "),
                                countryCode: controller.countryCode,
                                listCount: controller
                                    .appController.nationalityCount.value,
                                isChooseAll: controller
                                    .appController.contactsNationalityList
                                    .contains("0"),
                                isImage: true,
                                imageSource:
                                    "assets/images/auto_search_setting/nationality.png",
                                countryImage: controller.countryImage,
                                onTap: () {
                                  _chooseOnTheList(
                                      appTittle: "الجنسية",
                                      countryShortNameList:
                                          controller.countryShortNameList.value,
                                      listChecked: controller.appController
                                          .contactsNationalityList.value,
                                      itemDataList:
                                          controller.countryIdList.value,
                                      listCheckedName: controller
                                          .contactsNationalityNameList,
                                      itemNameList:
                                          controller.countryNameList.value,
                                      value: controller
                                          .appController.nationalityCount,
                                      context: context);
                                },
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        controller.loadingToLoadMultiData.value
                            ? buildMultiDataShimmer(context, "place".tr)
                            : CountryPicker(
                                title: "place".tr,
                                value: controller.contactResidentNameList
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .replaceAll(",", " و "),
                                countryCode: controller.placeCode,
                                listCount:
                                    controller.appController.countryCount.value,
                                isChooseAll: controller
                                    .appController.contactResidentList
                                    .contains("0"),
                                isImage: true,
                                imageSource:
                                    "assets/images/auto_search_setting/residentCountry.png",
                                countryImage: controller.placeImage,
                                onTap: () {
                                  _chooseOnTheList(
                                      appTittle: "الدول",
                                      countryShortNameList:
                                          controller.countryShortNameList.value,
                                      listChecked: controller.appController
                                          .contactResidentList.value,
                                      listCheckedName:
                                          controller.contactResidentNameList,
                                      itemDataList:
                                          controller.countryIdList.value,
                                      itemNameList:
                                          controller.countryNameList.value,
                                      value:
                                          controller.appController.countryCount,
                                      context: context);
                                },
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomRaisedButton(
                    loading: controller.loading.value,
                    onPress: () async {
                      final packageLevel = controller
                              .appController.userData.value.packageLevel ??
                          0;
                      final isMan = controller.appController.isMan.value == 0;

                      if (!isMan && packageLevel == 6) {
                        showUpgradePackageDialog(
                          isMan,
                          shouldUpgradeToFlowerPackage,
                        );
                        return;
                      }

                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        if (!context.mounted) return;

                        doneSetting(context);
                      } else {
                        showToast(
                            "لن تتمكن من تطبيق الإعدادات طالما لا يتوفر إتصال بالإنترنت");
                      }
                    },
                    tittle: "حفظ الإعدادات",
                    color: controller.appController.isMan.value == 0
                        ? Get.theme.primaryColor
                        : Get.theme.colorScheme.secondary,
                    height: 50,
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> doneSetting(context) async {
    try {
      //Notification Statue
      controller.updateNotification(controller.notifications.value);

      //FontSize
      var fontSize = Provider.of<ChangeFontSize>(context, listen: false);
      String newValue = controller.valueFromFontSize.value;
      if (newValue == "كبير") {
        fontSize.changeSize(6.0);
        fontSize.saveFontSize(6.0);
        controller.appController.changeFontSize(fontSize.fontSize);
        controller.fontSizeType(newValue);
      } else if (newValue == "صغير") {
        fontSize.changeSize(-3.0);
        fontSize.saveFontSize(-3.0);
        controller.appController.changeFontSize(fontSize.fontSize);
        controller.fontSizeType(newValue);
      } else if (newValue == "متوسط (الإفتراضي)") {
        fontSize.changeSize(0.0);
        fontSize.saveFontSize(0.0);
        controller.appController.changeFontSize(fontSize.fontSize);
        controller.fontSizeType(newValue);
      }

      //FingerPrint
      controller.fingerPrintStatue(controller.fingerPrint.value);

      //Who can text ME
      var nationality = controller.appController.contactsNationalityList.value
                  .contains("0") ||
              controller.appController.contactsNationalityList.isEmpty
          ? "0"
          : controller.appController.contactsNationalityList.value
              .toString()
              .replaceAll(']', "")
              .replaceAll('[', "")
              .replaceAll(" ", "");
      var country =
          controller.appController.contactResidentList.value.contains("0") ||
                  controller.appController.contactResidentList.isEmpty
              ? "0"
              : controller.appController.contactResidentList.value
                  .toString()
                  .replaceAll(']', "")
                  .replaceAll('[', "")
                  .replaceAll(" ", "");
      print(controller.ageFrom.value);
      print(controller.ageTo.value);
      String allKey = 'الكل';
      await controller
          .saveSettings(
              notifications: controller.notifications.value ? "1" : "0",
              agesFrom: controller.ageFrom.value == allKey
                  ? '0'
                  : controller.ageFrom.value,
              agesTo: controller.ageTo.value == allKey
                  ? '0'
                  : controller.ageTo.value,
              nationalities: nationality,
              residents: country)
          .then((value) {
        if (value == 1) {
          showToast("تم حفظ الإعدادات");
        }
      });
    } catch (e) {}
  }

  _chooseOnTheList(
      {appTittle,
      countryShortNameList,
      listChecked,
      itemDataList,
      itemNameList,
      listCheckedName,
      value,
      context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Get.to(() => ListOfItemsView(
            appTittle: appTittle,
            isVisible: true,
            countryShortNameList: countryShortNameList,
            listCheckedName: listCheckedName,
            listChecked: listChecked,
            itemDataList: itemDataList,
            itemNameList: itemNameList,
            value: value,
          ));
    } else {
      showToast("يرجى التأكد من إتصالك بالإنترنت وإعادة المحاولة");
    }
  }

  Widget buildMultiDataShimmer(context, tittle) {
    var lightMode = Theme.of(context).brightness == Brightness.light;
    return Shimmer.fromColors(
        baseColor: lightMode ? Colors.grey[100]! : Colors.grey[600]!,
        highlightColor: lightMode ? Colors.grey[300]! : Colors.grey[500]!,
        child: CountryPicker(
          title: "$tittle",
          value: controller.contactsNationalityNameList
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(",", " و "),
          countryCode: controller.countryCode,
          listCount: controller.appController.nationalityCount.value,
          isChooseAll: true,
          isImage: false,
          countryImage: controller.countryImage,
          onTap: () {},
        ));
  }
}
