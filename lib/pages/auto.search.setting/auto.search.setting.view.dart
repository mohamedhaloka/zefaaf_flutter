import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/app_header.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import 'auto.search.setting.controller.dart';
import 'auto.search.setting.dropdown.dart';
import 'auto.search.setting.loader.dart';
import 'auto.search.setting.multi.select.item.dart';
import 'auto.search.settings.sliders.dart';

class AutoSearchSettingView extends StatelessWidget {
  const AutoSearchSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: GetX<AutoSearchSettingController>(
        init: AutoSearchSettingController(),
        builder: (AutoSearchSettingController controller) => BaseAppHeader(
          headerLength: 90,
          refresh: () {},
          title: Text(
            "إعدادات الباحث الآلي",
            style: Get.textTheme.titleMedium!.copyWith(color: AppTheme.WHITE),
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
            controller.loadingGetSetting.value
                ? AutoSearchSettingLoader()
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        AutoSearchSettingDropdown(),
                        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
                        AutoSearchSettingsSliders(),
                        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
                        const AutoSearchSettingMultiSelectItem(),
                        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
                        CustomRaisedButton(
                          loading: controller.loadingSaveSetting.value,
                          onPress: () async {
                            await getSendSmokingList(controller);
                            await controller.saveSettings(
                                mariageStatues: controller.socialStatus.value.contains("-1") || controller.socialStatus.isEmpty
                                    ? "-1"
                                    : controller.socialStatus.value
                                        .toString()
                                        .replaceAll(']', "")
                                        .replaceAll('[', "")
                                        .replaceAll(" ", ""),
                                mariageKind: controller.marriageType.value.contains("-1") || controller.marriageType.isEmpty
                                    ? "-1"
                                    : controller.marriageType.value
                                        .toString()
                                        .replaceAll(']', "")
                                        .replaceAll('[', "")
                                        .replaceAll(" ", ""),
                                ageFrom: controller.ageFrom.value,
                                ageTo: controller.ageTo.value,
                                heightFrom: controller.heightFrom.value,
                                heightTo: controller.heightTo.value,
                                weightFrom: controller.weightFrom.value,
                                weightTo: controller.weightTo.value,
                                prayer: controller.prayer.value.contains("-1") || controller.prayer.isEmpty
                                    ? "-1"
                                    : controller.prayer.value
                                        .toString()
                                        .replaceAll(']', "")
                                        .replaceAll('[', "")
                                        .replaceAll(" ", ""),
                                smoking: controller.sendSmoking.value.contains("-1") || controller.sendSmoking.isEmpty
                                    ? "-1"
                                    : controller.sendSmoking.value
                                        .toString()
                                        .replaceAll(']', "")
                                        .replaceAll('[', "")
                                        .replaceAll(" ", ""),
                                financial: controller.financial.value.contains("-1") || controller.financial.isEmpty
                                    ? "-1"
                                    : controller.financial.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                education: controller.education.value.contains("-1") || controller.education.isEmpty ? "-1" : controller.education.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                veil: controller.barrier.value.contains("-1") || controller.barrier.isEmpty ? "-1" : controller.barrier.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                nationalityCountryId: controller.nationalityCountryId.value.contains("0") || controller.nationalityCountryId.isEmpty ? "-1" : controller.nationalityCountryId.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                residentCountryId: controller.residentCountryId.value.contains("0") || controller.residentCountryId.isEmpty ? "-1" : controller.residentCountryId.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                workField: controller.workField.value.contains("-1") || controller.workField.isEmpty ? "-1" : controller.workField.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                skinColor: controller.skinColor.value.contains("-1") || controller.skinColor.isEmpty ? "-1" : controller.skinColor.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                income: controller.income.value.contains("-1") || controller.income.isEmpty ? "-1" : controller.income.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                helath: controller.health.value.contains("-1") || controller.health.isEmpty ? "-1" : controller.health.value.toString().replaceAll(']', "").replaceAll('[', "").replaceAll(" ", ""),
                                context: context);
                          },
                          tittle: "حفظ الإعدادات",
                          color: controller.appController.isMan.value == 0
                              ? Get.theme.primaryColor
                              : Get.theme.colorScheme.secondary,
                        )
                      ]),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  getSendSmokingList(AutoSearchSettingController controller) {
    controller.sendSmoking.clear();
    for (var element in controller.smoking) {
      if (element == "0") {
        controller.sendSmoking.add("-1");
      }
      if (element == "1") {
        controller.sendSmoking.add("1");
      }
      if (element == "2") {
        controller.sendSmoking.add("0");
      }
    }
  }
}
