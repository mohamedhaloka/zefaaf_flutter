import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/models/city.modal.dart';
import 'package:zeffaf/pages/city.list/city_loader.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';
import 'package:zeffaf/widgets/search_form_field.dart';

import 'city.list.controller.dart';
import 'city.list.dart';

class CityListView extends StatefulWidget {
  CityListView({
    this.cityList,
    this.visibleToSearch,
  });

  List? cityList;
  bool? visibleToSearch;

  @override
  _CityListViewState createState() => _CityListViewState();
}

class _CityListViewState extends State<CityListView> {
  CityListController controller = CityListController();

  @override
  void initState() {
    controller.searchController.addListener(() {
      setState(() {
        controller.filter.value = controller.searchController.text;
      });
    });
    fetchData();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels ==
          controller.scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });
    super.initState();
  }

  fetchData() {
    controller.getCityList(controller.currentPage).then((value) {
      if (controller.currentPage > controller.pages) {
        return null;
      } else {
        controller.currentPage++;
        controller.cityDataList.add(CityModal(
            id: 0, nameEn: "All", nameAr: "الكل", active: 1, special: 0));
        controller.cityDataList.addAll(value!);
      }
      setState(() {
        controller.cityLoading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().blueBackground,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: customAppBar("المدن"),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
              children: <Widget>[
                SearchTextField(
                    controller: controller.searchController,
                    tittle: "المدن",
                    fillColor: controller.appController.isMan.value == 0
                        ? Get.theme.primaryColor.withOpacity(0.6)
                        : Get.theme.colorScheme.secondary.withOpacity(0.6)),
                controller.cityLoading.value
                    ? CityLoader()
                    : CityList(
                        filter: controller.filter.value,
                        visibleToSearch: widget.visibleToSearch!,
                        scrollController: controller.scrollController,
                        cityList: controller.cityDataList.value,
                      ),
              ],
            ),
          )),
    );
  }
}
