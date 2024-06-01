import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/list.select.multi.item/view.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/country_picker.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../utils/toast.dart';
import 'auto.search.setting.controller.dart';

class AutoSearchSettingDropdown extends GetView<AutoSearchSettingController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryPicker(
              title: "الحالة الإجتماعية",
              value: controller.socialStatusNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.socialStatusCount.value,
              isImage: true,
              imageSource: "assets/images/auto_search_setting/person.png",
              isChooseAll: controller.socialStatus.value.contains("-1"),
              onTap: () {
                var isMan = controller.appController.isMan.value;
                List<String> socialStatusListId = isMan == 0
                    ? InputData.socialStatusWomanSearchListId
                        .map((e) => e.toString())
                        .toList()
                    : InputData.socialStatusManSearchListId
                        .map((e) => e.toString())
                        .toList();

                _chooseOnTheList(
                    appTittle: "الحالة الإجتماعية",
                    isVisible: false,
                    countryShortNameList: socialStatusListId,
                    listChecked: controller.socialStatus.value,
                    itemDataList: socialStatusListId,
                    listCheckedName: controller.socialStatusNameSelected,
                    itemNameList: isMan == 0
                        ? InputData.socialStatusWomanSearchList
                        : InputData.socialStatusManSearchList,
                    value: controller.socialStatusCount,
                    context: context);
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "نوع الزواج",
              value: controller.marriageTypeNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.marriageTypeCount.value,
              isImage: true,
              imageSource: "assets/images/auto_search_setting/relationship.png",
              isChooseAll: controller.marriageType.value.contains("-1"),
              onTap: () {
                List<String> marriageKindListId = InputData
                    .kindOfMarriageSearchListId
                    .map((e) => e.toString())
                    .toList();
                _chooseOnTheList(
                    appTittle: "نوع الزواج",
                    isVisible: false,
                    listCheckedName: controller.marriageTypeNameSelected,
                    countryShortNameList: marriageKindListId,
                    listChecked: controller.marriageType.value,
                    itemDataList: marriageKindListId,
                    itemNameList: InputData.kindOfMarriageSearchList,
                    value: controller.marriageTypeCount,
                    context: context);
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "الصلاة",
              value: controller.prayerNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.prayerCount.value,
              isImage: true,
              imageSource: "assets/images/auto_search_setting/praying.png",
              isChooseAll: controller.prayer.value.contains("-1"),
              onTap: () {
                List<String> prayerListId = InputData.praySearchListId
                    .map((e) => e.toString())
                    .toList();
                _chooseOnTheList(
                    appTittle: "الصلاة",
                    listCheckedName: controller.prayerNameSelected,
                    isVisible: false,
                    countryShortNameList: prayerListId,
                    listChecked: controller.prayer.value,
                    itemDataList: prayerListId,
                    itemNameList: InputData.praySearchList,
                    value: controller.prayerCount,
                    context: context);
              },
            ),
            controller.appController.isMan.value == 1
                ? const SizedBox()
                : const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            controller.appController.isMan.value == 1
                ? const SizedBox()
                : CountryPicker(
                    title: "الحجاب",
                    value: controller.barrierNameSelected
                        .toString()
                        .replaceAll("[", "")
                        .replaceAll("]", "")
                        .replaceAll(",", " و "),
                    listCount: controller.barrierCount.value,
                    isImage: true,
                    imageSource:
                        "assets/images/auto_search_setting/praying.png",
                    isChooseAll: controller.barrier.value.contains("-1"),
                    onTap: () {
                      List<String> barrierListId = InputData.barrierSearchListId
                          .map((e) => e.toString())
                          .toList();
                      _chooseOnTheList(
                          appTittle: "الحجاب",
                          listCheckedName: controller.barrierNameSelected,
                          isVisible: false,
                          countryShortNameList: barrierListId,
                          listChecked: controller.barrier.value,
                          itemDataList: barrierListId,
                          itemNameList: InputData.barrierSearchList,
                          value: controller.barrierCount,
                          context: context);
                    },
                  ),
          ],
        ));
  }

  chooseIdFromFixedList(list, listId, value) {
    var index = list.indexOf(value);
    var id = listId.elementAt(index);
    return id.toString();
  }

  _chooseOnTheList(
      {appTittle,
      countryShortNameList,
      listChecked,
      itemDataList,
      itemNameList,
      listCheckedName,
      value,
      isVisible,
      context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Get.to(ListOfItemsView(
        appTittle: appTittle,
        isVisible: isVisible,
        countryShortNameList: countryShortNameList,
        listChecked: listChecked,
        itemDataList: itemDataList,
        listCheckedName: listCheckedName,
        itemNameList: itemNameList,
        value: value,
      ));
    } else {
      showToast("يرجى التأكد من إتصالك بالإنترنت وإعادة المحاولة");
    }
  }
}
