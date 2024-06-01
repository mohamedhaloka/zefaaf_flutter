import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/city.list/view.dart';
import 'package:zeffaf/pages/country.code/view.dart';
import 'package:zeffaf/pages/register/widgets/container.box.dart';
import 'package:zeffaf/utils/input_data.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/drop_down_register.dart';

import '../../utils/toast.dart';
import 'searchFilter.controller.dart';

class SearchResultList extends GetView<SearchFilterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding:
              const EdgeInsets.only(top: 20, right: 15, left: 15, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Get.theme.scaffoldBackgroundColor),
            child: SingleChildScrollView(
              child: buildOptionalFilter(context),
            ),
          ),
        ));
  }

  Widget buildOptionalFilter(context) {
    return Column(
      children: [
        ContainerBox(
          onPress: () {
            Get.to(CountryCode(
              visible: false,
              visibleToSearch: true,
              type: "nationality",
            ));
          },
          countryCode:
              controller.countryCodeController.nationalityName.value == ""
                  ? false
                  : true,
          imgSrc: controller.countryCodeController.nationalityImage.value
              .toLowerCase(),
          tittle: "الجنسية",
          countryName: controller.countryCodeController.nationalityName.value,
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        ContainerBox(
          onPress: () {
            Get.to(() => CountryCode(
                  visible: false,
                  visibleToSearch: true,
                  type: "country",
                ));
          },
          countryCode: controller.countryCodeController.countryName.value == ""
              ? false
              : true,
          imgSrc:
              controller.countryCodeController.countryImage.value.toLowerCase(),
          tittle: "مكان الاقامة",
          countryName: controller.countryCodeController.countryName.value,
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        ContainerBox(
          onPress: () {
            controller.countryCodeController.countryName.value == ""
                ? showToast("يجب إختيار مكان الإقامة أولاً")
                : Get.to(() => CityListView(
                      visibleToSearch: true,
                      cityList: controller.cityListController.cityDataList,
                    ));
          },
          tittle: "المدينة",
          countryName:
              controller.countryCodeController.countryName.value == "الكل"
                  ? "الكل"
                  : controller.cityListController.cityName.value,
          imgSrc: "none",
          countryCode:
              controller.countryCodeController.countryName.value == "الكل"
                  ? true
                  : controller.cityListController.cityName.value == ""
                      ? false
                      : true,
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        DropdownRegister(
          dropdownValue: controller.socialStatus.value,
          tittle: "الحالة الإجتماعية",
          list: controller.appController.isMan.value == 0
              ? InputData.socialStatusWomanSearchList
              : InputData.socialStatusManSearchList,
          onChange: (val) {
            controller.socialStatus.value = val!;
            if (controller.appController.isMan.value == 1) {
              controller.socialStatusId.value = chooseIdFromFixedList(
                  InputData.socialStatusManSearchList,
                  InputData.socialStatusManSearchListId,
                  controller.socialStatus.value);
              // print(controller.socialStatusId.value);
            } else {
              controller.socialStatusId.value = chooseIdFromFixedList(
                  InputData.socialStatusWomanSearchList,
                  InputData.socialStatusWomanSearchListId,
                  controller.socialStatus.value);
              // print(controller.socialStatusId.value);
            }
          },
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        DropdownRegister(
          dropdownValue: controller.marriageType.value,
          tittle: "نوع الزواج",
          list: InputData.kindOfMarriageSearchList,
          onChange: (val) {
            controller.marriageType.value = val!;
            controller.marriageTypeId.value = chooseIdFromFixedList(
                InputData.kindOfMarriageSearchList,
                InputData.kindOfMarriageSearchListId,
                controller.marriageType.value);
          },
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        DropdownRegister(
          dropdownValue: controller.education.value,
          tittle: "المؤهل التعليمي",
          list: InputData.educationalQualificationSearchList,
          onChange: (val) {
            controller.education.value = val!;

            controller.educationId.value = chooseIdFromFixedList(
                InputData.educationalQualificationSearchList,
                InputData.educationalQualificationSearchListId,
                controller.education.value);
          },
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        controller.appController.isMan.value == 0
            ? Column(
                children: [
                  DropdownRegister(
                    dropdownValue: controller.barrier.value,
                    tittle: "الحجاب",
                    list: InputData.barrierSearchList,
                    onChange: (val) {
                      controller.barrier.value = val!;

                      controller.barrierId.value = chooseIdFromFixedList(
                          InputData.barrierSearchList,
                          InputData.barrierSearchListId,
                          controller.barrier.value);
                    },
                  ),
                  const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
                ],
              )
            : const SizedBox(),
        DropdownRegister(
          dropdownValue: controller.financialStatus.value,
          tittle: "الوضع المادي",
          list: InputData.financialStatusSearchList,
          onChange: (val) {
            controller.financialStatus.value = val!;
            controller.financialStatusId.value = chooseIdFromFixedList(
                InputData.financialStatusSearchList,
                InputData.financialStatusSearchListId,
                controller.financialStatus.value);
          },
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        DropdownRegister(
          dropdownValue: controller.workField.value,
          tittle: "مجال العمل",
          list: InputData.jobSearchList,
          onChange: (val) {
            controller.workField.value = val!;
            controller.workFieldId.value = chooseIdFromFixedList(
                InputData.jobSearchList,
                InputData.jobSearchListId,
                controller.workField.value);
          },
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "العمر",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
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
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "الوزن",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
            Row(
              children: [
                Expanded(
                  child: DropdownRegister(
                    dropdownValue: controller.weightFrom.value,
                    tittle: "من",
                    list: InputData.widthList,
                    onChange: (val) {
                      controller.weightFrom.value = val!;
                    },
                  ),
                ),
                const CustomSizedBox(
                  widthNum: 0.025,
                  heightNum: 0.0,
                ),
                Expanded(
                  child: DropdownRegister(
                    dropdownValue: controller.weightTo.value,
                    tittle: "إلى",
                    list: InputData.widthList,
                    onChange: (val) {
                      controller.weightTo.value = val!;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const CustomSizedBox(heightNum: 0.025, widthNum: 0.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "الطول",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const CustomSizedBox(heightNum: 0.015, widthNum: 0.0),
            Row(
              children: [
                Expanded(
                  child: DropdownRegister(
                    dropdownValue: controller.heightFrom.value,
                    tittle: "من",
                    list: InputData.heightList,
                    onChange: (val) {
                      controller.heightFrom.value = val!;
                    },
                  ),
                ),
                const CustomSizedBox(
                  widthNum: 0.025,
                  heightNum: 0.0,
                ),
                Expanded(
                  child: DropdownRegister(
                    dropdownValue: controller.heightTo.value,
                    tittle: "إلى",
                    list: InputData.heightList,
                    onChange: (val) {
                      controller.heightTo.value = val!;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const CustomSizedBox(
          widthNum: 0.0,
          heightNum: 0.04,
        ),
        CustomRaisedButton(
          loading: controller.searching.value,
          onPress: () async {
            await Get.toNamed("/SearchResult", arguments: [
              context,
              0,
              controller.searchController.text,
              controller.countryCodeController.countryId.value,
              controller.cityListController.cityId.value,
              controller.marriageTypeId.value,
              controller.socialStatusId.value,
              controller.countryCodeController.nationalityId.value,
              controller.workFieldId.value,
              controller.educationId.value,
              controller.barrierId.value,
              controller.financialStatusId.value,
              controller.ageTo.value,
              controller.ageFrom.value,
              controller.weightFrom.value,
              controller.weightTo.value,
              controller.heightFrom.value,
              controller.heightTo.value
            ]);
            controller.emptyValues();
          },
          tittle: "بحث",
          fontSize: 22,
          height: 50,
          color: controller.appController.isMan.value == 0
              ? Get.theme.primaryColor
              : Get.theme.colorScheme.secondary,
        )
      ],
    );
  }

  chooseIdFromFixedList(list, listId, value) {
    var index = list.indexOf(value);
    var id = listId.elementAt(index);
    return id.toString();
  }
}
