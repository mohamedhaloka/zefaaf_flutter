import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/country.code.dart';
import 'package:zeffaf/pages/city.list/city.list.controller.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_sized_box.dart';
import 'package:zeffaf/widgets/fade.animation.dart';

class CountryList extends GetView<CountryCodeController> {
  CountryList(
      {required this.filter,
      required this.countryList,
      required this.scrollController,
      required this.type,
      required this.visible,
      required this.visibleToSearch});
  String filter, type;
  bool visible, visibleToSearch;

  ScrollController? scrollController;
  List<CountryData> countryList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount:
            visibleToSearch ? countryList.length : countryList.length - 1,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Get.theme.scaffoldBackgroundColor),
            child: filter == ""
                ? buildCountry(countryList[visibleToSearch ? index : index + 1])
                : countryList[index]
                            .nameAr!
                            .toLowerCase()
                            .contains(filter.toLowerCase()) ||
                        countryList[index]
                            .phoneCode!
                            .toLowerCase()
                            .contains(filter.toLowerCase())
                    ? visibleToSearch
                        ? buildCountry(countryList[index])
                        : countryList[index].nameAr == "الكل"
                            ? Container()
                            : buildCountry(countryList[index])
                    : Container(),
          );
        },
      ),
    );
  }

  Widget buildCountry(CountryData data) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (type == "country") {
              final cityListController = Get.put(CityListController());
              controller.countryName.value = data.nameAr!;
              controller.countryId(data.id.toString());
              controller.countryCode.value = data.phoneCode!;
              controller.countryImage.value = data.shortcut!;
              cityListController.cityName("");
              Get.back();
            } else if (type == "nationality") {
              controller.nationalityName.value = data.nameAr!;
              controller.nationalityCode.value = data.phoneCode!;
              controller.nationalityImage.value = data.shortcut!;
              controller.nationalityId(data.id.toString());
              Get.back();
            }
          },
          child: FadeAnimation(
            delay: 0.6,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                          image: ExactAssetImage(
                              'assets/images/flags/${data.shortcut!.toLowerCase()}.png'),
                          fit: BoxFit.cover)),
                ),
                const CustomSizedBox(heightNum: 0.0, widthNum: 0.02),
                Visibility(
                  visible: visible == null ? true : false,
                  child: Text(
                    "${data.phoneCode}",
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const CustomSizedBox(heightNum: 0.0, widthNum: 0.014),
                Text("${data.nameAr}", style: const TextStyle(fontSize: 14))
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
