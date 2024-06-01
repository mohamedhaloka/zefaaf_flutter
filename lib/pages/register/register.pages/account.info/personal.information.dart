import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/city.list/view.dart';
import 'package:zeffaf/pages/country.code/view.dart';
import 'package:zeffaf/pages/register/register.pages/account.info/account.information.controller.dart';
import 'package:zeffaf/pages/register/widgets/container.box.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/custom_text_field.dart';

import '../../../../utils/toast.dart';

class PersonalInformation extends GetView<AccountInformationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "البيانات الشخصية",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              ContainerBox(
                onPress: () {
                  Get.to(() => CountryCode(
                        type: "nationality",
                        visibleToSearch: false,
                        visible: false,
                      ));
                },
                countryCode:
                    controller.countryCodeController.nationalityName.value == ""
                        ? false
                        : true,
                imgSrc: controller.countryCodeController.nationalityImage.value
                    .toLowerCase(),
                tittle: "الجنسية",
                countryName:
                    controller.countryCodeController.nationalityName.value,
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              ContainerBox(
                onPress: () {
                  Get.to(() => CountryCode(
                        visible: false,
                        visibleToSearch: false,
                        type: "country",
                      ));
                },
                countryCode:
                    controller.countryCodeController.countryName.value == ""
                        ? false
                        : true,
                imgSrc: controller.countryCodeController.countryImage.value
                    .toLowerCase(),
                tittle: "مكان الإقامة",
                countryName: controller.countryCodeController.countryName.value,
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              ContainerBox(
                onPress: () {
                  controller.countryCodeController.countryName.value == ""
                      ? showToast("يجب إختيار مكان الإقامة أولاً")
                      : Get.to(() => CityListView(
                            visibleToSearch: false,
                            cityList:
                                controller.cityListController.cityDataList,
                          ));
                },
                tittle: "المدينة",
                countryName: controller.cityListController.cityName.value,
                imgSrc: "none",
                countryCode: controller.cityListController.cityName.value == ""
                    ? false
                    : true,
              ),
              const CustomSizedBox(heightNum: 0.01, widthNum: 0.0),
              CustomTextFormField(
                  controller: controller.fullName,
                  onSaved: (val) {
                    controller.fullName.text = val;
                  },
                  errorText: 'اسمك الحقيقي لن يظهر للمستخدمين',
                  tittle: "الإسم بالكامل"),
            ],
          ),
        ));
  }
}
