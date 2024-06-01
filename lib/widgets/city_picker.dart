import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/city.list/city.list.controller.dart';
import 'package:zeffaf/pages/city.list/view.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/pages/register/widgets/container.box.dart';

import '../utils/toast.dart';

class CityPicker extends StatelessWidget {
  final CountryCodeController countryCodeController;
  final CityListController cityListController;
  @override
  Widget build(BuildContext context) {
    return ContainerBox(
      onPress: () {
        countryCodeController.countryName.value == ""
            ? showToast("يجب إختيار مكان الإقامة أولاً")
            : Get.to(CityListView(
                visibleToSearch: false,
                cityList: cityListController.cityDataList,
              ));
      },
      tittle: "المدينة",
      countryName: cityListController.cityName.value,
      imgSrc:
          "https://www.instructorlive.com/wp-content/themes/instructorlive/images/thumbnail-default.jpg",
      countryCode: cityListController.cityName.value == "" ? false : true,
    );
  }

  const CityPicker(this.countryCodeController, this.cityListController);
}
