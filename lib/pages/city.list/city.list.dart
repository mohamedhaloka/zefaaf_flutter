import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/city.modal.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/fade.animation.dart';

import 'city.list.controller.dart';

class CityList extends GetView<CityListController> {
  CityList(
      {required this.filter,
      required this.cityList,
      required this.visibleToSearch,
      required this.scrollController});
  String filter;
  ScrollController scrollController;
  List<CityModal> cityList;
  bool visibleToSearch;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: visibleToSearch ? cityList.length : cityList.length - 1,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Get.theme.scaffoldBackgroundColor),
            child: filter == ""
                ? buildCountry(cityList[visibleToSearch ? index : index + 1])
                : cityList[index]
                        .nameAr!
                        .toLowerCase()
                        .contains(filter.toLowerCase())
                    ? visibleToSearch
                        ? buildCountry(cityList[index])
                        : cityList[index].nameAr == "الكل"
                            ? Container()
                            : buildCountry(cityList[index])
                    : Container(),
          );
        },
      ),
    );
  }

  Widget buildCountry(CityModal city) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            controller.cityName.value = city.nameAr!;
            controller.cityId(city.id);
            Get.back();
          },
          child: FadeAnimation(
            delay: 0.6,
            child: Row(
              children: [
                const CustomSizedBox(
                  widthNum: 0.02,
                  heightNum: 0.0,
                ),
                Text(
                  "${city.nameAr}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Divider(
          endIndent: 20,
          indent: 10,
          color: AppTheme.LIGHT_GREY,
        )
      ],
    );
  }
}
