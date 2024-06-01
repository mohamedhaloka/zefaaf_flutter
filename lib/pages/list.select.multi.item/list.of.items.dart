import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/grouped_checkbox.dart';
import 'list.select.multi.item.controller.dart';

class ListOfItems extends GetView<ListSelectMultiItemController> {
  ListOfItems({
    required this.listChecked,
    required this.itemDataList,
    required this.itemNameList,
    required this.countryShortNameList,
    required this.listCheckedName,
    required this.filter,
    required this.value,
    required this.isVisible,
  });
  List<String>? listChecked;
  List? itemDataList, itemNameList, countryShortNameList;
  String? filter;
  bool? isVisible;
  RxString? value;
  RxList<String>? listCheckedName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildCountry(
        listChecked!,
        itemDataList,
        itemNameList,
        countryShortNameList,
      ),
    );
  }

  Widget buildCountry(List<String> listChecked, itemDataList, itemNameList,
      countryShortNameList) {
    return StatefulBuilder(
      builder: (context, setState) {
        return GroupedCheckbox(
            itemList: itemDataList,
            checkedItemList: listChecked,
            // disabled: listChecked.contains("-1")
            //     // || listChecked.contains("0")
            //     ? controller.disabledList
            //     : [],
            filter: filter!,
            onChanged: (val, val2) {
              print('llll');
              setState(() {
                this.listCheckedName = val2;
                // print("Disabled List ${controller.disabledList}");
                print("List Id $val");
                print("List Named $val2");
                value!.value = val.length.toString();
              });
            },
            isVisible: isVisible,
            listCheckedName: listCheckedName ?? [],
            wrapCrossAxisAlignment: WrapCrossAlignment.center,
            wrapAlignment: WrapAlignment.spaceBetween,
            wrapRunAlignment: WrapAlignment.spaceBetween,
            wrapRunSpacing: 100.0,
            countryName: itemNameList,
            countryShortName: countryShortNameList,
            orientation: CheckboxOrientation.VERTICAL);
      },
    );
  }
}

/*
 * */
