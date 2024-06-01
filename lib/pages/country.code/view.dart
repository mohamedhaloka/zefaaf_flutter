import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/country.code/countrycode.controller.dart';
import 'package:zeffaf/utils/theme.dart';
import 'package:zeffaf/widgets/custom_app_bar.dart';
import 'package:zeffaf/widgets/search_form_field.dart';

import 'country.list.dart';

class CountryCode extends StatefulWidget {
  CountryCode({this.visible, this.type, this.visibleToSearch});
  bool? visible;
  bool? visibleToSearch;
  String? type;
  @override
  _CountryCodeState createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryCode>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  CountryCodeController controller = Get.put(CountryCodeController());
  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme().blueBackground,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: customAppBar(widget.type == "country" ? "الدول" : "الجنسية"),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Obx(() => Column(
                  children: <Widget>[
                    SearchTextField(
                      controller: controller.searchController,
                      tittle: widget.type == "country" ? "البلد" : "الجنسية",
                      fillColor: controller.appController.isMan.value == 0
                          ? Get.theme.primaryColor.withOpacity(0.6)
                          : Get.theme.colorScheme.secondary.withOpacity(0.6),
                    ),
                    controller.countryLoading.value
                        ? CircularProgressIndicator(
                            valueColor: animationController.drive(ColorTween(
                                begin: Get.theme.primaryColor,
                                end: Get.theme.colorScheme.secondary)))
                        : CountryList(
                            filter: controller.filter.value,
                            scrollController: controller.scrollController,
                            countryList: controller.countryDataList.value,
                            visible: widget.visible!,
                            visibleToSearch: widget.visibleToSearch!,
                            type: widget.type!,
                          ),
                  ],
                )),
          )),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.searchController.clear();
    super.dispose();
  }
}
