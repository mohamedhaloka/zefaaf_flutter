import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/list.select.multi.item/view.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/country_picker.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';

import '../../utils/toast.dart';
import 'auto.search.setting.controller.dart';

class AutoSearchSettingMultiSelectItem
    extends GetView<AutoSearchSettingController> {
  const AutoSearchSettingMultiSelectItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            CountryPicker(
              title: "حالة التدخين",
              value: controller.smokingNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.smokingCount.value,
              isImage: true,
              imageSource: "assets/images/auto_search_setting/smoking.png",
              isChooseAll: controller.smoking.value.contains("0"),
              onTap: () {
                List<String> smokingStatusListString = ['0', '1', '2'];
                _chooseOnTheList(
                    appTittle: "حالة التدخين",
                    isVisible: false,
                    countryShortNameList: smokingStatusListString,
                    listChecked: controller.smoking.value,
                    itemDataList: smokingStatusListString,
                    listCheckedName: controller.smokingNameSelected,
                    itemNameList: ['الكل', 'نعم', 'لا'],
                    value: controller.smokingCount,
                    context: context);
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "الوضع المادي",
              value: controller.financialNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.financialCount.value,
              isImage: true,
              imageSource: "assets/images/auto_search_setting/financial.png",
              isChooseAll: controller.financial.value.contains("-1"),
              onTap: () {
                List<String> financialStatusListString = InputData
                    .financialStatusSearchListId
                    .map((e) => e.toString())
                    .toList();
                _chooseOnTheList(
                    appTittle: "الوضع المادي",
                    listCheckedName: controller.financialNameSelected,
                    isVisible: false,
                    countryShortNameList: financialStatusListString,
                    listChecked: controller.financial.value,
                    itemDataList: financialStatusListString,
                    itemNameList: InputData.financialStatusSearchList,
                    value: controller.financialCount,
                    context: context);
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "المؤهل التعليمي",
              isImage: true,
              imageSource: "assets/images/auto_search_setting/education.png",
              value: controller.educationNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.educationCount.value,
              isChooseAll: controller.education.value.contains("-1"),
              onTap: () {
                List<String> educationalQualificationListString = InputData
                    .educationalQualificationSearchListId
                    .map((e) => e.toString())
                    .toList();
                _chooseOnTheList(
                    appTittle: "المؤهل التعليمي",
                    listCheckedName: controller.educationNameSelected,
                    isVisible: false,
                    countryShortNameList: educationalQualificationListString,
                    listChecked: controller.education.value,
                    itemDataList: educationalQualificationListString,
                    itemNameList: InputData.educationalQualificationSearchList,
                    value: controller.educationCount,
                    context: context);
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "country".tr,
              value: controller.nationalityNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              listCount: controller.nationalityCountryCount.value,
              isImage: true,
              imageSource: "assets/images/auto_search_setting/nationality.png",
              isChooseAll: controller.nationalityCountryId.value.contains("0"),
              onTap: () {
                _chooseOnTheList(
                    appTittle: "الجنسية",
                    isVisible: true,
                    countryShortNameList: controller.countryShortNameList.value,
                    listChecked: controller.nationalityCountryId.value,
                    itemDataList: controller.countryIdList.value,
                    listCheckedName: controller.nationalityNameSelected,
                    itemNameList: controller.countryNameList.value,
                    value: controller.nationalityCountryCount,
                    context: context);
              },
            ),
            // const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            // CountryPicker(
            //   title: "المدينة",
            //   value: controller.cityNameSelected
            //       .toString()
            //       .replaceAll("[", "")
            //       .replaceAll("]", "")
            //       .replaceAll(",", " و "),
            //   listCount: controller.cityCount.value,
            //   isImage: true,
            //   imageSource: "assets/images/auto_search_setting/nationality.png",
            //   isChooseAll: controller.cityId.value.contains("0"),
            //   onTap: () {
            //     _chooseOnTheList(
            //         appTittle: "المدينة",
            //         isVisible: true,
            //         countryShortNameList: controller.countryShortNameList.value,
            //         listChecked: controller.cityId.value,
            //         itemDataList: controller.countryIdList.value,
            //         listCheckedName: controller.cityNameSelected,
            //         itemNameList: controller.countryNameList.value,
            //         value: controller.cityCount,
            //         context: context);
            //   },
            // ),
            const SizedBox(
              height: 10,
            ),
            CountryPicker(
              title: "place".tr,
              isImage: true,
              imageSource:
                  "assets/images/auto_search_setting/residentCountry.png",
              value: controller.residentCountryNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              isChooseAll: controller.residentCountryId.value.contains("0"),
              listCount: controller.residentCountryCount.value,
              onTap: () {
                _chooseOnTheList(
                    appTittle: "الدول",
                    isVisible: true,
                    countryShortNameList: controller.countryShortNameList.value,
                    listChecked: controller.residentCountryId.value,
                    itemDataList: controller.countryIdList.value,
                    itemNameList: controller.countryNameList.value,
                    listCheckedName: controller.residentCountryNameSelected,
                    value: controller.residentCountryCount,
                    context: context);
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "مجال العمل",
              isImage: true,
              imageSource: "assets/images/auto_search_setting/workField.png",
              value: controller.workFieldNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              isChooseAll: controller.workField.value.contains("-1"),
              listCount: controller.workFieldCount.value,
              onTap: () {
                List<String> workFieldListString =
                    InputData.jobSearchListId.map((e) => e.toString()).toList();

                _chooseOnTheList(
                    appTittle: "مجال العمل",
                    isVisible: false,
                    listCheckedName: controller.workFieldNameSelected,
                    countryShortNameList: workFieldListString,
                    listChecked: controller.workField.value,
                    itemDataList: workFieldListString,
                    itemNameList: InputData.jobSearchList,
                    value: controller.workFieldCount,
                    context: context);
                // print(controller.workField.remove(0));
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "لون البشرة",
              icon: Icons.color_lens,
              isImage: false,
              value: controller.skinColorNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              isChooseAll: controller.skinColor.value.contains("-1"),
              listCount: controller.skinColorCount.value,
              onTap: () {
                List<String> skinColourListString = InputData
                    .skinColourSearchListId
                    .map((e) => e.toString())
                    .toList();

                _chooseOnTheList(
                    appTittle: "لون البشرة",
                    listCheckedName: controller.skinColorNameSelected,
                    isVisible: false,
                    countryShortNameList: skinColourListString,
                    listChecked: controller.skinColor.value,
                    itemDataList: skinColourListString,
                    itemNameList: InputData.skinColourSearchList,
                    value: controller.skinColorCount,
                    context: context);
                // print(controller.workField.remove(0));
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "متوسط الدخل الشهري",
              isImage: true,
              imageSource: "assets/images/auto_search_setting/montlyIncome.png",
              value: controller.incomeNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              isChooseAll: controller.income.value.contains("-1"),
              listCount: controller.incomeCount.value,
              onTap: () {
                List<String> monthlyIncomeLevelListString = InputData
                    .monthlyIncomeLevelSearchListId
                    .map((e) => e.toString())
                    .toList();

                _chooseOnTheList(
                    appTittle: "متوسط الدخل الشهري",
                    isVisible: false,
                    listCheckedName: controller.incomeNameSelected,
                    countryShortNameList: monthlyIncomeLevelListString,
                    listChecked: controller.income.value,
                    itemDataList: monthlyIncomeLevelListString,
                    itemNameList: InputData.monthlyIncomeLevelSearchList,
                    value: controller.incomeCount,
                    context: context);
                // print(controller.workField.remove(0));
              },
            ),
            const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
            CountryPicker(
              title: "الصحة",
              isImage: true,
              imageSource: "assets/images/auto_search_setting/health.png",
              value: controller.healthNameSelected
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .replaceAll(",", " و "),
              isChooseAll: controller.health.value.contains("-1"),
              listCount: controller.healthCount.value,
              onTap: () {
                List<String> healthStatusListString = InputData
                    .healthStatusSearchListId
                    .map((e) => e.toString())
                    .toList();

                _chooseOnTheList(
                    appTittle: "الصحة",
                    listCheckedName: controller.healthNameSelected,
                    isVisible: false,
                    countryShortNameList: healthStatusListString,
                    listChecked: controller.health.value,
                    itemDataList: healthStatusListString,
                    itemNameList: InputData.healthStatusSearchList,
                    value: controller.healthCount,
                    context: context);
                // print(controller.workField.remove(0));
              },
            ),
          ],
        ));
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
        listCheckedName: listCheckedName,
        itemDataList: itemDataList,
        itemNameList: itemNameList,
        value: value,
      ));
    } else {
      showToast("يرجى التأكد من إتصالك بالإنترنت وإعادة المحاولة");
    }
  }
}
