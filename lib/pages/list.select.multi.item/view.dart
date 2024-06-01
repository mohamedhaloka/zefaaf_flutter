import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';
import 'package:zeffaf/widgets/custom_raised_button.dart';
import 'package:zeffaf/widgets/search_form_field.dart';

import 'list.of.items.dart';
import 'list.select.multi.item.controller.dart';
import 'list.select.multi.item.loader.dart';

class ListOfItemsView extends GetView<ListSelectMultiItemController> {
  ListOfItemsView(
      {this.appTittle,
      this.listChecked,
      this.countryShortNameList,
      this.itemDataList,
      this.isVisible,
      this.listCheckedName,
      this.value,
      this.itemNameList});
  String? appTittle;
  List<String>? listChecked;
  List? countryShortNameList, itemNameList, itemDataList;
  RxString? value;
  RxList<String>? listCheckedName;
  bool? isVisible;
  ListSelectMultiItemController countrySelectModelController =
      Get.put(ListSelectMultiItemController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().blueBackground,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: customAppBar(appTittle, onTap: () {}),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Obx(() => Column(
                  children: <Widget>[
                    SearchTextField(
                      controller: countrySelectModelController.searchController,
                      tittle: appTittle,
                      fillColor: countrySelectModelController
                                  .appController.isMan.value ==
                              0
                          ? Get.theme.primaryColor.withOpacity(0.6)
                          : Get.theme.secondaryHeaderColor.withOpacity(0.6),
                    ),
                    controller.settingController.countryLoading.value
                        ? ListSelectMultiItemLoader()
                        : ListOfItems(
                            filter: countrySelectModelController.filter.value,
                            listChecked: listChecked,
                            listCheckedName: listCheckedName,
                            countryShortNameList: countryShortNameList,
                            itemDataList: itemDataList,
                            itemNameList: itemNameList,
                            value: value,
                            isVisible: isVisible),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CustomRaisedButton(
                        tittle: "تم",
                        color: countrySelectModelController
                                    .appController.isMan.value ==
                                0
                            ? Get.theme.primaryColor
                            : Get.theme.secondaryHeaderColor,
                        onPress: () {
                          Get.back();
                        },
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}
